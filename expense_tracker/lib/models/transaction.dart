
class Transaction {
  final int? id;
  final int? msgId;
  final String title;
  final double amount;
  final String date;
  final String type;

  const Transaction({
    this.id,
    this.msgId,
    required this.title,
    required this.amount,
    required this.date,
    required this.type,
  });

  Map<String, dynamic> toMap() {
    return {
      'msg_id': msgId,
      'title': title,
      'amount': amount,
      'date': date,
      'type': type,
    };
  }

}
