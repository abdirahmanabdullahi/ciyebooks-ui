import 'dart:io';

import 'package:ciyebooks/features/accounts/model/model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../common/widgets/error_dialog.dart';
import '../../../utils/exceptions/firebase_auth_exceptions.dart';
import '../../../utils/exceptions/firebase_exceptions.dart';
import '../../../utils/exceptions/platform_exceptions.dart';
import '../../setup/models/setup_model.dart';

class AccountsController extends GetxController {
  static AccountsController get instance => Get.find();

  final counters = {}.obs;
  final isLoading = false.obs;
  final isButtonEnabled = false.obs;
  Rx<BalancesModel> totals = BalancesModel.empty().obs;

  final db = FirebaseFirestore.instance;
  final uid = FirebaseAuth.instance.currentUser?.uid;

  final  startingDate = DateTime.now().obs;
  final  endDate = DateTime.now().obs;


  final firstName = TextEditingController();
  final lastName = TextEditingController();
  final phoneNo = TextEditingController();
  final email = TextEditingController();


  /// Clear controllers after data submission
  clearControllers() {
    firstName.clear();
    lastName.clear();
    phoneNo.clear();
    email.clear();

  }

  @override
  void onInit() {

    final now = DateTime.now();
    final startOfMonth = DateTime(now.year, now.month, 1);
    startingDate.value =startOfMonth;


    fetchTotals();
    firstName.addListener(updateButtonStatus);
    lastName.addListener(updateButtonStatus);
    super.onInit();
  }


  checkInternetConnection(BuildContext context) async {
    isLoading.value = true;
    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        if (context.mounted) {
          createAccount(context);
        }
      }
    } on SocketException catch (_) {
      isLoading.value = false;
      if (context.mounted) {
        showErrorDialog(context: context, errorTitle: 'Connection error!', errorText: 'Please check your network connection and try again.');
      }
    }
  }

  /// Enable/disable submit button
  updateButtonStatus() {
    isButtonEnabled.value = firstName.text.isNotEmpty && lastName.text.isNotEmpty;
  }

  fetchTotals() async {
    DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance.collection('users').doc(uid).collection('setup').doc('balances').get();

    if (documentSnapshot.exists && documentSnapshot.data() != null) {
      final data = documentSnapshot.data() as Map<String, dynamic>;
      totals.value = BalancesModel.fromJson(data);
    }
  }

  /// Create accounts
  Future<void> createAccount(BuildContext context) async {
    isLoading.value = true;
    try {
      final newAccount = AccountModel(
        currencies: {'USD': 0.0, 'KES': 0.0},

        firstName: firstName.text.trim(),
        overDrawn: false,
        lastName: lastName.text.trim(),
        accountNo: '${totals.value.transactionCounters['accountsCounter']}',
        phoneNo: phoneNo.text.trim(),
        email: email.text.trim(),
        // dateCreated: DateTime.now(),
        accountName: '${firstName.text.trim()}${lastName.text.trim()}', dateCreated: DateTime.now(),
        // usdBalance: 0.0,
        // kesBalance: 0.0
      );

      final batch = db.batch();
      final newAccountRef = db.collection('users').doc(uid).collection("accounts").doc('${totals.value.transactionCounters['accountsCounter']}');
      final accountNoRef = db.collection('users').doc(uid).collection("setup").doc('balances');

      ///Create new account
      batch.set(newAccountRef, newAccount.toJson());

      ///Update the account number counter
      batch.update(accountNoRef, {"transactionCounters.accountsCounter": FieldValue.increment(1)});

      await batch.commit().then((_) {
        clearControllers();
        isLoading.value = false;

        if (context.mounted) {
          Navigator.pop(context);
        }
        Get.snackbar(
          icon: Icon(
            Icons.cloud_done,
            color: Colors.white,
          ),
          shouldIconPulse: true,
          "Success",
          'Account created successfully',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      });
    } on FirebaseAuthException catch (e) {
      throw TFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on TPlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      isLoading.value = false;

      throw 'Something went wrong. Please try again';
    }finally{
      isLoading.value=false;
    }
    Get.snackbar(
      "Success!",
      "Account has been created.",
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );

    Get.back();
  }

  /// Update totals
}
