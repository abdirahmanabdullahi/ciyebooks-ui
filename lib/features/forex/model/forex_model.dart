
class ForexModel {
  final String transactionId;
  final double revenueContributed;
  final String forexType;
  final String type;
  final String transactionType;
  // final String currencyName;
  final String currencyCode;
  final double rate;
  final double amount;
  final double totalCost;
  final DateTime dateCreated;
  ForexModel({
    required this.transactionId,
    required this.revenueContributed,
    required this.forexType,
    required this.type,
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
      'revenueContributed': revenueContributed,
      'forexType': forexType,
      'type': type,
      'transactionId': transactionId,
      // 'CurrencyName': currencyName,
      'currencyCode': currencyCode,
      'rate': rate,
      'amount': amount,
      'totalCost': totalCost,
      'dateCreated': dateCreated,
    };
  }

  /// Getting data from firestore and converting to json format
  factory ForexModel.fromJson(Map<String, dynamic> jsonData) {
    return ForexModel(
      transactionId: jsonData['transactionId'] ?? '',
      forexType: jsonData['forexType'] ?? '',
      type: jsonData['type'] ?? '',
      // currencyName: jsonData['CurrencyName'] ?? '',
      currencyCode: jsonData['currencyCode'] ?? '',
      dateCreated: DateTime.parse(jsonData['dateCreated'].toDate().toString()),
      rate: double.parse(jsonData['rate'].toString()),
      revenueContributed: double.parse(jsonData['revenueContributed'].toString()),
      amount: double.parse(jsonData['amount'].toString()),
      totalCost: double.parse(jsonData['totalCost'].toString()),
      transactionType: jsonData['transactionType'] ?? '',
    );
  }
}
