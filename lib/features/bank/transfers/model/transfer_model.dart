
class TransferModel {
  final String transactionType;
  final String transactionId;
  final String currency;
  final double amount;
  final DateTime dateCreated;
  final String receiver;
  TransferModel({
    required this.receiver,
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
      'receiver': receiver,
    };
  }

  factory TransferModel.fromJson(Map<String, dynamic> jsonData) {
    return TransferModel(
      transactionType: jsonData['transactionType'],
      transactionId: jsonData['transactionId'],
      currency: jsonData['currency'],
      amount: (jsonData['amount'] as num?)?.toDouble() ?? 0.0,
      dateCreated: DateTime.parse(jsonData['dateCreated'].toDate().toString()),
      receiver: jsonData['receiver'],
    );
  }
}
