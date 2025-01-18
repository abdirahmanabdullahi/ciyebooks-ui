import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class AccountModel {
  final String firstName;
  final String lastName;
  final String accountNo;
  final String phoneNo;
  final String email;
  final Map<String, double> currencyBalances;
  AccountModel({
    required this.currencyBalances,
    required this.firstName,
    required this.lastName,
    required this.accountNo,
    required this.phoneNo,
    required this.email,
  });

  String get fullName => '$firstName$lastName';

  /// Convert AccountsModel to JSON structure for storing data in firestore

  Map<String, dynamic> toJson() {
    return {
      'FirstName': firstName,
      'LastName': lastName,
      'AccountNo': accountNo,
      'PhoneNo': phoneNo,
      'Email': email,
      'CurrencyBalances': currencyBalances
    };
  }

  factory AccountModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    if (document.data() != null) {
      final data = document.data()!;
      return AccountModel(
          firstName: data['FirstName'] ?? '',
          lastName: data['LastName'] ?? '',
          accountNo: data['AccountNo'] ?? '',
          email: data['Email'] ?? '',
          phoneNo: data['PhoneNo'] ?? '',
          currencyBalances: Map<String, double>.from(
            data['CurrencyBalances'] ?? {},
          ));
    } else {
      throw Text('Once created accounts will appear here');
    }
  }
}
