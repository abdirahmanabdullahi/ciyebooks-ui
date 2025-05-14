
class ExpenseModel {
  final String transactionId;
  final String paymentType;
  final String category;
  final String description;
  final DateTime dateCreated;
  final String currency;
  final double amount;

final String transactionType;

  ExpenseModel({
    required this.transactionId,
    required this.paymentType,
    required this.category,
    required this.description,
    required this.dateCreated,
    required this.currency,
    required this.amount,
    required this.transactionType,
  });
  Map<String, dynamic> toJson() {
    return {
      'transactionType':transactionType,
      'paymentType':paymentType,
      'transactionId': transactionId,
      'category': category,
      'description': description,
      'dateCreated': dateCreated,
      'currency': currency,
      'amount': amount
    };
  }

  factory ExpenseModel.fromJson(Map<String, dynamic> jsonData) {
    return ExpenseModel(
      transactionId: jsonData['transactionId'],
      category: jsonData['category'],
      paymentType: jsonData['paymentType'],
      description: jsonData['description'],
      dateCreated: DateTime.parse(jsonData['dateCreated'].toDate().toString()),
      currency: jsonData['currency'],
      amount: jsonData['amount'],
      transactionType: jsonData['transactionType'],
    );
  }
}
