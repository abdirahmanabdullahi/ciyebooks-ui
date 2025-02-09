import 'package:ciyebooks/features/pay/pay_expense/expense_model/expense_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../../../../utils/exceptions/firebase_auth_exceptions.dart';
import '../../../../utils/exceptions/firebase_exceptions.dart';
import '../../../../utils/exceptions/format_exceptions.dart';
import '../../../../utils/exceptions/platform_exceptions.dart';
class ExpenseRepo extends GetxController{
  static ExpenseRepo  get instance => Get.find();
  final _db = FirebaseFirestore.instance;
  final _uid = FirebaseAuth.instance.currentUser?.uid;

  /// Save payment to Firestore
  Future<void> recordExpense(ExpenseModel newExpense)async {
    try {
      await _db.collection('Users').doc(_uid).collection('transactions').doc(newExpense.transactionId).set(newExpense.toJson());
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
