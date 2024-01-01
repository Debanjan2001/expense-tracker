import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:expense_tracker/services/services.dart' as services;


class TransactionsWidget extends StatefulWidget {
  const TransactionsWidget({super.key});

  @override
  State<TransactionsWidget> createState() => _TransactionsWidgetState();
}

class _TransactionsWidgetState extends State<TransactionsWidget>{

  late Future<double> monthlyExpenseAmount;
  late Future<List> lastThreeTransactions;
  @override
  void initState() {
    super.initState();
    monthlyExpenseAmount = getAmount();
    lastThreeTransactions = getLastThreeTransactions();
  }

  Future<List> getLastThreeTransactions() async {
    final db = Provider.of<services.Services>(context, listen: false).getDB();
    final queryResult = await db.query(
      'transactions',
      columns: ['title', 'amount', 'date', 'type'],
      orderBy: 'id DESC',
      limit: 3,
    );
    await Future.delayed(const Duration(milliseconds: 500), (){});
    return queryResult;
  }

  Widget getLastThreeTransactionsWidget(){
    return FutureBuilder<List>(
      future: lastThreeTransactions,
      builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
            padding: const EdgeInsets.all(20),
            margin: const EdgeInsets.all(20),
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                LinearProgressIndicator(),
                SizedBox(height: 25),
                LinearProgressIndicator(),
                SizedBox(height: 25),
                LinearProgressIndicator(),
              ],
            ),
         );


        } else if (snapshot.hasError) {
          return Text('${snapshot.error}');
        } else {
          return Column(
            children: [
              const Text('Last 3 Transactionconst s: '),
              for (var transaction in snapshot.data!)
                Text("${transaction['title']} - ${transaction['type']} - ${transaction['amount']} - ${transaction['date'].toString().substring(0, 10)}",
                  style: TextStyle(
                    color: (transaction['type'] == 'Debit'
                        ? Colors.red
                        : Colors.green),
                  ), 
                ),
            ],
          );
        }
      },
    );
  }

  Future<double> getAmount() async {
    final db = Provider.of<services.Services>(context, listen: false).getDB();
    DateTime now = DateTime.now();
    DateTime startDayOfMonth = DateTime(now.year, now.month, 1);
    DateTime lastDayOfMonth = DateTime(now.year, now.month + 1, 0);

    final queryResult = await db.query(
      'transactions',
      columns: ['SUM(amount) as sum'],
      where: '''
        type = 'Debit'
        AND
        date >= '${startDayOfMonth.toIso8601String()}'
        AND
        date <= '${lastDayOfMonth.toIso8601String()}'
      ''',      
    );
    await Future.delayed(const Duration(milliseconds: 500), (){});

    // sleep for 1000ms
    double sum = (queryResult[0]['sum'] as num).toDouble();
    return sum;
  }

  Widget getMonthlyExpenseWidget(){
    return FutureBuilder<double>(
      future: monthlyExpenseAmount,
      builder: (BuildContext context, AsyncSnapshot<double> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('${snapshot.error}');
        } else {
          return Text('${snapshot.data}');
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // get sum of all transactions
    Widget monthlyExpenseWidget = getMonthlyExpenseWidget();
    Widget lastThreeTransactionsWidget = getLastThreeTransactionsWidget();

    return Container(
        margin: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          // color: Colors.grey,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: Colors.orange,
            width: 2,
          ),
        ),
        child: Container(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              const Text('Latest Transactions'),
              const SizedBox(height: 20),
              lastThreeTransactionsWidget,
              const SizedBox(height: 20),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Total Amount Spent this month:'),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('INR'),
                      const SizedBox(width: 10),
                      monthlyExpenseWidget,
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ButtonBar(
                alignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        monthlyExpenseAmount = getAmount();
                        lastThreeTransactions = getLastThreeTransactions();
                      });
                    },
                    child: const Text('View Details'),
                  ),
                ],
              ),
            ],
          ),
        ));
  }
}
