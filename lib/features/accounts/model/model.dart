import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class AccountModel {
  final String firstName;
  final String lastName;
  final String accountNo;
  final String phoneNo;
  final String email;
  final double usdBalance;
  final double kesBalance;
  final DateTime dateCreated;
  AccountModel({
    required this.usdBalance,
    required this.kesBalance,
    required this.dateCreated,
    required this.firstName,
    required this.lastName,
    required this.accountNo,
    required this.phoneNo,
    required this.email,
  });

  String get fullName => '$firstName $lastName';

  /// Convert AccountsModel to JSON structure for storing data in firestore

  Map<String, dynamic> toJson() {
    return {
      'DateCreated': dateCreated,
      'AccountName': fullName,
      'FirstName': firstName,
      'LastName': lastName,
      'AccountNo': accountNo,
      'PhoneNo': phoneNo,
      'Email': email,
      "UsdBalance": usdBalance,
      'KesBalance': kesBalance,
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
          usdBalance: data['UsdBalance'] ?? 0.0,
          kesBalance: data['KesBalances'],
          dateCreated: data['DateCreated']);
    } else {
      throw Text('Once created accounts will appear here');
    }
  }
}
