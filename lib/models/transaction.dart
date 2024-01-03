
class Transaction {
  final int? id;
  final int? msgId;
  final String title;
  final double amount;
  final String type;
  final int day;
  final int month;
  final int year;

  const Transaction({
    this.id,
    this.msgId,
    required this.title,
    required this.amount,
    required this.type,
    required this.day,
    required this.month,
    required this.year,
  });

  Map<String, dynamic> toMap() {
    return {
      'msg_id': msgId,
      'title': title,
      'amount': amount,
      'type': type,
      'day': day,
      'month': month,
      'year': year,
    };
  }
}
