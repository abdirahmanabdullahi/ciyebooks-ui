class AccountModel {
  final String accountName;
  final String firstName;
  final String lastName;
  final String accountNo;
  final String phoneNo;
  final bool overDrawn;
  final String email;
  final Map<String,dynamic>currencies;

  final DateTime dateCreated;
  AccountModel({
    required this .currencies,
    required this.accountName,
    required this.overDrawn,

    required this.dateCreated,
    required this.firstName,
    required this.lastName,
    required this.accountNo,
    required this.phoneNo,
    required this.email,
  });

  String get fullName => '$firstName $lastName';

  /// Convert AccountsModel to JSON structure for storing data in firestore

  Map<String, dynamic> toJson() {
    return {
      'dateCreated': dateCreated,
      'overDrawn': overDrawn,
      'accountName': fullName,
      'firstName': firstName,
      'lastName': lastName,
      'accountNo': accountNo,
      'phoneNo': phoneNo,
      'email': email,
      'currencies':currencies


    };
  }

  factory AccountModel.fromJson(Map<String, dynamic> jsonData) {
    return AccountModel(
        accountName: jsonData['accountName'] ?? '',
        overDrawn: jsonData['overDrawn'] ,
        dateCreated: DateTime.parse(jsonData['dateCreated'].toDate().toString()),
        firstName: jsonData['firstName'] ?? '',
        lastName: jsonData['lastName'] ?? '',
        accountNo: jsonData['accountNo'] ?? '',
        phoneNo: jsonData['phoneNo'] ?? '',
      email: jsonData['email'] ?? '',
        currencies: Map<String, dynamic>.from(jsonData['currencies'])

    );
  }
}
