import 'dart:async';
import 'dart:io';

import 'package:ciyebooks/features/pay/screens/widgets/confirm_payment.dart';
import 'package:ciyebooks/features/pay/screens/widgets/payment_success_screen.dart';
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
import '../models/pay_client_model.dart';

class PayClientController extends GetxController {
  static PayClientController get instance => Get.find();
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

  RxList<AccountModel> accounts = <AccountModel>[].obs;
  final currency = [].obs;
  final paidToOwner = true.obs;
  final payClientFormKey = GlobalKey<FormState>();
  final transactionCounter = 0.obs;

  ///Controllers
  final from = TextEditingController();
  final paymentType = TextEditingController();
  final amount = TextEditingController();
  final paidCurrency = TextEditingController();
  final receiver = TextEditingController();
  final accountNo = TextEditingController();
  final description = TextEditingController();

  @override
  onInit() {
    ///Add listeners to the controllers
    from.addListener(updateButtonStatus);
    accountNo.addListener(updateButtonStatus);
    amount.addListener(updateButtonStatus);
    paidCurrency.addListener(updateButtonStatus);

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

  ///Dispose off controllers
  disposeControllers() {
    from.dispose();
    paidCurrency.dispose();
    receiver.dispose();
    amount.dispose();
    description.dispose();
  }

  void updateButtonStatus() {
    isButtonEnabled.value = from.text.isNotEmpty && accountNo.text.isNotEmpty && amount.text.isNotEmpty && paidCurrency.text.isNotEmpty && (num.parse(amount.text) > 0);
  }

  /// *-----------------------------Start data submission---------------------------------*
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

  /// *-----------------------------Create and share pdf receipt----------------------------------*

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
      showConfirmPayment(context);
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
    // Navigator.of(context).pop();

    showConfirmPayment(context);
  }
/// Check internet connection
  checkInternetConnection(BuildContext context) async {
    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        if (context.mounted) {
          checkBalances(context);
        }
      }
    } on SocketException catch (_) {
      if (context.mounted) {
        showErrorDialog(context: context, errorTitle: 'Connection error!', errorText: 'Please check your network connection and try again.');
      }
      return;
    }
  }
  Future createPayment(BuildContext context) async {

    try {
      ///Compare cash and amount to be paid
      cashBalance.value = double.tryParse('${cashBalances[paidCurrency.text.trim()]}') ?? 0.0;
      paidAmount.value = double.tryParse(amount.text.trim()) ?? 0.0;

      if (paidAmount.value > cashBalance.value) {
        Get.snackbar(
          icon: Icon(
            Icons.cloud_done,
            color: Colors.white,
          ),
          shouldIconPulse: true,
          "Payment failed",
          'Amount to be paid cannot be more than cash in hand',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }
      if (paidAmount == cashBalance) {
        Get.snackbar(
          icon: Icon(
            Icons.cloud_done,
            color: Colors.white,
          ),
          shouldIconPulse: true,
          "Zero cash warning",
          'If you make this payment, you will have to cash left',
          backgroundColor: Colors.orangeAccent,
          colorText: Colors.white,
        );
        // return;
      }

      /// Initialize batch
      final db = FirebaseFirestore.instance;
      final batch = db.batch();

      ///Doc references
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
      batch.update(cashRef, {"payments.${paidCurrency.text.trim()}": FieldValue.increment(num.parse(amount.text.trim()))});

      ///Update payment counter
      batch.update(counterRef, {"transactionCounters.paymentsCounter": FieldValue.increment(1)});

      await batch.commit().then((_) {

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
        if(context.mounted){
          Navigator.of(context).pop();
          showPaymentSuccessPopup(context);
        }

        // SharePlus.instance.share(ShareParams(
        //     text:
        //         'PAY-${counters['paymentsCounter']} Confirmed. ${paymentType.text.trim()} of${ paidCurrency.text.trim()}:${formatter.format(double.parse(amount.text.trim()))} on ${DateFormat('dd MMM yyy HH:mm').format(DateTime.now())} to ${receiver.text.trim()}. If you have not authorised this action, please contact your account operator immediately.'));
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
      throw 'Something went wrong. Please try again';
    }
  }

  /// *-----------------------------End data submission----------------------------------*
}
