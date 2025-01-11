class UserModel {
  final String id;
  String firstName;
  String lastName;
  final String userName;
  final String email;
  String phoneNumber;
  String profilePicture;

  UserModel(
      {required this.firstName,
      required this.lastName,
      required this.id,
      required this.userName,
      required this.email,
      required this.phoneNumber,
      required this.profilePicture});

  String get fullName => '$firstName $lastName';

  ///Static function to create an empty userModel.
  static UserModel empty() => UserModel(
      firstName: '',
      lastName: '',
      id: '',
      userName: '',
      email: '',
      phoneNumber: '',
      profilePicture: '');

  /// Convert usermodel to JSON structure for storing data in firestore
  Map<String, dynamic> toJson() {
    return {
      'firstName': firstName,
      'LastName': lastName,
      'UserName': userName,
      'Email': email,
      'PhoneNumber': phoneNumber,
      'ProfilePicture': profilePicture,
    };
  }
}
