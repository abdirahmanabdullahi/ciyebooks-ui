
class PayClientModel {
  final String transactionId;
  final String accountNo;
  final String paymentType;
  final String accountFrom;
  final String currency;
  final double amount;
  final String receiver;
  final DateTime dateCreated;
  final String description;
  final String transactionType;
  PayClientModel({
    required this.transactionId,
    required this.accountNo,
    required this.paymentType,
    required this.transactionType,
    required this.accountFrom,
    required this.currency,
    required this.amount,
    required this.receiver,
    required this.dateCreated,
    required this.description,
  });
  Map<String, dynamic> toJson() {
    return {
      'transactionId': transactionId,
      'accountNo': accountNo,
      'paymentType': paymentType,
      'accountFrom': accountFrom,
      'currency': currency,
      'amount': amount,
      'receiver': receiver,
      'dateCreated': dateCreated,
      'description': description,
      'transactionType': transactionType
    };
  }

  factory PayClientModel.fromJson(Map<String, dynamic> jsonData) {
    return PayClientModel(
      transactionId: jsonData['transactionId']??'',
      accountNo: jsonData['accountNo']??'',
      paymentType: jsonData['paymentType']??'',
      transactionType: jsonData['transactionType'],
      accountFrom: jsonData['accountFrom']??'',
      currency: jsonData['currency']??'',
      amount: double.tryParse(jsonData['amount'].toString()) ?? 0.0,
      receiver: jsonData['receiver']??'',
      description: jsonData['description']??'',
      dateCreated: DateTime.tryParse(jsonData['dateCreated'].toDate().toString())??DateTime.now(),
    );
  }
}
