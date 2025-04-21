import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../../../utils/exceptions/firebase_auth_exceptions.dart';
import '../../../utils/exceptions/firebase_exceptions.dart';
import '../../../utils/exceptions/format_exceptions.dart';
import '../../../utils/exceptions/platform_exceptions.dart';

class CurrencyRepo extends GetxController {
  static CurrencyRepo get instance => Get.find();

  final _db = FirebaseFirestore.instance;
  final _uid = FirebaseAuth.instance.currentUser!.uid;

  Future<void> createCurrency(newCurrency) async {
    ///FirebaseFirestore.instance.collection('Users').doc(_uid).collection('Balances').doc('Currency stock').
    try {
      await _db
          .collection('Users')
          .doc(_uid)
          .collection('Balances')
          .doc('Currency stock')
          .update(newCurrency);
    } on FirebaseAuthException catch (e) {
      throw TFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;

    } on FormatException catch (_) {
      throw const TFormatException();
    } on TPlatformException catch (e) {
      throw TPlatformException(e.code).message;
    }
  }
}