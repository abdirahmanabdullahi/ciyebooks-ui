import 'dart:core';

class ReceiveModel {
  final String transactionType;
  final String transactionId;
  final String depositorName;
  final String depositType;
  final String receivingAccountName;
  final String accountNo;
  final String currency;
  final double amount;
  final DateTime dateCreated;
  final String description;
  ReceiveModel({
    required this.transactionType,
    required this.depositType,
    required this.accountNo,
    required this.transactionId,
    required this.depositorName,
    required this.receivingAccountName,
    required this.currency,
    required this.amount,
    required this.dateCreated,
    required this.description,
  });
  static ReceiveModel empty() =>
      ReceiveModel(transactionType: '', accountNo: '', transactionId: '', depositorName: '', receivingAccountName: '', currency: '', amount: 0, dateCreated: DateTime.now(), description: '', depositType: '');
  Map<String, dynamic> toJson() {
    return {
      'transactionType': transactionType,
      'depositType': depositType,
      'transactionId': transactionId,
      'depositorName': depositorName,
      'receivingAccountName': receivingAccountName,
      'currency': currency,
      'amount': amount,
      'dateCreated': dateCreated,
      'description': description,
      'accountNo': accountNo
    };
  }

  factory ReceiveModel.fromJson(Map<String, dynamic> jsonData) {
    return ReceiveModel(
      transactionType: jsonData['transactionType'],
      depositType: jsonData['depositType'],
      transactionId: jsonData['transactionId'],
      depositorName: jsonData['depositorName'],
      accountNo: jsonData['accountNo'].toString(),
      receivingAccountName: jsonData['receivingAccountName'],
      currency: jsonData['currency'],
      amount: (jsonData['amount'] as num?)?.toDouble() ?? 0.0,
      dateCreated: DateTime.parse(jsonData['dateCreated'].toDate().toString()),
      description: jsonData['description'],
    );
  }
}
