import 'dart:async';
import 'dart:io';

import 'package:ciyebooks/common/widgets/error_dialog.dart';
import 'package:ciyebooks/features/forex/model/forex_model.dart';
import 'package:ciyebooks/features/forex/ui/widgets/fx_transaction_success.dart';
import 'package:ciyebooks/features/stats/models/stats_model.dart';
import 'package:ciyebooks/utils/helpers/forex_profit_calculator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../utils/exceptions/firebase_auth_exceptions.dart';
import '../../../../utils/exceptions/firebase_exceptions.dart';
import '../../../../utils/exceptions/platform_exceptions.dart';
import '../../setup/models/setup_model.dart';
import '../model/new_currency_model.dart';
import '../ui/widgets/confirm_fx_transaction.dart';
import '../ui/widgets/forex_form.dart';

class ForexController extends GetxController {
  static ForexController get instance => Get.find();
  final NumberFormat formatter = NumberFormat.decimalPatternDigits(
    locale: 'en_us',
    decimalDigits: 2,
  );
  final String today = DateFormat("dd MMM yyyy ").format(DateTime.now());
  final dailyReportCreated = false.obs;

  double profit = 0;
  double cost = 0;
  final selectedTransaction = 'BUYFX'.obs;
  final counters = {}.obs;
  final selectedField = ''.obs;
  final currencyList = {}.obs;

  RxList<CurrencyModel> currencyStock = <CurrencyModel>[].obs;
  final isButtonEnabled = false.obs;
  final isLoading = false.obs;
  Rx<BalancesModel> totals = BalancesModel.empty().obs;

  ///Sort by date for the history screen

  final transactionCounter = 0.obs;

  ///Controllers
  TextEditingController forexType = TextEditingController();
  TextEditingController type = TextEditingController();
  TextEditingController currencyCode = TextEditingController();
  TextEditingController transactionType = TextEditingController();
  TextEditingController sellingRate = TextEditingController();
  TextEditingController sellingAmount = TextEditingController();
  TextEditingController sellingTotal = TextEditingController();
  TextEditingController description = TextEditingController();
  TextEditingController currencyStockTotalCost = TextEditingController();
  TextEditingController currencyStockAmount = TextEditingController();

  /// Clear controllers after data submission
  clearController() {
    forexType.clear();
    type.clear();
    currencyCode.clear();
    transactionType.clear();
    sellingRate.clear();
    sellingAmount.clear();
    sellingTotal.clear();
    description.clear();
    currencyStockTotalCost.clear();
    currencyStockAmount.clear();
  }

  /// New currency controllers
  final newCurrencyName = TextEditingController();
  final newCurrencyCode = TextEditingController();
  final newCurrencySymbol = TextEditingController();
  final bankBalances = {}.obs;
  final cashBalances = {}.obs;

  final _db = FirebaseFirestore.instance;

  final _uid = FirebaseAuth.instance.currentUser?.uid;

  @override
  onInit() async {
    fetchTotals();
    fetchCurrencies();

    ///Add listeners to the controllers
    sellingRate.addListener(updateButtonStatus);
    type.addListener(updateButtonStatus);
    sellingAmount.addListener(updateButtonStatus);
    sellingTotal.addListener(updateButtonStatus);

    ///Get the totals and balances

    super.onInit();
  }

  /// Get all currencies ,
  fetchCurrencies() async {
    FirebaseFirestore.instance.collection('Common').doc('Currencies').snapshots().listen((snapshot) {
      if (snapshot.exists && snapshot.data()!.isNotEmpty) {
        currencyList.value = snapshot.data() as Map<String, dynamic>;
      }
    });
  }

  updateNewCurrencyButton() {
    isButtonEnabled.value = newCurrencyCode.text.isNotEmpty;
  }

  addNewCurrency(BuildContext context) async {
    isLoading.value=true;
    try {
      // Create new currency
      final newCurrency = CurrencyModel(currencyName: newCurrencyName.text.trim(), amount: 0, totalCost: 0, symbol: newCurrencySymbol.text.trim(), currencyCode: newCurrencyCode.text.trim());

      await _db.collection('Users').doc(FirebaseAuth.instance.currentUser?.uid).collection('Currency stock').doc(newCurrencyCode.text.trim().toUpperCase()).set(newCurrency.toJson()).then((_) {
        if (context.mounted) {
          Navigator.of(context).pop();
        }
        isLoading.value=false;
      });
    } catch (e) {
      isLoading.value=false;
      throw e.toString();
    }
  }

  ///Calculate the fields
  onAmountChanged(String? value) {
    sellingTotal.text = formatter.format(((double.tryParse(sellingAmount.text.trim().replaceAll(',', ',').removeAllWhitespace) ?? 0.0) * (double.tryParse(sellingRate.text.trim()) ?? 0.0)));
  }

