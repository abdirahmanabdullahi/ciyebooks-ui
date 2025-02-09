
class DepositModel {
  final String transactionType;
  final String transactionId;
  final String currency;
  final double amount;
  final DateTime dateCreated;
  final String depositType;
  final String? depositedBy;
  DepositModel({
    this.depositedBy,
    required this.transactionType,
    required this.transactionId,
    required this.currency,
    required this.amount,
    required this.dateCreated,
    required this.depositType,
  });
  Map<String, dynamic> toJson() {
    return {
      'transactionType': transactionType,
      'transactionId': transactionId,
      'currency': currency,
      'amount': amount,
      'dateCreated': dateCreated,
      'depositType': depositType,
      'depositedBy': depositedBy,
    };
  }

  factory DepositModel.fromJson(Map<String, dynamic> jsonData) {
    return DepositModel(
      transactionType: jsonData['transactionType'],
      transactionId: jsonData['transactionId'],
      currency: jsonData['currency'],
      amount: (jsonData['amount'] as num?)?.toDouble() ?? 0.0,
      dateCreated: DateTime.parse(jsonData['dateCreated'].toDate().toString()),
      depositType: jsonData['depositType'],
      depositedBy: jsonData['depositedBy'],
    );
  }
}
