class UserModel {
  final String accountId;
  String firstName;
  String accountName;
  String lastName;
  final String userName;
  final String email;
  String phoneNumber;
  final bool accountIsSetup;

  UserModel({
    required this.firstName,
    required this.accountName,
    required this.accountIsSetup,
    required this.lastName,
    required this.accountId,
    required this.userName,
    required this.email,
    required this.phoneNumber,
  });

  String get fullName => '$firstName $lastName';

  ///Static function to create an empty userModel.
  static UserModel empty() => UserModel(
    accountName:'',
        firstName: '',
        lastName: '',
        accountId: '',
        userName: '',
        email: '',
        phoneNumber: '',
        accountIsSetup: false,
      );

  /// Convert userModel to JSON structure for storing data in firestore
  Map<String, dynamic> toJson() {
    return {
      'firstName': firstName,
      'accountName': accountName,
      'LastName': lastName,
      'UserName': userName,
      'Email': email,
      'PhoneNumber': phoneNumber,
      'AccountIsSetup': accountIsSetup,
      'accountId': accountId,
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> jsonData) {
    return UserModel(
      firstName: jsonData['FirstName'] ?? '',
      accountName: jsonData['accountName'] ?? '',
      lastName: jsonData['LastName'] ?? '',
      accountId: jsonData['id'] ?? '',
      userName: jsonData['UserName'] ?? '',
      email: jsonData['Email'] ?? '',
      phoneNumber: jsonData['PhoneNumber'] ?? '',
      accountIsSetup: jsonData['AccountIsSetup'],
    );
  }
}
