import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String id;
  String firstName;
  String lastName;
  final String userName;
  final String email;
  String phoneNumber;
  String profilePicture;
  bool accountSetupComplete;

  UserModel(
      {required this.firstName,
      required this.lastName,
      required this.id,
      required this.userName,
      required this.email,
      required this.phoneNumber,
      required this.profilePicture,
      required this.accountSetupComplete});

  String get fullName => '$firstName $lastName';

  ///Static function to create an empty userModel.
  static UserModel empty() => UserModel(
        firstName: '',
        lastName: '',
        id: '',
        userName: '',
        email: '',
        phoneNumber: '',
        profilePicture: '',
        accountSetupComplete: false,
      );

  /// Convert usermodel to JSON structure for storing data in firestore
  Map<String, dynamic> toJson() {
    return {
      'firstName': firstName,
      'LastName': lastName,
      'UserName': userName,
      'Email': email,
      'PhoneNumber': phoneNumber,
      'ProfilePicture': profilePicture,
      'accountSetupComplete':accountSetupComplete,
    };
  }

  factory UserModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    if (document.data() != null) {
      final data = document.data()!;
      return UserModel(
          firstName: data['FirstName'] ?? '',
          lastName: data['LastName'] ?? '',
          id: document.id,
          userName: data['UserName'] ?? '',
          email: data['Email'] ?? '',
          phoneNumber: data['phoneNumber'] ?? '',
          profilePicture: data['profilePicture'] ?? '',
          accountSetupComplete: data['accountSetupComplete'] ?? false);
    } else {
      return UserModel.empty();
    }
  }
}
