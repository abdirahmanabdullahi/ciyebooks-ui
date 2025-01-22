import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CurrencyModel {
  final String currencyName;
  final String currencyCode;
  final String country;
  final double rate;
  final double totalCost;
  CurrencyModel({
    required this.currencyName,
    required this.currencyCode,
    required this.country,
    required this.rate,
    required this.totalCost,
  });

  /// Convert the currency to a json format to easily send it to firestore
  Map<String, dynamic> toJson() {
    return {
      'CurrencyName': currencyName,
      'CurrencyCode': currencyCode,
      'Country': country,
      'Rate': rate,
      'TotalCost': totalCost,
    };
  }

  /// Getting data from firestore and converting to json format
  factory CurrencyModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    if (document.data() != null) {
      final data = document.data()!;
      return CurrencyModel(
          currencyName: data['CurrencyName']??'',
          currencyCode: data['CurrencyCode']??'',
          country: data['Country']??'',
          rate: data['Rate']??0.0,
          totalCost: data['TotalCost']??0.0);
    } else {
      throw Text('data');
    }
  }
}
