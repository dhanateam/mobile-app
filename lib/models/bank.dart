class BankDetails {
  final String bank;
  final String bankingName;
  final String acno;
  final String ifsc;
  final String? textId;

  BankDetails({
    required this.bank,
    required this.bankingName,
    required this.acno,
    required this.ifsc,
    this.textId,
  });

  // Factory method to create an instance from JSON
  factory BankDetails.fromJson(Map<String, dynamic> json) {
    return BankDetails(
      bank: json['bank'],
      bankingName: json['bankingname'],
      acno: json['acno'],
      ifsc: json['ifsc'],
      textId: json['textid'],
    );
  }

  // Method to extract a list of BankDetails from a JSON response
  static List<BankDetails> listFromJson(List<dynamic> jsonList) {
    return jsonList.map((json) => BankDetails.fromJson(json)).toList();
  }
}
