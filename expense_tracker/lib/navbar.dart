import 'package:flutter/material.dart';

class Navbar extends StatelessWidget {
  const Navbar({super.key});


  @override
  Widget build(BuildContext context) {
    bool isDarkMode = (MediaQuery.of(context).platformBrightness == Brightness.dark);

    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.075,
      padding: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        // borderRadius: BorderRadius.circular(10),
        // border: Border.all(
          // color: Colors.redAccent,
          // width: 2, 
        // ),
        color: (isDarkMode ? Colors.blue: Colors.orange.shade600),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            Text('NavItem1'),
            SizedBox(width: 50),
            Text('NavItem2'),
          ],
        ),
      ),
    );
  }
}