class CurrencyModel {
  final double amount;
  final double totalCost;
  final String currencyName;
  final String currencyCode;

  CurrencyModel({
    required this.totalCost,
    required this.amount,
    required this.currencyName,
    required this.currencyCode,
  });

  /// Convert the currency to a json format to easily send it to firestore
  Map<String, dynamic> toJson() {
    return {'currencyName': currencyName, 'currencyCode': currencyCode, 'totalCost': totalCost, 'amount': amount};
  }

  /// Getting data from firestore and converting to json format
  factory CurrencyModel.fromJson(Map<String, dynamic> jsonData) {
    return CurrencyModel(
      currencyName: jsonData['currencyName'] ?? '',
      currencyCode: jsonData['currencyCode'] ?? '',
      amount:double.tryParse( jsonData['amount'].toString()) ?? 0.0,
      totalCost: double.tryParse(jsonData['totalCost'].toString()) ?? 0.0,
    );
  }
}
