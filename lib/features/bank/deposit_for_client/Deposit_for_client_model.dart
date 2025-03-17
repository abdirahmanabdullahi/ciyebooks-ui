
class DepositForClientModel {
  final String transactionId;
  final String accountFrom;
  final String currency;
  final double amountDeposited;
  final DateTime dateCreated;
  final String description;
  final String transactionType;
  DepositForClientModel({
    required this.transactionId,
    required this.transactionType,
    required this.accountFrom,
    required this.currency,
    required this.amountDeposited,
    required this.dateCreated,
    required this.description,
  });
  Map<String, dynamic> toJson() {
    return {
      'TransactionId': transactionId,
      'AccountFrom': accountFrom,
      'Currency': currency,
      'amountDeposited': amountDeposited,
      'DateCreated': dateCreated,
      'Description': description,
      'transactionType': transactionType
    };
  }

  factory DepositForClientModel.fromJson(Map<String, dynamic> jsonData) {
    return DepositForClientModel(
      transactionId: jsonData['TransactionId']??'',
      transactionType: jsonData['transactionType'],
      accountFrom: jsonData['AccountFrom']??'',
      currency: jsonData['Currency']??'',
      amountDeposited: jsonData['amountDeposited'] ?? 0.0,
      description: jsonData['Description']??'',
      dateCreated: DateTime.tryParse(jsonData['DateCreated'].toDate().toString())??DateTime.now(),
    );
  }
}
