import 'package:flutter/material.dart';
import 'navbar.dart' as navbar;


class Homepage extends StatelessWidget {
  const Homepage({super.key});

  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: SafeArea(
        child: Container(
          // decoration: BoxDecoration(
            // color: Colors.white,
          // ),
          child: const Column(
            children: [
              navbar.Navbar(),
              SizedBox(height: 20),
              Text('HomepageItem'),
            ],
          ),
        ),
      ),
    );
  }
} 