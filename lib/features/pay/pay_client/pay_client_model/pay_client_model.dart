import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class PayClientModel {
  final String transactionId;
  final String accountFrom;
  final String currency;
  final double amountPaid;
  final String receiver;
  final DateTime dateCreated;
  final String description;
  final String transactionType;
  PayClientModel({
    required this.transactionId,
    required this.transactionType,
    required this.accountFrom,
    required this.currency,
    required this.amountPaid,
    required this.receiver,
    required this.dateCreated,
    required this.description,
  });
  Map<String, dynamic> toJson() {
    return {
      'TransactionId': transactionId,
      'AccountFrom': accountFrom,
      'Currency': currency,
      'AmountPaid': amountPaid,
      'Receiver': receiver,
      'DateCreated': dateCreated,
      'Description': description,
      'transactionType': transactionType
    };
  }

  factory PayClientModel.fromJson(Map<String, dynamic> jsonData) {
    return PayClientModel(
      transactionId: jsonData['TransactionId'],
      transactionType: jsonData['transactionType'],
      accountFrom: jsonData['AccountFrom'],
      currency: jsonData['Currency'],
      amountPaid: jsonData['AmountPaid'] ?? 0.0,
      receiver: jsonData['Receiver'],
      description: jsonData['Description'],
      dateCreated: DateTime.parse(jsonData['DateCreated'].toDate().toString()),
    );
  }
}
