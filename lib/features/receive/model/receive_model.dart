import 'dart:core';


class ReceiveModel {
  final String transactionType;
  final String transactionId;
  final String depositorName;
  final String receivingAccountName;
  final String currency;
  final double amount;
  final DateTime dateCreated;
  final String description;
  ReceiveModel({
    required this.transactionType,
    required this.transactionId,
    required this.depositorName,
    required this.receivingAccountName,
    required this.currency,
    required this.amount,
    required this.dateCreated,
    required this.description,
  });
  Map<String, dynamic> toJson() {
    return {
      'transactionType': transactionType,
      'transactionId': transactionId,
      'depositorName': depositorName,
      'receivingAccountName': receivingAccountName,
      'currency': currency,
      'amount': amount,
      'dateCreated': dateCreated,
      'description': description
    };
  }

  factory ReceiveModel.fromJson(Map<String, dynamic> jsonData) {
    return ReceiveModel(
      transactionType: jsonData['transactionType'],
      transactionId: jsonData['transactionId'],
      depositorName: jsonData['depositorName'],
      receivingAccountName: jsonData['receivingAccountName'],
      currency: jsonData['currency'],
      amount: (jsonData['amount'] as num?)?.toDouble() ?? 0.0,
      dateCreated: DateTime.parse(jsonData['dateCreated'].toDate().toString()),
      description: jsonData['description'],
    );
  }
}
