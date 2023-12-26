import 'package:flutter/material.dart';

class Navbar extends StatelessWidget {
  const Navbar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10.0),
      decoration: const BoxDecoration(
        color: Colors.deepPurple,
      ),
      child: const Row(
        children: [
          Text('NavItem1'),
          SizedBox(width: 50),
          Text('NavItem2'),
        ],
      ),
    );
  }
}