import 'package:flutter/material.dart';
import 'package:expense_tracker/widgets/navbar.dart' as navbar;
import 'package:expense_tracker/screens/homepage.dart' as homepage;
import 'package:expense_tracker/screens/transactions/transaction_create.dart' as transaction_form;

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
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(70),
        child: navbar.Navbar(),
      ),
      backgroundColor:
          (isDarkMode ? Colors.black87 : Colors.white.withOpacity(0.95)),
      body: SafeArea(
          child: Stack(children: [
            const homepage.Homepage(),
            const SizedBox(height: 15),
            Positioned(
              bottom: 30,
              right: 30,
              child: FloatingActionButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            const transaction_form.TransactionForm()),
                  );
                },
                backgroundColor: (isDarkMode
                    ? Colors.blue.shade800
                    : Colors.orange.shade800),
                child: const Icon(Icons.add),
              ),
            ),
          ]),
      ),
    );
  }
}
