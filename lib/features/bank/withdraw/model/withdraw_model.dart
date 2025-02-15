class WithdrawModel {
  final String transactionType;
  final String transactionId;
  final String currency;
  final double amount;
  final DateTime dateCreated;
  final String withdrawalType;
  final String withdrawnBy;
  final String description;
  WithdrawModel({required this.description,
    required this.withdrawnBy,
    required this.transactionType,
    required this.transactionId,
    required this.currency,
    required this.amount,
    required this.dateCreated,
    required this.withdrawalType,
  });
  Map<String, dynamic> toJson() {
    return {
      'transactionType': transactionType,
      'transactionId': transactionId,
      'currency': currency,
      'amount': amount,
      'dateCreated': dateCreated,
      'withdrawalType': withdrawalType,
      'withdrawnBy': withdrawnBy,
      'description':description,
    };
  }

  factory WithdrawModel.fromJson(Map<String, dynamic> jsonData) {
    return WithdrawModel(
      transactionType: jsonData['transactionType'],
      transactionId: jsonData['transactionId'],
      currency: jsonData['currency'],
      amount: (jsonData['amount'] as num?)?.toDouble() ?? 0.0,
      dateCreated: DateTime.parse(jsonData['dateCreated'].toDate().toString()),
      withdrawalType: jsonData['withdrawalType'],
      withdrawnBy: jsonData['withdrawnBy'], description: jsonData['description'],
    );
  }
}