  onTotalChanged(String? value) {
    if ((double.tryParse(sellingRate.text.trim().replaceAll(',', '').removeAllWhitespace) ?? 0.0) <= 0) {
      return;
    }

    sellingAmount.text = formatter.format(((double.tryParse(sellingTotal.text.trim()) ?? 0.0) / (double.tryParse(sellingRate.text.trim()) ?? 0.0)));
  }

  /// Update whether the submit button is enabled or disabled
  updateButtonStatus() {
    isButtonEnabled.value = sellingRate.text.isNotEmpty &&
        sellingAmount.text.isNotEmpty &&
        type.text.isNotEmpty &&
        sellingTotal.text.isNotEmpty &&
        ((num.tryParse(sellingRate.text) ?? 0) > 0 && (num.tryParse(sellingAmount.text) ?? 0) > 0 && (num.tryParse(sellingTotal.text.replaceAll(',', '')) ?? 0) > 0);
  }

  fetchTotals() async {
    FirebaseFirestore.instance.collection('Users').doc(_uid).collection('Currency stock').snapshots().listen((querySnapshot) {
      currencyStock.value = querySnapshot.docs.map((doc) {
        return CurrencyModel.fromJson(doc.data());
      }).toList();
    });

    FirebaseFirestore.instance.collection('Users').doc(_uid).collection('Setup').doc('Balances').snapshots().listen((snapshot) {
      if (snapshot.exists) {
        totals.value = BalancesModel.fromJson(snapshot.data()!);
        bankBalances.value = totals.value.bankBalances;
        cashBalances.value = totals.value.cashBalances;
        counters.value = totals.value.transactionCounters;
        transactionCounter.value = counters[selectedTransaction.value];
      }
    });
  }

  ///Check if you have enough base currency to buy a foreign currency
  checkBalances(BuildContext context) {
    final availableForeignCurrencyBalance = double.parse(currencyStockAmount.text.trim());
    final availableBankAmount = double.parse(bankBalances['KES'].toString());
    final availableCashAmount = double.parse(cashBalances['KES'].toString());
    final requestedAmount = double.parse(sellingAmount.text.trim().replaceAll(',', ''));

    /// Limit the user so as not to sell what they do not have.
    if (selectedTransaction.value == 'SELLFX' && availableForeignCurrencyBalance < requestedAmount) {
      showErrorDialog(
        context: context,
        errorTitle: 'Insufficient funds',
        errorText: 'You do not have enough ${currencyCode.text.trim()} to complete this transaction.',
      );
      return;
    }

    if (selectedTransaction.value == 'BUYFX') {
      if (type.text.trim() == 'Cash' && requestedAmount > availableCashAmount) {
        showErrorDialog(
          context: context,
          errorTitle: 'Cash not enough',
          errorText: 'You only have KES ${formatter.format(availableCashAmount)} in cash. Please check your balances and try again.',
        );
        return;
      }
      if (type.text.trim() != 'Cash' && requestedAmount > availableBankAmount) {
        showErrorDialog(
          context: context,
          errorTitle: 'Balance at bank not enough',
          errorText: 'You only have KES ${formatter.format(availableCashAmount)} at bank. Please check your balances and try again.',
        );
        return;
      }
    }

    showConfirmForexTransaction(context);
  }

