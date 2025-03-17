class AccountModel {
  final String accountName;
  final String firstName;
  final String lastName;
  final String accountNo;
  final String phoneNo;
  final String email;
  final Map<String,dynamic>currencies;

  final DateTime dateCreated;
  AccountModel({
    required this .currencies,
    required this.accountName,

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
      'DateCreated': dateCreated,
      'AccountName': fullName,
      'FirstName': firstName,
      'LastName': lastName,
      'AccountNo': accountNo,
      'PhoneNo': phoneNo,
      'Email': email,
      'Currencies':currencies


    };
  }

  factory AccountModel.fromJson(Map<String, dynamic> jsonData) {
    return AccountModel(
        accountName: jsonData['AccountName'] ?? '',
        dateCreated: DateTime.parse(jsonData['DateCreated'].toDate().toString()),
        firstName: jsonData['FirstName'] ?? '',
        lastName: jsonData['LastName'] ?? '',
        accountNo: jsonData['AccountNo'] ?? '',
        phoneNo: jsonData['PhoneNo'] ?? '',
      email: jsonData['Email'] ?? '',
        currencies: Map<String, dynamic>.from(jsonData['Currencies'])

    );
  }
}
