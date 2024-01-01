import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:expense_tracker/services/services.dart' as services;
import 'package:provider/provider.dart';

class AnalyticsWidget extends StatefulWidget {
  const AnalyticsWidget({super.key});

  @override
  State<AnalyticsWidget> createState() => _AnalyticsWidgetState();
}

class _AnalyticsWidgetState extends State<AnalyticsWidget> {

  late Future<List> debitQueryResult;
  // late Future<List> creditQueryResult;

  Future<List> getDebitTransactions() async {
    final db = Provider.of<services.Services>(context, listen: false).getDB();
    final queryResult = await db.rawQuery('''
      SELECT month, year, SUM(amount) as sum
      FROM transactions
      WHERE type = 'Debit'
      GROUP BY year, month
      ORDER BY year DESC, month DESC
    ''');
    await Future.delayed(const Duration(milliseconds: 500), () {});
    return queryResult;
  }

  // Todo: fix this
  // Widget drawChart(){
  //   return FutureBuilder<List>(
  //     future: debitQueryResult,
  //     builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
  //       if (snapshot.connectionState == ConnectionState.waiting) {
  //         return Container(
  //           padding: const EdgeInsets.all(20),
  //           margin: const EdgeInsets.all(20),
  //           child: const Column(
  //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //             children: [
  //               LinearProgressIndicator(),
  //               SizedBox(height: 25),
  //               LinearProgressIndicator(),
  //               SizedBox(height: 25),
  //               LinearProgressIndicator(),
  //             ],
  //           ),
  //         );
  //       } else if (snapshot.hasError) {
  //         return Text('${snapshot.error}');
  //       }

  //       if (snapshot.data!.isEmpty) {
  //         return const Text('No transactions found');
  //       }

  //       List<String> uniqueDates = snapshot.data!
  //       .map((row) => row['month'].toString() + row['year'].toString())
  //       .toSet()
  //       .toList();

  //       Map<String, double> dateMapping = {};
  //       for (int i = 0; i < uniqueDates.length; i++) {
  //         dateMapping[uniqueDates[i]] = (i+5).toDouble();
  //       }
  //       print(dateMapping);
  //       return LineChart(
  //         LineChartData(
  //           lineBarsData: [
  //             LineChartBarData(
  //               spots: snapshot.data!.map((row) {
  //                 String date = row['month'].toString() + row['year'].toString();
  //                 return FlSpot(dateMapping[date]!, row['sum']);
  //               }).toList(),
  //               color: Colors.red,
  //               dotData: FlDotData(show: false),
  //             ),
  //           ],
  //           titlesData: FlTitlesData(
  //             bottomTitles: SideTitles(
  //               showTitles: true,
  //               getTitles: (value) {
  //                 return uniqueDates[value.toInt() - 5];
  //               },
  //             ),
              
  //             leftTitles: SideTitles(
  //               showTitles: true,
  //               getTitles: (value) {
  //                 return '\$${value.toInt()}';
  //               },
  //             ),
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }

  @override
  void initState() {
    super.initState();
    debitQueryResult = getDebitTransactions();
    // creditQueryResult = getCreditTransactions();
  }

  @override
  Widget build(BuildContext context) {

    // List<FlSpot> debitData = debitQueryResult.map((row) {
    //   return FlSpot(double.parse(row['month']+row['year']), row['sum']);
    // }).toList();

    // List<FlSpot> creditData = creditQueryResult.map((row) {
    //   return FlSpot(double.parse(row['month']), row['sum']);
    // }).toList();

    // Widget analysisChart = drawChart();

    return GestureDetector(
      onTap: (){
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const Placeholder(),
          )
        );
      },
      child: Container(
          // take max of required
          margin: const EdgeInsets.all(10.0),
          decoration: BoxDecoration(
            // color: Colors.grey,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: Colors.orange,
              width: 2,
            ),
            //shadow
          ),
          child: Container(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                // Add a button here that will open a new page using navigator
                const Text('AnalyticsWidget'),
                const SizedBox(height: 20),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text('Analytics1'),
                    Text('Analytics2'),
                    Text('Analytics3'),
                  ],
                ),
                const SizedBox(height: 20),
                // analysisChart,
                const SizedBox(height: 20),
                ButtonBar(
                  alignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const Placeholder(),
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
