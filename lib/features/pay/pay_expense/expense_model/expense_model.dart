
class ExpenseModel {
  final String transactionId;
  final String category;
  final String description;
  final DateTime dateCreated;
  final String currency;
  final double amountPaid;

final String transactionType;

  ExpenseModel({
    required this.transactionId,
    required this.category,
    required this.description,
    required this.dateCreated,
    required this.currency,
    required this.amountPaid,
    required this.transactionType,
  });
  Map<String, dynamic> toJson() {
    return {
      'transactionType':transactionType,
      'transactionId': transactionId,
      'category': category,
      'description': description,
      'DateCreated': dateCreated,
      'currency': currency,
      'amountPaid': amountPaid
    };
  }

  factory ExpenseModel.fromJson(Map<String, dynamic> jsonData) {
    return ExpenseModel(
      transactionId: jsonData['transactionId'],
      category: jsonData['category'],
      description: jsonData['description'],
      dateCreated: DateTime.parse(jsonData['DateCreated'].toDate().toString()),
      currency: jsonData['currency'],
      amountPaid: jsonData['amountPaid'],
      transactionType: jsonData['transactionType'],
    );
  }
}
