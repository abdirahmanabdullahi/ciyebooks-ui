import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../utils/exceptions/firebase_auth_exceptions.dart';
import '../../../utils/exceptions/firebase_exceptions.dart';
import '../../../utils/exceptions/format_exceptions.dart';
import '../../../utils/exceptions/platform_exceptions.dart';
import '../models/setup_model.dart';

class SetupRepo extends GetxController {
  static SetupRepo get instance => Get.find();

  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final uid = FirebaseAuth.instance.currentUser?.uid;

  //Function to save data to firestore
  Future<void> saveSetupData(BalancesModel balances,id) async {
    try {
      await _db
          .collection('users')
          .doc(id)
          .collection('setup')
          .doc('balances')
          .set(
            balances.toJson(),
          )
          .then((value) => Get.snackbar(
                "Success!",
                'balances update complete',
                backgroundColor: Colors.green,
                colorText: Colors.white,
              ));
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

  /// Update single field
  Future<void> updatesetupStatus(Map<String, dynamic> jsonData) async {
    try {
      await _db.collection('users').doc(uid).update(jsonData);

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

  /// Fetch setup data
  // Future<balancesModel> getsetupData() async {
  //   try {
  //     final documentSnapshot = await _db
  //         .collection('users')
  //         .doc(uid)
  //         .collection('setup')
  //         .doc('balances')
  //         .get();
  //
  //     if (documentSnapshot.exists) {
  //       return balancesModel.fromSnapshot(documentSnapshot);
  //     } else {
  //       return balancesModel.empty();
  //     }
  //
  //   } on FirebaseAuthException catch (e) {
  //     throw TFirebaseAuthException(e.code).message;
  //   } on FirebaseException catch (e) {
  //     throw TFirebaseException(e.code).message;
  //   } on FormatException catch (_) {
  //     throw const TFormatException();
  //   } on TPlatformException catch (e) {
  //     throw TPlatformException(e.code).message;
  //   } catch (e) {
  //     throw 'Something went wrong. Please try again';
  //   }
  // }
}