  checkInternetConnection(BuildContext context) async {
    isLoading.value=true;
    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        if (context.mounted) {
          createForexTransaction(context);
        }
      }
    } on SocketException catch (_) {
      if (context.mounted) {
        showErrorDialog(context: context, errorTitle: 'Connection error!', errorText: 'Please check your network connection and try again.');
      }
    }
  }

  createDailyReport() async {
    final reportRef = FirebaseFirestore.instance.collection('Users').doc(_uid).collection('DailyReports').doc(today);
    final snapshot = await reportRef.get();
    if (snapshot.exists) {
      dailyReportCreated.value = true;
    }
  }

  Future createForexTransaction(BuildContext context) async {
    isLoading.value=true;
    try {
      await createDailyReport();
      /// If it is a sale calculate the profit
      if (selectedTransaction.value == 'SELLFX') {
        profit = ForexProfitCalculator.calculateTotalProfit(
            sellingAmount: sellingAmount.text.trim(),
            sellingRate: sellingRate.text.trim(),
            sellingTotal: sellingTotal.text.trim(),
            currencyStockTotalCost: currencyStockTotalCost.text.trim(),
            currencyStockAmount: currencyStockAmount.text.trim());
      }
      cost = ForexProfitCalculator.cost(sellingAmount: sellingAmount.text.trim(), currencyStockTotalCost: currencyStockTotalCost.text.trim(), currencyStockAmount: currencyStockAmount.text.trim());

      /// Initialize batch
      final db = FirebaseFirestore.instance;
      final batch = db.batch();

      ///Doc references
      final counterRef = db.collection('Users').doc(_uid).collection('Setup').doc('Balances');
      final currencyRef = db.collection('Users').doc(_uid).collection('Currency stock').doc(currencyCode.text.trim().toUpperCase());
      final cashRef = db.collection('Users').doc(_uid).collection('Setup').doc('Balances');
      final transactionRef = db.collection('Users').doc(_uid).collection('transactions').doc('${selectedTransaction.value}-${counters[selectedTransaction.value]}');
      final dailyReportRef = db.collection('Users').doc(_uid).collection('DailyReports').doc(today);

      final newForexTransaction = ForexModel(
        forexType: selectedTransaction.value,
        transactionType: 'forex',
        type: type.text.trim(),
        transactionId: '${selectedTransaction.value.toUpperCase()}-${counters[selectedTransaction.value]}',
        amount: double.tryParse(sellingAmount.text.trim().replaceAll(',', '')) ?? 0.0,
        dateCreated: DateTime.now(),
        // currencyName: currency.text.trim(),
        currencyCode: currencyCode.text.trim(),
        rate: double.tryParse(sellingRate.text.trim().replaceAll(',', '')) ?? 0.0,
        totalCost: double.tryParse(sellingTotal.text.trim().replaceAll(',', '')) ?? 0.0,
        revenueContributed: double.parse(profit.toStringAsFixed(3)),
      );

      ///Create Daily report
      if (!dailyReportCreated.value) {
        batch.set(dailyReportRef, DailyReportModel.empty().toJson());
      }

      ///Create payment transaction
      batch.set(transactionRef, newForexTransaction.toJson());

      ///update cash and currency balances when buying currencies
      if (selectedTransaction.value == 'BUYFX') {
        /// Update currencies at cost
        batch.update(cashRef, {'currenciesAtCost': FieldValue.increment(-double.parse(sellingTotal.text.trim().replaceAll(',', '')))});

        /// Update currency amount
        batch.update(currencyRef, {"amount": FieldValue.increment(double.parse(sellingAmount.text.trim().replaceAll(',', '')))});

        ///Update total cost
        batch.update(currencyRef, {"totalCost": FieldValue.increment(double.parse(sellingTotal.text.trim().replaceAll(',', '')))});

        batch.update(
            cashRef,
            type.text.trim() == 'Bank transfer'
                ? {"bankBalances.KES": FieldValue.increment(-num.parse(sellingTotal.text.trim().replaceAll(',', '')))}
                : {"cashBalances.KES": FieldValue.increment(-num.parse(sellingTotal.text.trim().replaceAll(',', '')))});
      }

      ///update cash balance when selling currencies

      if (selectedTransaction.value == 'SELLFX') {
        /// Update currencies at cost
        batch.update(cashRef, {'currenciesAtCost': FieldValue.increment(double.parse(sellingTotal.text.trim().replaceAll(',', '')))});

        /// Update profit
        batch.update(dailyReportRef, {'dailyProfit': FieldValue.increment(profit)});

        /// Update currency amount
        batch.update(currencyRef, {"amount": FieldValue.increment(-double.parse(sellingAmount.text.trim().replaceAll(',', '')))});

        ///Update total cost
        batch.update(currencyRef, {"totalCost": FieldValue.increment(-cost)});

        batch.update(
            cashRef,
            type.text.trim() == 'Bank transfer'
                ? {"bankBalances.KES": FieldValue.increment(num.parse(sellingTotal.text.trim().replaceAll(',', '')))}
                : {"cashBalances.KES": FieldValue.increment(num.parse(sellingTotal.text.trim().replaceAll(',', '')))});
      }

      ///Update forex counter
      batch.update(counterRef, {"transactionCounters.${selectedTransaction.value}": FieldValue.increment(1)});

      await batch.commit().then((_) {
        isLoading.value=false;
        Get.snackbar(
          icon: Icon(
            Icons.cloud_done,
            color: Colors.white,
          ),
          shouldIconPulse: true,
          "Success",
          'Transaction created successfully',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

        /// Show success dialog
        if (context.mounted) {
          Navigator.of(context).pop();
          showForexInfo(
              context: context,
              forexType: selectedTransaction.value,
              currency: currencyCode.text.trim(),
              transactionCode: '${selectedTransaction.value.toUpperCase()}-${counters[selectedTransaction.value]}',
              method: type.text.trim(),
              amount: sellingAmount.text.trim(),
              rate: sellingRate.text.trim(),
              totalCost: sellingTotal.text.trim(),
              date: DateTime.now());
        }
        clearController();
      });
    } on FirebaseAuthException catch (e) {
      throw TFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on TPlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
isLoading.value=false;      throw 'Something went wrong. Please try again';
    }
  }

  /// *-----------------------------End data submission----------------------------------*
}
