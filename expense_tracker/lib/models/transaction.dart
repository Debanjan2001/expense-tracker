enum TransactionType{
  debit,
  credit,
}

class Transaction{
  final String id;
  final String title;
  final double amount;
  final DateTime date;
  final TransactionType type;
 
  const Transaction({
    required this.id, 
    required this.title, 
    required this.amount, 
    required this.date,
    required this.type,
  });
}