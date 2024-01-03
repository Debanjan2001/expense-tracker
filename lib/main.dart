import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'services/services.dart';
import 'package:expense_tracker/screens/main_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // add this before runApp
  Services services = Services();
  await services.initDB();
  runApp(Provider<Services>(
    create: (_) => services,
    child: const MainApp(),
  ));
}

class MainApp extends StatelessWidget {
  // get db from provider
  const MainApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Expense Tracker App',
      theme: ThemeData(
          fontFamily: 'Montserrat',
          brightness: Brightness.light,
          /* light theme settings */
          textTheme: const TextTheme(
            // bodyLarge: TextStyle(color: Colors.black),
            // bodyMedium: TextStyle(color: Colors.black),
            // bodySmall: TextStyle(color: Colors.black),
          )
      ),
      darkTheme: ThemeData(
          fontFamily: 'Montserrat',
          //use weight 700
          brightness: Brightness.dark,
          /* dark theme settings */
          textTheme: const TextTheme(
            // bodyLarge: TextStyle(color: Colors.white),
            // bodyMedium: TextStyle(color: Colors.white),
            // bodySmall: TextStyle(color: Colors.white),
          )
      ),
      themeMode: ThemeMode.system,
      /* ThemeMode.system to follow system theme, 
         ThemeMode.light for light theme, 
         ThemeMode.dark for dark theme
      */
      // debugShowCheckedModeBanner: false,
      home: const MainView(),
    );
  }
}
