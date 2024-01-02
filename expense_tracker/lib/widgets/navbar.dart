import 'package:flutter/material.dart';

class Navbar extends StatelessWidget {
  const Navbar({super.key});

  @override
  Widget build(BuildContext context) {
    bool isDarkMode =
        (MediaQuery.of(context).platformBrightness == Brightness.dark);

    return SafeArea(
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 60,
        padding: const EdgeInsets.only(
          left: 25.0,
          right: 25.0,
        ),
        decoration: BoxDecoration(
          // borderRadius: BorderRadius.circular(10),
          // border: Border.all(
          // color: Colors.redAccent,
          // width: 2,
          // ),
          color: (isDarkMode ? Colors.blue.shade800 : Colors.orange.shade800),
        ),
        child: const Row(
          // make the row children align to center
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Add an icon here of money
            Icon(Icons.monetization_on, size: 30,),
            SizedBox(width: 10),
            Text('Expense Tracker', style: TextStyle(fontSize: 20),),
          ],
        ),
      ),
    );
  }
}
