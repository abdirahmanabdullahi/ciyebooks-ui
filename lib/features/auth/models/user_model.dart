class UserModel {
  final String accountId;
  String firstName;
  String accountName;
  String lastName;
  final String userName;
  final String email;
  String phoneNumber;
  final bool accountIssetup;

  UserModel({
    required this.firstName,
    required this.accountName,
    required this.accountIssetup,
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
        accountIssetup: false,
      );

  /// Convert userModel to JSON structure for storing data in firestore
  Map<String, dynamic> toJson() {
    return {
      'firstName': firstName,
      'accountName': accountName,
      'lastName': lastName,
      'userName': userName,
      'email': email,
      'phoneNumber': phoneNumber,
      'accountIsSetup': accountIssetup,
      'accountId': accountId,
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> jsonData) {
    return UserModel(
      firstName: jsonData['firstName'] ?? '',
      accountName: jsonData['accountName'] ?? '',
      lastName: jsonData['lastName'] ?? '',
      accountId: jsonData['id'] ?? '',
      userName: jsonData['userName'] ?? '',
      email: jsonData['email'] ?? '',
      phoneNumber: jsonData['phoneNumber'] ?? '',
      accountIssetup: jsonData['accountIsSetup'],
    );
  }
}
