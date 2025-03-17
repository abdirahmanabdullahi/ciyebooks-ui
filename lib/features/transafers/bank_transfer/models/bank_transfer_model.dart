import 'dart:core';

class BankTransferModel {
  final String transactionType;
  final String transactionId;
  final String transferringAccountNo;
  final String transferringAccountName;
  final String receiverName;
  // final String receivingAccountNo;
  final String currency;
  final double amount;
  final DateTime dateCreated;
  final String description;
  BankTransferModel({required this.receiverName,
    required this.transactionType,
    required this.transferringAccountNo,
    // required this.receivingAccountNo,
    required this.transactionId,
    required this.transferringAccountName,
    // required this.receivingAccountName,
    required this.currency,
    required this.amount,
    required this.dateCreated,
    required this.description,
  });
  static BankTransferModel empty() =>
      BankTransferModel(transactionType: '', transactionId: '', currency: '', amount: 0, dateCreated: DateTime.now(), description: '', transferringAccountNo: '', transferringAccountName: '', receiverName: '');
  Map<String, dynamic> toJson() {
    return {
      'transactionType': transactionType,
      'transactionId': transactionId,
      'transferringAccountName': transferringAccountName,
      'transferringAccountNo': transferringAccountNo,
      'receivingAccountName': receiverName,
      'currency': currency,
      'amount': amount,
      'dateCreated': dateCreated,
      'description': description,
      // 'receivingAccountNo': receivingAccountNo
    };
  }

  factory BankTransferModel.fromJson(Map<String, dynamic> jsonData) {
    return BankTransferModel(
      transactionType: jsonData['transactionType'],
      receiverName: jsonData['receiverName'],
      transactionId: jsonData['transactionId'],
      // receivingAccountNo: jsonData['receivingAccountNo'],
      transferringAccountNo: jsonData['transferringAccountNo'],
      transferringAccountName: jsonData['transferringAccountName'],
      // receivingAccountName: jsonData['receivingAccountName'],
      currency: jsonData['currency'],
      amount: (jsonData['amount'] as num?)?.toDouble() ?? 0.0,
      dateCreated: DateTime.parse(jsonData['dateCreated'].toDate().toString()),
      description: jsonData['description'],
    );
  }
}
