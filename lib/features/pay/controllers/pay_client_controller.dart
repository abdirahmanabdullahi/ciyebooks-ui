import 'dart:async';
import 'dart:io';

import 'package:ciyebooks/features/pay/screens/payments/confirm_payment.dart';
import 'package:ciyebooks/features/pay/screens/payments/payment_success_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../common/widgets/error_dialog.dart';
import '../../../../utils/exceptions/firebase_auth_exceptions.dart';
import '../../../../utils/exceptions/firebase_exceptions.dart';
import '../../../../utils/exceptions/format_exceptions.dart';
import '../../../../utils/exceptions/platform_exceptions.dart';
import '../../accounts/model/model.dart';
import '../../setup/models/setup_model.dart';
import '../../stats/models/stats_model.dart';
import '../models/pay_client_model.dart';

class PayClientController extends GetxController {
  static PayClientController get instance => Get.find();
  final String today = DateFormat("d MMM yyyy ").format(DateTime.now());

  final _uid = FirebaseAuth.instance.currentUser?.uid;
  final NumberFormat formatter = NumberFormat.decimalPatternDigits(
    locale: 'en_us',
    decimalDigits: 2,
  );
  final counters = {}.obs;
  Rx<BalancesModel> totals = BalancesModel.empty().obs;
  final cashBalances = {}.obs;
  final bankBalances = {}.obs;
  final payments = {}.obs;
  final cashBalance = 0.0.obs;
  final paidAmount = 0.0.obs;
  final isButtonEnabled = false.obs;
  final dailyReportCreated = false.obs;
  final isLoading = false.obs;
  RxList<AccountModel> accounts = <AccountModel>[].obs;
  final currency = [].obs;
  final paidToOwner = true.obs;
  final transactionCounter = 0.obs;

  ///Controllers
  final from = TextEditingController();
  final paymentType = TextEditingController();
  final amount = TextEditingController();
  final paidCurrency = TextEditingController();
  final receiver = TextEditingController();
  final accountNo = TextEditingController();
  final paidTo = TextEditingController();
  final description = TextEditingController();

  /// Clear controllers after data submission
  clearController() {
    from.clear();
    paymentType.clear();
    amount.clear();
    paidCurrency.clear();
    receiver.clear();
    accountNo.clear();
    paidTo.clear();
    description.clear();
  }

  @override
  onInit() {
    ///Add listeners to the controllers
    accountNo.addListener(updateButtonStatus);
    amount.addListener(updateButtonStatus);
    paidCurrency.addListener(updateButtonStatus);
    paymentType.addListener(updateButtonStatus);
    paidCurrency.addListener(updateButtonStatus);
    receiver.addListener(updateButtonStatus);

    ///Get the totals and balances
    fetchTotals();

    /// Check if daily report is created.
    createDailyReport();

    /// Stream for the accounts

    FirebaseFirestore.instance.collection('Users').doc(_uid).collection('accounts').snapshots().listen((querySnapshot) {
      accounts.value = querySnapshot.docs.map((doc) {
        return AccountModel.fromJson(doc.data());
      }).toList();
    });
    super.onInit();
  }

  ///Dispose off controllers
  disposeControllers() {
    from.dispose();
    paidCurrency.dispose();
    receiver.dispose();
    amount.dispose();
    description.dispose();
  }

  void updateButtonStatus() {
    isButtonEnabled.value =
        accountNo.text.isNotEmpty && amount.text.isNotEmpty && paidCurrency.text.isNotEmpty && receiver.text.isNotEmpty && paymentType.text.isNotEmpty && ((double.tryParse(amount.text) ?? 0.0) > 0);
  }

  fetchTotals() async {
    FirebaseFirestore.instance.collection('Users').doc(_uid).collection('Setup').doc('Balances').snapshots().listen((snapshot) {
      if (snapshot.exists) {
        totals.value = BalancesModel.fromJson(snapshot.data()!);
        cashBalances.value = totals.value.cashBalances;
        bankBalances.value = totals.value.bankBalances;

        if (cashBalances.containsKey('KES')) {
        } else {}
        counters.value = totals.value.transactionCounters;
        transactionCounter.value = counters['paymentsCounter'];
      }
    });
  }

  /// Check and create daily report if not Created
  createDailyReport() async {
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(_uid)
        .collection('DailyReports')
        .doc('13 May 2025')
        .set(DailyReportModel(
        received: {'USD': 1243454, 'KES': 456252},
        payments: {'USD': 2354, 'KES':2345},
        deposits: {'USD': 876, 'KES': 124},
        withdrawals: {'USD': 345, 'KES': 324},
        expenses: {'USD': 3452, 'KES': 345},
        dailyProfit: 451)
        .toJson())
        .then((_) {
      print('Done');
    });
    // final reportRef = FirebaseFirestore.instance.collection('Users').doc(_uid).collection('DailyReports').doc(today);
    // final snapshot = await reportRef.get();
    // if (snapshot.exists) {
    //   dailyReportCreated.value = true;
    // }
    // final snapshot = await reportRef.get();
    // if (snapshot.exists) {
    //   dailyReportCreated.value = true;
    // }
  }

