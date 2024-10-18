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
}
