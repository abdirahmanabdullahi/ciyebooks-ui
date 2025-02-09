class CurrencyModel {
  final String currencyName;
  final String currencyCode;
  final DateTime dateCreated;
  String? symbolNative;

  CurrencyModel({
    this.symbolNative,
    required this.dateCreated,
    required this.currencyName,
    required this.currencyCode,
  });

  /// Convert the currency to a json format to easily send it to firestore
  Map<String, dynamic> toJson() {
    return {
      'CurrencyName': currencyName,
      'CurrencyCode': currencyCode,
      'DateCreated': dateCreated,
      'SymbolNative':symbolNative
    };
  }

  /// Getting data from firestore and converting to json format
  factory CurrencyModel.fromJson(Map<String, dynamic> jsonData) {
    return CurrencyModel(
      currencyName: jsonData['CurrencyName'] ?? '',
      currencyCode: jsonData['CurrencyCode'] ?? '',
      symbolNative: jsonData['SymbolNative']??'',
      dateCreated: DateTime.parse(jsonData['DateCreated'].toDate().toString()),
    );
  }
}
