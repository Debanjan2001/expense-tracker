import 'package:flutter/material.dart';
import 'package:expense_tracker/screens/homepage.dart' as homepage;

class MainView extends StatefulWidget {
  const MainView({super.key});

  @override
  MainViewState createState() => MainViewState();
}

class MainViewState extends State<MainView> {
  @override
  Widget build(BuildContext context) {
    bool isDarkMode =
        (MediaQuery.of(context).platformBrightness == Brightness.dark);

    return Scaffold(
      backgroundColor: (isDarkMode ? Colors.black87 : Colors.white.withOpacity(0.95)),
      body: const SafeArea(
          child:  homepage.Homepage(),
      ),
    );
  }
}
