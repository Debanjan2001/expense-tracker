import 'package:flutter/material.dart';
import 'package:expense_tracker/widgets/navbar.dart' as navbar;
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:expense_tracker/services/services.dart' as services;
import 'package:expense_tracker/models/transaction.dart' as transaction_model;
import 'package:sqflite/sqflite.dart' as sqflite;

const List<String> transactionTypes = <String>['Debit', 'Credit'];


class TransactionForm extends StatefulWidget {
  const TransactionForm({super.key});

  @override
  TransactionFormState createState() => TransactionFormState();
}

class TransactionFormState extends State<TransactionForm> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  final _dateController = TextEditingController(
    text: DateFormat('dd-MMM-yyyy').format(DateTime.now()),
  );
  String _transactionType =transactionTypes.first;


  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  void addTransaction(){
    // get the services provider
    final db = Provider.of<services.Services>(context, listen: false).getDB();
    // get the transaction data
    final transaction = transaction_model.Transaction(
      title: _titleController.text,
      amount: double.parse(_amountController.text),
      date: DateFormat('dd-MMM-yyyy').parse(_dateController.text).toIso8601String(),
      type: _transactionType,
    );

    // insert the transaction into the database
    db.insert(
      'transactions',
      transaction.toMap(),
      conflictAlgorithm: sqflite.ConflictAlgorithm.replace,
    ).then((id) {
      if (id > 0) {
        // The transaction was inserted successfully
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Row(
              children: [
                Icon(Icons.check_circle, color: Colors.green),
                SizedBox(width: 5),
                Text('Transaction added successfully'),
              ],
            ),
          )
        );
      } else {
        // The transaction was not inserted
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Row(
              children: [
                Icon(Icons.error, color: Colors.red),
                SizedBox(width: 5),
                Text('Failed to add transaction'),
              ],
            ),
          )
        );
      }
    });
  }

  void clearForm(){
    _amountController.clear();
    _titleController.clear();
    _dateController.text = DateFormat('dd-MMM-yyyy').format(DateTime.now());
    setState(() {
      _transactionType = transactionTypes.first;
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode =
        (MediaQuery.of(context).platformBrightness == Brightness.dark);
    return Scaffold(
      backgroundColor:
          (isDarkMode ? Colors.black87 : Colors.white.withOpacity(0.95)),
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(70),
        child: navbar.Navbar(),
      ),
      body: SafeArea(
        child: Container(
          margin: const EdgeInsets.all(15.0),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                children: [
                  TextFormField(
                    controller: _titleController,
                    decoration: const InputDecoration(
                      labelText: 'Description',
                      border: OutlineInputBorder(),
                      filled: true,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _amountController,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    decoration: const InputDecoration(
                      labelText: 'Enter amount',
                      border: OutlineInputBorder(),
                      filled: true,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      }
                      // check if value is a number
                      if (double.tryParse(value) == null) {
                        return 'Please enter a valid number';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _dateController,
                    decoration: const InputDecoration(
                      labelText: 'Enter date',
                      border: OutlineInputBorder(),
                      filled: true,
                    ),
                    onTap: () async {
                      FocusScope.of(context).requestFocus(
                          FocusNode()); // to prevent opening the onscreen keyboard
                      final DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                      );
                      if (picked != null && picked != DateTime.now()) {
                        _dateController.text =
                            DateFormat('dd-MMM-yyyy').format(picked);
                      }
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  DropdownButtonFormField<String>(
                    value: _transactionType,
                    decoration: const InputDecoration(
                      labelText: 'Transaction Type',
                      border: OutlineInputBorder(),
                      filled: true,
                    ),
                    items: transactionTypes
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _transactionType = newValue!;
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isDarkMode
                          ? Colors.blue.shade800
                          : Colors.orange.shade800, // background color
                    ),
                    onPressed: () {
                      if (_formKey.currentState!.validate() == false) {
                        return;
                      }
                      // Process data.
                      FocusScope.of(context).unfocus();
                      addTransaction();
                      clearForm();
                    },
                    child: const Text('Add Expense'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}