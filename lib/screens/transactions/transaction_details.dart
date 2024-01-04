import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:expense_tracker/services/services.dart' as services;
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
  bool? staleDataPossibilityInParent;
  
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
    staleDataPossibilityInParent = false;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  Future<void> updateTransaction(Map transaction) async {
    final db = Provider.of<services.Services>(context, listen: false).getDB();
    await db.rawQuery(
      '''
      UPDATE transactions 
      SET title = ?, amount = ?, day = ?, month = ?, year = ?, type = ? 
      WHERE id = ?
      ''', [
        transaction['title'],
        transaction['amount'],
        transaction['day'],
        transaction['month'],
        transaction['year'],
        transaction['type'],
        transaction['id'],
      ]
    );
  }

  Future<void> deleteTransaction(int id) async {
    final db = Provider.of<services.Services>(context, listen: false).getDB();
    await db.rawQuery(
      'DELETE FROM transactions WHERE id = $id'
    );
  }

  @override
  Widget build(BuildContext context) {
    final transaction = widget.transaction;
    bool isDarkMode =
        (MediaQuery.of(context).platformBrightness == Brightness.dark);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transaction Details'),
      ),
      body: SafeArea(
        child: PopScope(
          canPop: false,
          onPopInvoked: (bool didPop){
            if(didPop){
              return;
            }
            if(staleDataPossibilityInParent!){
              Navigator.pop(context, 'update');
            }else{
              Navigator.pop(context);
            }
          },
          child: Container(
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
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
                              final date = DateFormat('dd-MMM-yyyy').parse(_dateController.text);
                              final newTransaction = {
                                'id': transaction['id'], // this is the primary key
                                'title': _titleController.text,
                                'amount': double.parse(_amountController.text),
                                'type': _transactionType,
                                'day': date.day,
                                'month': date.month,
                                'year': date.year,
                              };
                              if(newTransaction != transaction){
                                updateTransaction(newTransaction);
                                setState(() {
                                  staleDataPossibilityInParent = true;
                                });
                              }
                              FocusScope.of(context).unfocus();
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Row(
                                    children: [
                                      Icon(Icons.check_circle, color: Colors.green),
                                      SizedBox(width: 5),
                                      Text('Transaction updated successfully'),
                                    ],
                                  ),
                                )
                              );
                            },
                            child: const Text('Update', style:TextStyle(color: Colors.white)),
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red.shade700
                            ),
                            onPressed: () {
                              FocusScope.of(context).unfocus();
                              deleteTransaction(transaction['id']);
                              Navigator.pop(context, 'update');
                            },
                            child: const Text('Delete', style:TextStyle(color: Colors.white)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
          ),
        ),
      ),
    );
  }
}


          