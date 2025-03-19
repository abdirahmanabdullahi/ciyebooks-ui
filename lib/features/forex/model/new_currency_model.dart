class CurrencyModel {
  final String currencyName;
  final String currencyCode;
  final String symbol;
  final double amount;
  final double totalCost;

  CurrencyModel({
    required this.currencyName,
    required this.amount,
    required this.totalCost,
    required this.symbol,
    required this.currencyCode,
  });

  static CurrencyModel empty() => CurrencyModel(currencyName: ' ', currencyCode: '', symbol: '', amount: 0, totalCost: 0);

  /// Convert the currency to a json format to easily send it to firestore
  Map<String, dynamic> toJson() {
    return {
      'currencyName': currencyName,
      'amount': amount,
      'totalCost': totalCost,
      'currencyCode': currencyCode,
      'symbol': symbol,
    };
  }

  /// Getting data from firestore and converting to json format
  factory CurrencyModel.fromJson(Map<String, dynamic> jsonData) {
    return CurrencyModel(
      currencyName: jsonData['currencyName'] ?? '',
      amount: double.tryParse(jsonData['amount'].toString() )?? 0.0,
      totalCost: double.tryParse(jsonData['totalCost'].toString() )?? 0.0,
      symbol: jsonData['symbol'] ?? '',
      currencyCode: jsonData['currencyCode'] ?? '',
    );
  }
}
