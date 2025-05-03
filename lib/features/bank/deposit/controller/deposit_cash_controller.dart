import 'dart:async';
import 'dart:io';

import 'package:ciyebooks/features/bank/deposit/model/deposit_model.dart';
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

class DepositCashController extends GetxController {
  static DepositCashController get instance => Get.find();

  final counters = {}.obs;
  Rx<BalancesModel> totals = BalancesModel.empty().obs;

  final isButtonEnabled = false.obs;
  final bankBalances = {}.obs;
  final cashBalances = {}.obs;
  final depositedByOwner = true.obs;

  ///Sort by date for the history screen
  final sortCriteria = 'dateCreated'.obs;
  // sortExpenses(){
  //
  // }

  // final currency = [].obs;
  final withCashFormKey = GlobalKey<FormState>();
  final transactionCounter = 0.obs;

  ///Controllers
  final amount = TextEditingController();
  final depositedCurrency = TextEditingController();
  final description = TextEditingController();
  final depositorName = TextEditingController();

  ///

  final _uid = FirebaseAuth.instance.currentUser?.uid;

  @override
  onInit() {
    fetchTotals();

    ///Add listeners to the controllers
    depositedCurrency.addListener(updateButtonStatus);
    amount.addListener(updateButtonStatus);

    ///Get the totals and balances
    fetchTotals();

    super.onInit();
  }

  updateButtonStatus() {
    isButtonEnabled.value = depositedCurrency.text.isNotEmpty && amount.text.isNotEmpty && (num.parse(amount.text) > 0);
  }

  /// *-----------------------------Start data submission---------------------------------*
  fetchTotals() async {
    FirebaseFirestore.instance.collection('Users').doc(_uid).collection('Setup').doc('Balances').snapshots().listen(
      (snapshot) {
        if (snapshot.exists) {
          totals.value = BalancesModel.fromJson(snapshot.data()!);
          cashBalances.value = totals.value.cashBalances;
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
          createBankDeposit(context);
        }
      }
    } on SocketException catch (_) {
      if (context.mounted) {
        showErrorDialog(context: context, errorTitle: 'Connection error!', errorText: 'Please check your network connection and try again.');
      }
    }
  }  /// *-----------------------------Create and share pdf receipt----------------------------------*


  Future createBankDeposit(BuildContext context) async {

    try {
      ///Compare cash and amount to be paid
      // cashBalance.value = double.tryParse(cashBalances[depositedCurrency.text.trim()].toString()) ?? 0.0;

      if ((double.tryParse(amount.text.trim()) ?? 0.0) > (double.tryParse(cashBalances[depositedCurrency.text.trim()].toString()) ?? 0.0)) {
        Get.snackbar(
          icon: Icon(
            Icons.cloud_done,
            color: Colors.white,
          ),
          shouldIconPulse: true,
          "Bank deposit failed",
          'Amount to be deposited cannot be more than cash in hand',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );

        return;
      }
      if ((double.tryParse(amount.text.trim()) ?? 0.0) == (double.tryParse(cashBalances[depositedCurrency.text.trim()].toString()) ?? 0.0)) {
        Get.snackbar(
          icon: Icon(
            Icons.cloud_done,
            color: Colors.white,
          ),
          shouldIconPulse: true,
          "Zero cash warning",
          'If you make this deposit, you will have no cash left',
          backgroundColor: Colors.orangeAccent,
          colorText: Colors.white,
        );
        // return;
      }

      /// Initialize batch
      final db = FirebaseFirestore.instance;
      final batch = db.batch();

      ///Doc references
      final depositRef = db.collection('Users').doc(_uid).collection('transactions').doc('BKDP-${counters['bankDepositCounter']}');
      final counterRef = db.collection('Users').doc(_uid).collection('Setup').doc('Balances');
      final cashRef = db.collection('Users').doc(_uid).collection('Setup').doc('Balances');

      final newDeposit = DepositModel(
        depositedBy: depositorName.text.trim(),
        transactionType: 'deposit',
        transactionId: 'DPST-${counters['bankDepositCounter']}',
        currency: depositedCurrency.text.trim(),
        amount: double.tryParse(amount.text.trim()) ?? 0.0,
        dateCreated: DateTime.now(),
        description: description.text.trim(),
      );

      ///Create payment transaction
      batch.set(depositRef, newDeposit.toJson());

      ///update cash balance
      batch.update(cashRef, {"cashBalances.${depositedCurrency.text.trim()}": FieldValue.increment(-num.parse(amount.text.trim()))});

      ///update bank balance
      batch.update(cashRef, {"bankBalances.${depositedCurrency.text.trim()}": FieldValue.increment(num.parse(amount.text.trim()))});

      ///update deposit total
      batch.update(cashRef, {"deposits.${depositedCurrency.text.trim()}": FieldValue.increment(num.parse(amount.text.trim()))});

      ///Update expense counter
      batch.update(counterRef, {"transactionCounters.bankDepositCounter": FieldValue.increment(1)});

      await batch.commit().then((_) {
        Get.snackbar(
          icon: Icon(
            Icons.cloud_done,
            color: Colors.white,
          ),
          shouldIconPulse: true,
          "Success",
          'deposit created successfully',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      });
      if (context.mounted) {
        Navigator.of(context).pop();
      }
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
