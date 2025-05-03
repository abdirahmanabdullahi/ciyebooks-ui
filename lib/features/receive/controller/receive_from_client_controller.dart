import 'dart:async';
import 'dart:io';

import 'package:ciyebooks/features/receive/model/receive_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../utils/exceptions/firebase_auth_exceptions.dart';
import '../../../../utils/exceptions/firebase_exceptions.dart';
import '../../../../utils/exceptions/format_exceptions.dart';
import '../../../../utils/exceptions/platform_exceptions.dart';
import '../../../common/widgets/error_dialog.dart';
import '../../accounts/model/model.dart';
import '../../setup/models/setup_model.dart';

class ReceiveFromClientController extends GetxController {
  static ReceiveFromClientController get instance => Get.find();


  final counters = {}.obs;
  Rx<BalancesModel> totals = BalancesModel.empty().obs;
  final cashBalances = {}.obs;
  final receipts = {}.obs;
  final cashBalance = 0.0.obs;
  final receivedAmount = 0.0.obs;
  final isButtonEnabled = false.obs;

  RxList<AccountModel> accounts = <AccountModel>[].obs;
  final currency = [].obs;
  final paidToOwner = true.obs;
  final payClientFormKey = GlobalKey<FormState>();
  final transactionCounter = 0.obs;
  final receivedFromOwner = true.obs;

  ///Controllers
  final depositorName = TextEditingController();
  final receiptType = TextEditingController();
  final amount = TextEditingController();
  final receivedCurrency = TextEditingController();
  final receivingAccountName = TextEditingController();
  final receivingAccountNo = TextEditingController();
  final description = TextEditingController();

  ///Sort criteria
  final sortCriteria = 'dateCreated'.obs;


  final _uid = FirebaseAuth.instance.currentUser?.uid;

  @override
  onInit() {

    fetchTotals();

    ///Add listeners to the controllers
    depositorName.addListener(updateButtonStatus);
    receivingAccountNo.addListener(updateButtonStatus);
    amount.addListener(updateButtonStatus);
    receivedCurrency.addListener(updateButtonStatus);

    ///Get the totals and balances
    fetchTotals();

    /// Stream for the accounts
    FirebaseFirestore.instance.collection('Users').doc(_uid).collection('accounts').snapshots().listen((querySnapshot) {
      accounts.value = querySnapshot.docs.map((doc) {
        return AccountModel.fromJson(doc.data());
      }).toList();
    });
    super.onInit();
  }

  void updateButtonStatus() {
    isButtonEnabled.value =   amount.text.isNotEmpty && receivedCurrency.text.isNotEmpty && (num.parse(amount.text) > 0);
  }

  /// *-----------------------------Start data submission---------------------------------*
  fetchTotals() async {
    FirebaseFirestore.instance.collection('Users').doc(_uid).collection('Setup').doc('Balances').snapshots().listen((snapshot) {
      if (snapshot.exists) {
        totals.value = BalancesModel.fromJson(snapshot.data()!);
        cashBalances.value = totals.value.cashBalances;
        counters.value = totals.value.transactionCounters;
        receipts.value = totals.value.payments;

        transactionCounter.value = counters['receiptsCounter'];
      }
    });

  }

  /// Check internet connection
  checkInternetConnection(BuildContext context) async {
    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        if (context.mounted) {
          createReceipt(context);
        }
      }
    } on SocketException catch (_) {
      if (context.mounted) {
        showErrorDialog(context: context, errorTitle: 'Connection error!', errorText: 'Please check your network connection and try again.');
      }
    }
  }
  /// *-----------------------------Create and share pdf receipt----------------------------------*




  Future createReceipt(BuildContext context) async {

    if (!paidToOwner.value) {
      if (!payClientFormKey.currentState!.validate()) {
        return;
      }
    }
    try {




      /// Initialize batch
      final db = FirebaseFirestore.instance;
      final batch = db.batch();

      ///Doc references
      final paymentRef = db.collection('Users').doc(_uid).collection('transactions').doc('RCPT-${counters['receiptsCounter']}');
      final counterRef = db.collection('Users').doc(_uid).collection('Setup').doc('Balances');
      final cashRef = db.collection('Users').doc(_uid).collection('Setup').doc('Balances');
      final accountRef = db.collection('Users').doc(_uid).collection('accounts').doc('PA-${receivingAccountNo.text.trim()}');

      ///Get data from the controllers
      final newPayment = ReceiveModel(
          transactionId: 'RCPT-${counters['receiptsCounter']}',
          transactionType: 'receipt',
          depositType: 'cash',
          depositorName: depositorName.text.trim(),
          currency: receivedCurrency.text.trim(),
          amount: double.tryParse(amount.text.trim()) ?? 0.0,
          receivingAccountNo: receivingAccountNo.text.trim(),
          dateCreated: DateTime.now(),
          description: description.text.trim(), receivingAccountName: receivingAccountName.text.trim());

      ///Update account
      batch.update(accountRef, {'Currencies.${receivedCurrency.text.trim()}': FieldValue.increment(num.parse(amount.text.trim()))});

      ///Create payment transaction
      batch.set(paymentRef, newPayment.toJson());

      ///update cash balance
      ///update cash balance
      batch.update(
          cashRef,
          receiptType.text.trim() == 'Bank transfer'
              ? {"bankBalances.${receivedCurrency.text.trim()}": FieldValue.increment(num.parse(amount.text.trim()))}
              : {"cashBalances.${receivedCurrency.text.trim()}": FieldValue.increment(num.parse(amount.text.trim()))});

      ///update payments total
      batch.update(cashRef, {"payments.${receivedCurrency.text.trim()}": FieldValue.increment(num.parse(amount.text.trim()))});

      ///Update payment counter
      batch.update(counterRef, {"transactionCounters.receiptsCounter": FieldValue.increment(1)});

      await batch.commit().then((_) {
        Get.snackbar(
          icon: Icon(
            Icons.cloud_done,
            color: Colors.white,
          ),
          shouldIconPulse: true,
          "Success",
          'Deposit created successfully',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      });
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
