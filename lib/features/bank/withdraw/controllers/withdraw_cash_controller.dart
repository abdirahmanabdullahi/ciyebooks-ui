import 'dart:async';
import 'dart:io';

import 'package:ciyebooks/features/bank/withdraw/model/withdraw_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


import '../../../../common/widgets/error_dialog.dart';
import '../../../../utils/exceptions/firebase_auth_exceptions.dart';
import '../../../../utils/exceptions/firebase_exceptions.dart';
import '../../../../utils/exceptions/format_exceptions.dart';
import '../../../../utils/exceptions/platform_exceptions.dart';
import '../../../setup/models/setup_model.dart';

class WithdrawCashController extends GetxController {
  static WithdrawCashController get instance => Get.find();

  final counters = {}.obs;
  Rx<BalancesModel> totals = BalancesModel.empty().obs;
  final bankBalances = {}.obs;
  final isButtonEnabled = false.obs;
  final isLoading = false.obs;

  ///Sort by date for the history screen
  final sortCriteria = 'dateCreated'.obs;

  // final currency = [].obs;
  final withdrawCashFormKey = GlobalKey<FormState>();
  final transactionCounter = 0.obs;

  ///Controllers
  final amount = TextEditingController();
  final withdrawnCurrency = TextEditingController();
  final description = TextEditingController();
  final withdrawnBy = TextEditingController();
  final withdrawType = TextEditingController();

  ///

  final _uid = FirebaseAuth.instance.currentUser?.uid;

  @override
  onInit() {
    fetchTotals();

    ///Add listeners to the controllers
    withdrawnCurrency.addListener(updateButtonStatus);
    amount.addListener(updateButtonStatus);

    ///Get the totals and balances
    fetchTotals();

    super.onInit();
  }


  /// *-----------------------------Enable or disable the continue button----------------------------------*

  updateButtonStatus() {
    isButtonEnabled.value = withdrawnCurrency.text.isNotEmpty && amount.text.isNotEmpty && (num.parse(amount.text) > 0);
  }

  /// *-----------------------------Start data submission---------------------------------*
  fetchTotals() async {
    FirebaseFirestore.instance.collection('Users').doc(_uid).collection('Setup').doc('Balances').snapshots().listen(
          (snapshot) {
        if (snapshot.exists) {
          bankBalances.value = totals.value.bankBalances;
          totals.value = BalancesModel.fromJson(snapshot.data()!);
          counters.value = totals.value.transactionCounters;
          transactionCounter.value = counters['bankDepositCounter'];
        }
      },
    );

  }

  /// Check internet connection
  checkInternetConnection(BuildContext context) async {
    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        if (context.mounted) {
          createWithdrawal(context);
        }
      }
    } on SocketException catch (_) {
      if (context.mounted) {
        showErrorDialog(context: context, errorTitle: 'Connection error!', errorText: 'Please check your network connection and try again.');
      }
    }
  }


  Future createWithdrawal(BuildContext context) async {
    isLoading.value = true;

    try {
      ///Compare bank balance and amount to withdraw

      if ((double.tryParse(amount.text.trim()) ?? 0.0) > (double.tryParse(bankBalances[withdrawnCurrency.text.trim()].toString())??0.0)) {
        Get.snackbar(
          icon: Icon(
            Icons.cloud_done,
            color: Colors.white,
          ),
          shouldIconPulse: true,
          "Withdrawal failed",
          'Amount to withdrawn cannot be more than bank balance',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        isLoading.value = false;

        return;
      }
      if ((double.tryParse(amount.text.trim()) ?? 0.0) == (double.tryParse(bankBalances[withdrawnCurrency.text.trim()].toString())??0.0)) {
        Get.snackbar(
          icon: Icon(
            Icons.cloud_done,
            color: Colors.white,
          ),
          shouldIconPulse: true,
          "Zero bank warning",
          'If you make this withdrawal, you will have no bank balance',
          backgroundColor: Colors.orangeAccent,
          colorText: Colors.white,
        );
        // return;
      }

      /// Initialize batch
      final db = FirebaseFirestore.instance;
      final batch = db.batch();

      ///Doc references
      final depositRef = db.collection('Users').doc(_uid).collection('transactions').doc('WDR-${counters['bankWithdrawCounter']}');
      final counterRef = db.collection('Users').doc(_uid).collection('Setup').doc('Balances');
      final cashRef = db.collection('Users').doc(_uid).collection('Setup').doc('Balances');

      final newWithdrawal = WithdrawModel(
          description: description.text.trim(),
          withdrawnBy: withdrawnBy.text.trim(),
          transactionType: 'withdrawal',
          transactionId: 'BKWD-${counters['bankWithdrawCounter']}',
          currency: withdrawnCurrency.text.trim(),
          amount: double.tryParse(amount.text.trim())??0.0,
          dateCreated: DateTime.now(),
          withdrawalType: withdrawType.text.trim());

      ///Create withdraw transaction
      batch.set(depositRef, newWithdrawal.toJson());

      ///update cash balance
      batch.update(cashRef, {"cashBalances.${withdrawnCurrency.text.trim()}": FieldValue.increment(num.parse(amount.text.trim()))});

      /// Update bank balances
      batch.update(cashRef, {"bankBalances.${withdrawnCurrency.text.trim()}": FieldValue.increment(-num.parse(amount.text.trim()))});

      ///update withdraw total
      batch.update(cashRef, {"withdrawals.${withdrawnCurrency.text.trim()}": FieldValue.increment(num.parse(amount.text.trim()))});

      ///Update withdraw counter
      batch.update(counterRef, {"transactionCounters.bankWithdrawCounter": FieldValue.increment(1)});

      await batch.commit().then((_) {
        Get.snackbar(
          icon: Icon(
            Icons.cloud_done,
            color: Colors.white,
          ),
          shouldIconPulse: true,
          "Success",
          'Withdrawal created successfully',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

      });
      isLoading.value = false;

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

  /// *-----------------------------End data submission----------------------------------*
}
