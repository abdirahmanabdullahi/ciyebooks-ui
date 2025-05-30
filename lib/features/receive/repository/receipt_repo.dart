import 'package:ciyebooks/features/receive/model/receipt.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../../../utils/exceptions/firebase_auth_exceptions.dart';
import '../../../utils/exceptions/firebase_exceptions.dart';
import '../../../utils/exceptions/format_exceptions.dart';
import '../../../utils/exceptions/platform_exceptions.dart';

class ReceiptRepo extends GetxController {
  static ReceiptRepo get instance => Get.find();
  final _db = FirebaseFirestore.instance;
  final _uid = FirebaseAuth.instance.currentUser?.uid;

  Future<void> recordReceipt(ReceiveModel receipt) async {
    try {
      await _db.collection('users').doc(_uid).collection('transactions').doc(receipt.transactionId).set(receipt.toJson());
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
