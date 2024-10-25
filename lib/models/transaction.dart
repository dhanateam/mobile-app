class Transaction {
  final String status;
  final int amount;
  final DateTime date;
  final String bankName;
  final String transactionId;

  Transaction({
    required this.status,
    required this.amount,
    required this.date,
    required this.bankName,
    required this.transactionId,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      status: json['status'],
      amount: json['amount'],
      date: json['date'],
      bankName: json['bankName'],
      transactionId: json['transactionId'],
    );
  }
}