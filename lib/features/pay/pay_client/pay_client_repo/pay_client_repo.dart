import 'package:ciyebooks/features/pay/pay_client/pay_client_model/pay_client_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../../../../utils/exceptions/firebase_auth_exceptions.dart';
import '../../../../utils/exceptions/firebase_exceptions.dart';
import '../../../../utils/exceptions/format_exceptions.dart';
import '../../../../utils/exceptions/platform_exceptions.dart';
class PayClientRepo extends GetxController{
  static PayClientRepo  get instance => Get.find();
  final _db = FirebaseFirestore.instance;
  final _uid = FirebaseAuth.instance.currentUser?.uid;

  /// Save payment to Firestore
Future<void> savePaymentRecord(PayClientModel newPayment)async {
  try {
    await _db.collection('Users').doc(_uid).collection('transactions').doc(newPayment.transactionId).set(newPayment.toJson());
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
