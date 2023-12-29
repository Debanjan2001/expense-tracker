import 'package:flutter/material.dart';
import 'homepage.dart' as homepage;

void main() {
  // WidgetsFlutterBinding.ensureInitialized(); // add this before runApp
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Expense Tracker App',
      theme: ThemeData(
        fontFamily: 'OpenSans',
        brightness: Brightness.light, /* light theme settings */
         textTheme: TextTheme(
          bodyLarge: TextStyle(color: Colors.black),
        )
      ),
      darkTheme: ThemeData(
        fontFamily: 'OpenSans',
        brightness: Brightness.dark,  /* dark theme settings */
        textTheme: TextTheme(
          bodyLarge: TextStyle(color: Colors.white),
        )
      ),
      themeMode: ThemeMode.system, 
      /* ThemeMode.system to follow system theme, 
         ThemeMode.light for light theme, 
         ThemeMode.dark for dark theme
      */
      // debugShowCheckedModeBanner: false,
      home: homepage.Homepage(),
    );
  }
}