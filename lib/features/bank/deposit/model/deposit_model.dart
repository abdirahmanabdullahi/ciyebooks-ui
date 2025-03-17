
class DepositModel {
  final String transactionType;
  final String description;
  final String transactionId;
  final String currency;
  final double amount;
  final DateTime dateCreated;
  final String? depositedBy;
  DepositModel({
    required this.depositedBy,
    required this.description,
    required this.transactionType,
    required this.transactionId,
    required this.currency,
    required this.amount,
    required this.dateCreated,
  });
  Map<String, dynamic> toJson() {
    return {
      'transactionType': transactionType,
      'transactionId': transactionId,
      'currency': currency,
      'amount': amount,
      'dateCreated': dateCreated,
      'depositedBy': depositedBy,
      'description': description,
    };
  }

  factory DepositModel.fromJson(Map<String, dynamic> jsonData) {
    return DepositModel(
      transactionType: jsonData['transactionType'],
      description: jsonData['description']??'',
      transactionId: jsonData['transactionId'],
      currency: jsonData['currency'],
      amount: (jsonData['amount'] as num?)?.toDouble() ?? 0.0,
      dateCreated: DateTime.parse(jsonData['dateCreated'].toDate().toString()),
      depositedBy: jsonData['depositedBy'],
    );
  }
}
