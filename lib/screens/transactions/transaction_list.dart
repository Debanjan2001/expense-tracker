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

  @override
  void initState() {
    super.initState();
    getTransactionList(allRequired: true);
    _scrollController.addListener(_onScroll);
  }

  Future<void> getTransactionList({bool allRequired=false, int? month, int? year}) async{
    final db = Provider.of<services.Services>(context, listen: false).getDB();
    final List<Map<String, dynamic>> queryResult;

    if(allRequired){
      queryResult = await db.rawQuery('''
        SELECT * FROM transactions
        ORDER BY year DESC, month DESC, day DESC, id DESC
        LIMIT $limit
      ''');
    }else{
      queryResult = await db.rawQuery('''
        SELECT * FROM transactions
        WHERE month = $month AND year = $year
        ORDER BY year DESC, month DESC, day DESC, id DESC
      ''');
    }

    final availableMonths = await db.rawQuery('''
      SELECT DISTINCT month, year 
      FROM transactions
      ORDER BY year DESC, month DESC
    ''');

    await Future.delayed(const Duration(milliseconds: 500), () {});

    setState(() {
      transactions.addAll(queryResult);
      transactionMonths.addAll(
        availableMonths.map((row){
          int month = int.parse(row['month'].toString());
          int year = int.parse(row['year'].toString());
          String option = "${constants.monthNames[month]}-$year";
          return option;
      }).toList());

      if (queryResult.length < limit) {
        _scrollController.removeListener(_onScroll);
      }else{
        offset += limit;
      }
      isLoadingTransactions=false;
      isLoadingOptions=false;
    });
  }

  void _onScroll() {
    if(isLoadingTransactions){
      return;
    }
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
      // Load more data when the user scrolls to the end of the list
      _loadMoreData();
    }
  }

  Future<void> _loadMoreData() async{
    setState((){
      isLoadingTransactions=true;
    });

    final db = Provider.of<services.Services>(context, listen: false).getDB();
    final queryResult = await db.rawQuery('''
      SELECT * FROM transactions
      ORDER BY year DESC, month DESC, day DESC, id DESC
      LIMIT $limit
      OFFSET $offset
    ''');
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

  Widget getFilterOptionsWidget(){
    if(isLoadingOptions){
      return const LinearProgressIndicator();
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Expanded(
          child: DropdownButtonFormField<String>(
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            filled: true,
            fillColor: Colors.white,
          ),
          value: 'All',
          icon: const Icon(Icons.arrow_downward),
          iconSize: 24,
          elevation: 16,
          style: const TextStyle(color: Colors.deepPurple),
          onChanged: (String? newValue) {
            // print('Selected $newValue');
          },
          items: transactionMonths.map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList()
          ),
        ),
      ],
    );
  }

  Widget getTransactionsListWidget(){
    if(transactions.isEmpty){
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
