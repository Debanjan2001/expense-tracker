import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:expense_tracker/services/services.dart' as services;
import 'package:expense_tracker/utils/constants.dart' as constants;
import 'package:intl/intl.dart';


class TransactionDetails extends StatefulWidget {
  final Map transaction;
  const TransactionDetails({super.key, required this.transaction});

  @override
  State<TransactionDetails> createState() => _TransactionDetailsState();
}

class _TransactionDetailsState extends State<TransactionDetails> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _amountController;
  late TextEditingController _dateController;
  late String _transactionType;
  
  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.transaction['title']);
    _amountController = TextEditingController(text: widget.transaction['amount'].toString());
    _dateController = TextEditingController(
      text: DateFormat('dd-MMM-yyyy').format(
      DateTime(
        widget.transaction['year'], widget.transaction['month'], widget.transaction['day'])
      ).toString()
    );
    _transactionType = widget.transaction['type'];
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final transaction = widget.transaction;
    bool isDarkMode =
        (MediaQuery.of(context).platformBrightness == Brightness.dark);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transaction Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
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
                    items: constants.transactionTypes
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
                      // Update the transaction here
                      print('update called');
                      // Process data.
                      FocusScope.of(context).unfocus();
                    },
                    child: const Text('Update'),
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
                      //Update the transaction here
                      print('delete called');
                      FocusScope.of(context).unfocus();
                      Navigator.pop(context, 'update');
                    },
                    child: const Text('Delete'),
                  ),
                ],
              ),
            ),
          ),
      ),
    );
  }
}


          