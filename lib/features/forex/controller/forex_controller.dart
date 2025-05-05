import 'dart:async';
import 'dart:io';

import 'package:ciyebooks/common/widgets/error_dialog.dart';
import 'package:ciyebooks/features/forex/model/forex_model.dart';
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
  double profit = 0;
  final selectedTransaction = 'buyFx'.obs;
  final counters = {}.obs;
  final selectedField = ''.obs;
  final currencyList ={}.obs;

  RxList<CurrencyModel> currencyStock = <CurrencyModel>[].obs;
  final isButtonEnabled = false.obs;
  Rx<BalancesModel> totals = BalancesModel.empty().obs;

  ///Sort by date for the history screen

  final transactionCounter = 0.obs;

  ///Controllers
  // TextEditingController currency = TextEditingController();
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

  /// New currency controllers
  final newCurrencyName = TextEditingController();
  final newCurrencyCode = TextEditingController();
  final newCurrencySymbol = TextEditingController();

  final _db = FirebaseFirestore.instance;

  final _uid = FirebaseAuth.instance.currentUser?.uid;

  @override
  onInit() async {
    fetchTotals();

    ///Add listeners to the controllers
    sellingRate.addListener(updateButtonStatus);
    sellingAmount.addListener(updateButtonStatus);
    sellingTotal.addListener(updateButtonStatus);

    ///Get the totals and balances

    super.onInit();
  }
/// Get all currencies ,
  fetchCurrencies() async {
    FirebaseFirestore.instance.collection('Common').doc('Currencies').snapshots().listen((snapshot) {
      if (snapshot.exists&&snapshot.data()!.isNotEmpty) {
        currencyList.value = snapshot.data() as Map<String, dynamic>;

      }
    });

  }
  addNewCurrency(BuildContext context) async {
    try {
      // Check if currency is base currency
      // if (currencyCode.text.trim() == baseCurrency.value) {
      //   Get.snackbar(
      //     "Can't add base currency!",
      //     'Please select a new currency and try again',
      //     backgroundColor: Colors.orange,
      //     colorText: Colors.white,
      //   );
      //   return;
      // }

      // Check if currency is selected
      if (currencyCode.text.isEmpty) {
        Get.snackbar(
          'No currency selected!',
          'Please select a new currency and try again',
          backgroundColor: Colors.orange,
          colorText: Colors.white,
        );
        return;
      }

      // Create new currency
      final newCurrency = CurrencyModel(currencyName: newCurrencyName.text.trim(), amount: 0, totalCost: 0, symbol: newCurrencySymbol.text.trim(), currencyCode: newCurrencyCode.text.trim());

      await _db.collection('Users').doc(FirebaseAuth.instance.currentUser?.uid).collection('Currency stock').doc(currencyCode.text.trim().toUpperCase()).set(newCurrency.toJson()).then((_) {

      });
    } catch (e) {
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

  updateButtonStatus() {
    isButtonEnabled.value = sellingRate.text.isNotEmpty &&
        sellingAmount.text.isNotEmpty &&
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
        counters.value = totals.value.transactionCounters;
        transactionCounter.value = counters[selectedTransaction.value];
      }
    });
  }

  checkInternetConnection(BuildContext context) async {
    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        if (context.mounted) {
          showConfirmForexTransaction(context);
        }
      }
    } on SocketException catch (_) {
      if (context.mounted) {
        showErrorDialog(context: context, errorTitle: 'Connection error!', errorText: 'Please check your network connection and try again.');
      }
    }
  }

  Future createForexTransaction(BuildContext context) async {
    try {

      /// If it is a sale calculate the profit
      if (selectedTransaction.value == 'sellFx') {
        profit = ForexProfitCalculator.calculateTotalProfit(
            sellingAmount: double.parse(sellingAmount.text.trim()),
            sellingRate: double.parse(sellingRate.text.trim()),
            sellingTotal: double.parse(sellingTotal.text.trim()),
            currencyStockTotalCost: double.parse(currencyStockTotalCost.text.trim()),
            currencyStockAmount: double.parse(currencyStockAmount.text.trim()));
      }

      /// Initialize batch
      final db = FirebaseFirestore.instance;
      final batch = db.batch();

      ///Doc references
      final counterRef = db.collection('Users').doc(_uid).collection('Setup').doc('Balances');
      final currencyRef = db.collection('Users').doc(_uid).collection('Currency stock').doc(currencyCode.text.trim().toUpperCase());
      final cashRef = db.collection('Users').doc(_uid).collection('Setup').doc('Balances');
      final transactionRef = db.collection('Users').doc(_uid).collection('transactions').doc('${selectedTransaction.value}-${counters[selectedTransaction.value]}');

      final newForexTransaction = ForexModel(
        forexType: selectedTransaction.value,
        transactionType: 'forex',
        type: type.text.trim(),
        transactionId: '${selectedTransaction.value.toUpperCase()}-${counters[selectedTransaction.value]}',
        amount: double.tryParse(sellingAmount.text.trim().replaceAll(',', '')) ?? 0.0,
        dateCreated: DateTime.now(),
        // currencyName: currency.text.trim(),
        currencyCode: currencyCode.text.trim(),
        rate: double.tryParse(sellingRate.text.trim()) ?? 0.0,
        totalCost: double.tryParse(sellingTotal.text.trim().replaceAll(',', '')) ?? 0.0,
        revenueContributed: double.parse(profit.toStringAsFixed(3)),
      );

      ///Create payment transaction
      batch.set(transactionRef, newForexTransaction.toJson());

      ///update cash and currency balances when buying currencies
      if (selectedTransaction.value == 'buyFx') {
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

      if (selectedTransaction.value == 'sellFx') {
        /// Update currency amount
        batch.update(currencyRef, {"amount": FieldValue.increment(-double.parse(sellingAmount.text.trim().replaceAll(',', '')))});

        ///Update total cost
        batch.update(currencyRef, {"totalCost": FieldValue.increment(-double.parse(sellingTotal.text.trim().replaceAll(',', '')))});

        batch.update(
            cashRef,
            type.text.trim() == 'Bank transfer'
                ? {"bankBalances.KES": FieldValue.increment(num.parse(sellingTotal.text.trim().replaceAll(',', '')))}
                : {"cashBalances.KES": FieldValue.increment(num.parse(sellingTotal.text.trim().replaceAll(',', '')))});
      }

      ///Update forex counter
      batch.update(counterRef, {"transactionCounters.${selectedTransaction.value}": FieldValue.increment(1)});

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
    } on TPlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }

  /// *-----------------------------End data submission----------------------------------*
}
