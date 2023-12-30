import 'package:flutter/material.dart';
import 'package:expense_tracker/widgets/navbar.dart' as navbar;
import 'package:expense_tracker/screens/homepage.dart' as homepage;
import 'package:expense_tracker/screens/transactionForm.dart'
    as transaction_form;
import 'package:expense_tracker/utils/enums.dart';

class MainView extends StatefulWidget {
  const MainView({super.key});

  @override
  _MainViewState createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  @override
  Widget build(BuildContext context) {
    bool isDarkMode =
        (MediaQuery.of(context).platformBrightness == Brightness.dark);

    return Scaffold(
      backgroundColor:
          (isDarkMode ? Colors.black87 : Colors.white.withOpacity(0.95)),
      body: SafeArea(
        child: Container(
          child: Stack(children: [
            Column(
              children: [
                navbar.Navbar(),
                SizedBox(height: 15),
                homepage.Homepage(),
              ],
            ),
            Positioned(
              bottom: 30,
              right: 30,
              child: FloatingActionButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            transaction_form.TransactionForm()),
                  );
                },
                child: Icon(Icons.add),
                backgroundColor: (isDarkMode
                    ? Colors.blue.shade800
                    : Colors.orange.shade800),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