  checkBalances(BuildContext context) {
    /// Check if currency is at bank and amount is enough to pay amount requested
    if (paymentType.text.trim() == 'Bank transfer') {
      final currencyKey = paidCurrency.text.trim();

      if (!bankBalances.containsKey(currencyKey)) {
        showErrorDialog(context: context, errorTitle: 'Currency not available', errorText: 'You do not have a $currencyKey bank account registered.');
        return;
      }

      final availableAmount = double.parse('${bankBalances[currencyKey]}');
      final requestedAmount = double.parse(amount.text.trim());

      if (requestedAmount > availableAmount) {
        showErrorDialog(context: context, errorTitle: 'Insufficient bank balance', errorText: 'You do have enough ${paidCurrency.text.trim()} in your bank account to make this transfer.');
        return;
      }
      // if (requestedAmount == availableAmount) {
      //   showErrorDialogWithContinueButton(context: context, errorTitle: 'Zero balance warning', errorText: 'If you make this payment you will have no ${paidCurrency.text.trim()} left!', cancelTransaction: Navigator.of(context).pop(), continueTransaction: null);
      //   // showErrorDialog(context: context, errorTitle: 'Zero balance warning', errorText: 'If you make this payment you will have no ${paidCurrency.text.trim()} left!');
      //   return;
      // }
      // showConfirmPayment(context);
    }

    /// Check if currency is in cash and amount is enough to pay amount requested
    if (paymentType.text.trim() != 'Bank transfer') {
      final currencyKey = paidCurrency.text.trim();

      if (!cashBalances.containsKey(currencyKey)) {
        showErrorDialog(context: context, errorTitle: 'Currency not available', errorText: 'You have no ${paidCurrency.text.trim()} in cash');
        return;
      }

      final availableAmount = double.parse('${cashBalances[currencyKey]}');
      final requestedAmount = double.parse(amount.text.trim());

      if (requestedAmount > availableAmount) {
        showErrorDialog(context: context, errorTitle: 'Insufficient cash balance', errorText: 'You do not have enough ${paidCurrency.text.trim()} in cash to make this payment.');
        return;
      }
    }

    showConfirmPayment(context);
  }

  /// Check internet connection
  checkInternetConnection(BuildContext context) async {
    isLoading.value =true;
    try {
      isLoading.value = true;
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        if (context.mounted) {
          createPayment(context);
        }
      }
    } on SocketException catch (_) {
      isLoading.value = false;
      if (context.mounted) {
        showErrorDialog(context: context, errorTitle: 'Connection error!', errorText: 'Please check your network connection and try again.');
      }
      return;
    }
  }

  Future createPayment(BuildContext context) async {
    ///Check and create daily report if not created already
    await createDailyReport();

    try {

      /// Initialize batch
      final db = FirebaseFirestore.instance;
      final batch = db.batch();

      ///Doc references
      final dailyReportRef = db.collection('Users').doc(_uid).collection('DailyReports').doc(today);
      final paymentRef = db.collection('Users').doc(_uid).collection('transactions').doc('PAY-${counters['paymentsCounter']}');
      final counterRef = db.collection('Users').doc(_uid).collection('Setup').doc('Balances');
      final cashRef = db.collection('Users').doc(_uid).collection('Setup').doc('Balances');
      final accountRef = db.collection('Users').doc(_uid).collection('accounts').doc('PA-${accountNo.text.trim()}');

      ///Get data from the controllers
      final newPayment = PayClientModel(
          transactionId: 'PAY-${counters['paymentsCounter']}',
          transactionType: 'payment',
          accountNo: accountNo.text.trim(),
          paymentType: paymentType.text.trim(),
          accountFrom: from.text.trim(),
          currency: paidCurrency.text.trim(),
          amountPaid: double.tryParse(amount.text.trim()) ?? 0.0,
          receiver: paidToOwner.value ? from.text.trim() : receiver.text.trim(),
          dateCreated: DateTime.now(),
          description: description.text.trim());

      /// Check and create daily report if it does not exist;
      if (!dailyReportCreated.value) {
        batch.set(dailyReportRef, DailyReportModel.empty().toJson());
      }

      ///Update account
      batch.update(accountRef, {'Currencies.${paidCurrency.text.trim()}': FieldValue.increment(-num.parse(amount.text.trim()))});

      ///Create payment transaction
      batch.set(paymentRef, newPayment.toJson());

      ///update cash / bank balance
      batch.update(
          cashRef,
          paymentType.text.trim() == 'Bank transfer'
              ? {"bankBalances.${paidCurrency.text.trim()}": FieldValue.increment(-num.parse(amount.text.trim()))}
              : {"cashBalances.${paidCurrency.text.trim()}": FieldValue.increment(-num.parse(amount.text.trim()))});

      ///update payments total
      batch.update(dailyReportRef, {"payments.${paidCurrency.text.trim()}": FieldValue.increment(num.parse(amount.text.trim()))});

      ///Update payment counter
      batch.update(counterRef, {"transactionCounters.paymentsCounter": FieldValue.increment(1)});

      await batch.commit().then((_) {
        isLoading.value = false;

        Get.snackbar(
          icon: Icon(
            Icons.cloud_done,
            color: Colors.white,
          ),
          shouldIconPulse: true,
          "Success",
          'payment created successfully',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        if (context.mounted) {
          Navigator.of(context).pop();
          showPaymentInfo(
              context: context,
              transactionCode: 'PAY-${counters['paymentsCounter'].toString()}',
              payee: from.text.trim(),
              paidCurrency: paidCurrency.text.trim(),
              payeeAccountNo: accountNo.text.trim(),
              receiver: Obx(() => Text(
                    paidToOwner.value ? from.text.trim() : receiver.text.trim(),
                    style: TextStyle(
                      fontSize: 13,
                    ),
                  )),
              paymentType: paymentType.text.trim(),
              description: description.text.trim(),
              date: DateTime.now(),
              totalPayment: amount.text.trim());
        }
        clearController();
      });
    } on FirebaseAuthException catch (e) {
      throw TFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on FormatException {
      throw const TFormatException();
    } on TPlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      isLoading.value = false;

      throw 'Something went wrong. Please try again';
    }
  }

  /// *-----------------------------End data submission----------------------------------*
}
