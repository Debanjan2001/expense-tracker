import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:expense_tracker/services/services.dart' as services;
import 'package:expense_tracker/screens/transactions/transaction_list.dart' as transaction_list;

class TransactionsWidget extends StatefulWidget {
  const TransactionsWidget({super.key});

  @override
  State<TransactionsWidget> createState() => _TransactionsWidgetState();
}

class _TransactionsWidgetState extends State<TransactionsWidget> {
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
      columns: ['title', 'amount', 'type', 'day', 'month', 'year'],
      orderBy: 'id DESC',
      limit: 3,
    );
    await Future.delayed(const Duration(milliseconds: 500), () {});
    return queryResult;
  }

  Widget getLastThreeTransactionsWidget() {
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
        }

        if (snapshot.data!.isEmpty) {
          return const Text('No transactions found');
        }

        return Column(
          children: snapshot.data!.map((transaction) {
            return Card(
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
            );
          }).toList(),
        );
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
        year = ${startDayOfMonth.year}
        AND
        month = ${startDayOfMonth.month}
        AND
        day >= ${startDayOfMonth.day}
        AND
        day <= ${lastDayOfMonth.day}
      ''',
    );
    await Future.delayed(const Duration(milliseconds: 500), () {});

    // sleep for 1000ms
    double sum = ((queryResult[0]['sum'] ?? 0.0) as num).toDouble();
    return sum;
  }

  Widget getMonthlyExpenseWidget() {
    return FutureBuilder<double>(
      future: monthlyExpenseAmount,
      builder: (BuildContext context, AsyncSnapshot<double> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('${snapshot.error}');
        } else {
          return Card(
            margin: const EdgeInsets.all(8.0),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const Text(
                    "This Month's Expense",
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  Text(
                    'INR ${snapshot.data!.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 24.0,
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // get sum of all transactions
    Widget monthlyExpenseWidget = getMonthlyExpenseWidget();
    Widget lastThreeTransactionsWidget = getLastThreeTransactionsWidget();

    return GestureDetector(
      onTap: (){
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const transaction_list.TransactionList(),
          )
        );
      },
      child: Container(
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
                const Text('Recent Transactions'),
                const SizedBox(height: 20),
                lastThreeTransactionsWidget,
                const SizedBox(height: 20),
                monthlyExpenseWidget,
                const SizedBox(height: 20),
                ButtonBar(
                  alignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const transaction_list.TransactionList(),
                          )
                        );
                      },
                      child: const Text('View Details'),
                    ),
                  ],
                ),
              ],
            ),
          )),
    );
  }
}
