import 'dart:ffi';

class ForexModel {
  final String currencyName;
  final String currencyCode;
  final double rate;
  final double amount;
  final double totalCost;
  final DateTime dateCreated;
  ForexModel({
    required this.currencyName,
    required this.currencyCode,
    required this.rate,
    required this.amount,
    required this.totalCost, required this.dateCreated,
  });

  /// Convert the currency to a json format to easily send it to firestore
  Map<String, dynamic> toJson() {
    return {
      'CurrencyName': currencyName,
      'CurrencyCode': currencyCode,
      'Rate': currencyCode,
      'Amount': currencyCode,
      'TotalCost': currencyCode,
      'DateCreated': dateCreated,
    };
  }

  /// Getting data from firestore and converting to json format
  factory ForexModel.fromJson(Map<String, dynamic> jsonData) {
    return ForexModel(
      currencyName: jsonData['CurrencyName'] ?? '',
      currencyCode: jsonData['CurrencyCode'] ?? '',
      dateCreated: DateTime.parse(jsonData['DateCreated'].toDate().toString()),
      rate: double.tryParse(jsonData['Rate'])??0.0,
      amount: double.tryParse(jsonData['Amount'])??0.0,
      totalCost: double.tryParse(jsonData['TotalCost'])??0.0,
    );
  }
}
