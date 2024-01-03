import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:expense_tracker/screens/transactions/transaction_details.dart' as transaction_details;
import 'package:expense_tracker/services/services.dart' as services;
import 'package:expense_tracker/utils/constants.dart' as constants;


class TransactionList extends StatefulWidget {
  const TransactionList({super.key});

  @override
  TransactionListState createState() => TransactionListState();
}

class TransactionListState extends State<TransactionList> {

  List<Map<String, dynamic>> transactions = [];
  final ScrollController _scrollController = ScrollController();
  final int limit = 10;
  int offset = 0;
  bool isLoadingTransactions = true;
  bool isLoadingOptions = true;
  List<String> transactionMonths = ['All'];
  int? month, year;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    getInitialTransactionList();
    getFilterOptionsList();
    month = null;
    year = null;
  }

  Future<void> getFilterOptionsList() async {
    final db = Provider.of<services.Services>(context, listen: false).getDB();
    final availableMonths = await db.rawQuery('''
      SELECT DISTINCT month, year 
      FROM transactions
      ORDER BY year DESC, month DESC
    ''');
    await Future.delayed(const Duration(milliseconds: 500), () {});

    setState((){
      transactionMonths.addAll(
        availableMonths.map((row){
          int month = int.parse(row['month'].toString());
          int year = int.parse(row['year'].toString());
          String option = "${constants.monthNumToName[month]}-$year";
          return option;
      }).toList());

      isLoadingOptions=false;
    });
  }

  Future<void> getInitialTransactionList() async{
    final db = Provider.of<services.Services>(context, listen: false).getDB();
    final queryResult = await db.rawQuery('''
      SELECT * FROM transactions
      ORDER BY year DESC, month DESC, day DESC, id DESC
      LIMIT $limit
    ''');

    await Future.delayed(const Duration(milliseconds: 500), () {});

    setState(() {
      transactions.addAll(queryResult);
      if (queryResult.length < limit) {
        _scrollController.removeListener(_onScroll);
      }else{
        offset += limit;
      }
      isLoadingTransactions=false;
    });
  }

  void _onScroll() {
    if(isLoadingTransactions){
      return;
    }
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
      // Load more data when the user scrolls to the end of the list
      _loadMoreDataOnScroll();
    }
  }

  Future<void> _loadMoreDataOnScroll({int? month, int? year}) async{
    setState((){
      isLoadingTransactions=true;
    });

    final db = Provider.of<services.Services>(context, listen: false).getDB();
    final List<Map<String, dynamic>> queryResult;

    if(month == null){
      queryResult = await db.rawQuery('''
        SELECT * FROM transactions
        ORDER BY year DESC, month DESC, day DESC, id DESC
        LIMIT $limit
        OFFSET $offset
      ''');
    }else{
      assert(year != null);
      queryResult = await db.rawQuery('''
        SELECT * FROM transactions
        WHERE month = $month AND year = $year
        ORDER BY year DESC, month DESC, day DESC, id DESC
        LIMIT $limit
        OFFSET $offset
      ''');
    }
    
    await Future.delayed(const Duration(milliseconds: 1000), () {});
    
    // SetState
    setState((){
      transactions.addAll(queryResult);
      // Disable scroll controller when there is no more data available
      if (queryResult.length < limit) {
        _scrollController.removeListener(_onScroll);
      }else{
        offset += limit;
      }
      isLoadingTransactions=false;
    }); // Call setState to trigger a rebuild
  }

  Future<void> reloadTransactionsOnOptionChange(int? month, int ?year) async{
    setState((){
      isLoadingTransactions=true;
      offset = 0;
      transactions.clear();
      // _scrollController.addListener(_onScroll);
      // very important to jump scroller to top
      _scrollController.jumpTo(0.0);

    });

    final db = Provider.of<services.Services>(context, listen: false).getDB();
    List<Map<String, dynamic>> queryResult;

    if(month == null){
      queryResult = await db.rawQuery('''
        SELECT * FROM transactions
        ORDER BY year DESC, month DESC, day DESC, id DESC
        LIMIT $limit
      ''');
    }else{
      assert(year != null);
      print("$year---$month\n");
      queryResult = await db.rawQuery('''
        SELECT * FROM transactions
        WHERE month = $month AND year = $year
        ORDER BY year DESC, month DESC, day DESC, id DESC
        LIMIT $limit
      ''');
      print(queryResult.map((e) => e['month']).toList());
    }
    await Future.delayed(const Duration(milliseconds: 500), () {});

    setState((){
      transactions.addAll(queryResult);
      // Disable scroll controller when there is no more data available
      if (queryResult.length < limit) {
        _scrollController.removeListener(_onScroll);
      }else{
        offset += limit;
      }
      isLoadingTransactions=false;
    });
  }

  Widget getFilterOptionsWidget(){
    if(isLoadingOptions){
      return const LinearProgressIndicator();
    }

    return Container(
      margin: EdgeInsets.only(
        left: MediaQuery.of(context).size.width * 0.1,
        right: MediaQuery.of(context).size.width * 0.1,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Expanded(
            child: DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Colors.white,
              ),
              value: transactionMonths[0],
              icon: const Icon(Icons.arrow_downward, color: Colors.deepPurple),
              iconSize: 24,
              elevation: 16,
              style: const TextStyle(color: Colors.deepPurple),
              onChanged: (String? newValue) {
                
                // if(newValue == 'All'){
                //   month = null; year=null;
                // }else{
                //   month = constants.monthNameToNum[newValue!.split('-')[0]];
                //   year = int.parse(newValue.split('-')[1]);
                // }
                // setState((){}); // call to update state
                // reloadTransactionsOnOptionChange(month, year);

              },
              items: transactionMonths.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Column(
                    children: [
                      Text(value, style: const TextStyle(fontSize: 16)),
                      const Divider(color: Colors.grey, height: 2),
                    ],
                  ),
                );
              }).toList()
            ),
          ),
        ],
      ),
    );
  }

  Widget getTransactionsListWidget(){
    if(transactions.isEmpty){
      if(isLoadingTransactions){
        return const Center(child: CircularProgressIndicator());
      }
      return const Center(child: Text('No transactions found'));
    }
    
    return ListView.builder(
      key: const PageStorageKey('transactionList'), // Add a PageStorageKey here
      controller: _scrollController,
      // itemCount: snapshot.data!.length,
      itemCount: (isLoadingTransactions ? transactions.length + 1 : transactions.length),
      itemBuilder: (context, index) {
        if (index >= transactions.length) {
          return const Center(child: CircularProgressIndicator());
        }
        final transaction = transactions[index];
        return InkWell(
          onTap: (){
            // print('Clicked card with transaction id: ${transaction['id']}');
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const transaction_details.TransactionDetails())
            );
          },
          child: Card(
            margin: const EdgeInsets.all(8.0),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: transaction['type'] == 'Debit'
                    ? Colors.red
                    : Colors.green,
                child: Text(transaction['title'][0]),
              ),
              title: Text(
                (transaction['title'].toString().length > 20)
                ? '${transaction['title'].toString().substring(0, 20)}...'
                : transaction['title'].toString(),
          
              ),
              subtitle: Text(
                // format to dd-mmm-yyyy
                DateFormat('dd-MMM-yyyy').format(
                  DateTime(transaction['year'], transaction['month'], transaction['day'])
                ).toString()
              ),
              trailing: Text(
                transaction['amount'].toStringAsFixed(2),
                style: TextStyle(
                  color: transaction['type'] == 'Debit'
                      ? Colors.red
                      : Colors.green,
                  fontSize: 20,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // write a beautiful UI with infinte scroll view here
    Widget filterOptionsWidget = getFilterOptionsWidget();
    Widget transactionListWidget = getTransactionsListWidget();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transactions List'),
      ),
      body: SafeArea(
        child: Container(
          margin: const EdgeInsets.all(10.0),
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              filterOptionsWidget,
              const SizedBox(height: 15),
              Expanded(
                child: transactionListWidget,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
