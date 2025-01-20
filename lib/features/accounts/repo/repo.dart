import 'package:ciyebooks/features/accounts/model/model.dart';
import 'package:ciyebooks/features/auth/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../../../utils/exceptions/firebase_auth_exceptions.dart';
import '../../../utils/exceptions/firebase_exceptions.dart';
import '../../../utils/exceptions/format_exceptions.dart';
import '../../../utils/exceptions/platform_exceptions.dart';

class AccountsRepo extends GetxController {
  static AccountsRepo get instance => Get.find();
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  //Function to save data to firestore

  Future<void> savaAccountData(AccountModel account) async {
    try {
      await _db.collection('Users').doc(FirebaseAuth.instance.currentUser?.uid).collection("Accounts").doc(account.fullName).set(account.toJson(),SetOptions(merge: true));
    } on FirebaseAuthException catch (e) {
      throw TFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatException();
    } on TPlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }
}
