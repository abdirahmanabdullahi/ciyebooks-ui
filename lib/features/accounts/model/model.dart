class AccountModel {
  final String accountName;
  final String firstName;
  final String lastName;
  final String accountNo;
  final String phoneNo;
  final String email;
  final double usdBalance;
  final double kesBalance;

  final DateTime dateCreated;
  AccountModel({
    required this.accountName,  required this.usdBalance,
    required this.kesBalance,

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
      'UsdBalance': usdBalance,
      'KesBalance': kesBalance,
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
      usdBalance: jsonData['UsdBalance'] ??0.0,
      kesBalance: jsonData['KesBalance'] ??0.0,

    );
  }
}
