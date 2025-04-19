
class ForexModel {
  final String transactionId;
  final String forexType;
  final String transactionType;
  // final String currencyName;
  final String currencyCode;
  final double rate;
  final double amount;
  final double totalCost;
  final DateTime dateCreated;
  ForexModel({
    required this.transactionId,
    required this.forexType,
    required this.transactionType,
    // required this.currencyName,
    required this.currencyCode,
    required this.rate,
    required this.amount,
    required this.totalCost,
    required this.dateCreated,
  });

  /// Convert the currency to a json format to easily send it to firestore
  Map<String, dynamic> toJson() {
    return {
      'transactionType': transactionType,
      'forexType': forexType,
      'transactionId': transactionId,
      // 'CurrencyName': currencyName,
      'CurrencyCode': currencyCode,
      'Rate': rate,
      'Amount': amount,
      'TotalCost': totalCost,
      'dateCreated': dateCreated,
    };
  }

  /// Getting data from firestore and converting to json format
  factory ForexModel.fromJson(Map<String, dynamic> jsonData) {
    return ForexModel(
      transactionId: jsonData['transactionId'] ?? '',
      forexType: jsonData['forexType'] ?? '',
      // currencyName: jsonData['CurrencyName'] ?? '',
      currencyCode: jsonData['CurrencyCode'] ?? '',
      dateCreated: DateTime.parse(jsonData['dateCreated'].toDate().toString()),
      rate: jsonData['Rate'],
      amount: jsonData['Amount'],
      totalCost: jsonData['TotalCost'],
      transactionType: jsonData['transactionType'] ?? '',
    );
  }
}
