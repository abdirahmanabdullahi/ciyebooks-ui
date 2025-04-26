
class PayClientModel {
  final String transactionId;
  final String accountNo;
  final String paymentType;
  final String accountFrom;
  final String currency;
  final double amountPaid;
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
    required this.amountPaid,
    required this.receiver,
    required this.dateCreated,
    required this.description,
  });
  Map<String, dynamic> toJson() {
    return {
      'TransactionId': transactionId,
      'accountNo': accountNo,
      'paymentType': paymentType,
      'AccountFrom': accountFrom,
      'Currency': currency,
      'AmountPaid': amountPaid,
      'Receiver': receiver,
      'dateCreated': dateCreated,
      'Description': description,
      'transactionType': transactionType
    };
  }

  factory PayClientModel.fromJson(Map<String, dynamic> jsonData) {
    return PayClientModel(
      transactionId: jsonData['TransactionId']??'',
      accountNo: jsonData['accountNo']??'',
      paymentType: jsonData['paymentType']??'',
      transactionType: jsonData['transactionType'],
      accountFrom: jsonData['AccountFrom']??'',
      currency: jsonData['Currency']??'',
      amountPaid: jsonData['AmountPaid'] ?? 0.0,
      receiver: jsonData['Receiver']??'',
      description: jsonData['Description']??'',
      dateCreated: DateTime.tryParse(jsonData['dateCreated'].toDate().toString())??DateTime.now(),
    );
  }
}
