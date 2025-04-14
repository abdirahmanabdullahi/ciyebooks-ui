import 'dart:async';
import 'dart:io';

import 'package:ciyebooks/features/pay/widgets/expenses.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:share_plus/share_plus.dart';

import '../../../../utils/constants/colors.dart';
import '../../../../utils/exceptions/firebase_auth_exceptions.dart';
import '../../../../utils/exceptions/firebase_exceptions.dart';
import '../../../../utils/exceptions/format_exceptions.dart';
import '../../../../utils/exceptions/platform_exceptions.dart';
import '../../../accounts/model/model.dart';
import '../../../setup/models/setup_model.dart';
import '../expense_model/expense_model.dart';

class PayExpenseController extends GetxController {
  static PayExpenseController get instance => Get.find();

  final counters = {}.obs;
  Rx<BalancesModel> totals = BalancesModel.empty().obs;
  final cashBalances = {}.obs;
  final expenseCategories = {}.obs;
  // final payments = {}.obs;
  final cashBalance = 0.0.obs;
  final paidAmount = 0.0.obs;
  final isButtonEnabled = false.obs;
  final isLoading = false.obs;

  ///Sort by date
  final sortCriteria = 'DateCreated'.obs;
  // sortExpenses(){
  //
  // }

  RxList<AccountModel> accounts = <AccountModel>[].obs;
  final currency = [].obs;
  final payExpenseFormKey = GlobalKey<FormState>();
  final transactionCounter = 0.obs;

  ///Controllers
  final category = TextEditingController();
  final amount = TextEditingController();
  final paidCurrency = TextEditingController();
  final description = TextEditingController();

  ///

  final _uid = FirebaseAuth.instance.currentUser?.uid;

  @override
  onInit() {
    fetchTotals();

    ///Add listeners to the controllers
    category.addListener(updateButtonStatus);
    amount.addListener(updateButtonStatus);
    paidCurrency.addListener(updateButtonStatus);

    ///Get the totals and balances
    fetchTotals();

    super.onInit();
  }

  /// *-----------------------------Add new expense category----------------------------------*
  addNewExpenseCategory() {
    try {
      final uid = FirebaseAuth.instance.currentUser?.uid;

      ///Initialize Firestore
      final db = FirebaseFirestore.instance;
      final docReference = db.collection('Users').doc(uid).collection('expenses').doc('expense categories');

      docReference.set({
        category.text.trim(): category.text.trim(),
      }, SetOptions(merge: true));
      Get.back();
    } on FirebaseAuthException catch (e) {
      throw TFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatException();
    } on TPlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw e.toString();
    }
  }

  /// *-----------------------------Enable or disable the continue button----------------------------------*

  updateButtonStatus() {
    isButtonEnabled.value = category.text.isNotEmpty && amount.text.isNotEmpty && paidCurrency.text.isNotEmpty && (num.parse(amount.text) > 0);
  }

  /// *-----------------------------Start data submission---------------------------------*
  fetchTotals() async {
    FirebaseFirestore.instance.collection('Users').doc(_uid).collection('Setup').doc('Balances').snapshots().listen((snapshot) {
      if (snapshot.exists) {
        totals.value = BalancesModel.fromJson(snapshot.data()!);
        cashBalances.value = totals.value.cashBalances;
        counters.value = totals.value.transactionCounters;
        transactionCounter.value = counters['paymentsCounter'];      }
    });

    DocumentSnapshot expenses = await FirebaseFirestore.instance.collection('Users').doc(_uid).collection('expenses').doc('expense categories').get();

    if (expenses.exists && expenses.data() != null) {
      expenseCategories.value = expenses.data() as Map<String, dynamic>;

      ///Add the last entry of the map to enable users to add a new category
      expenseCategories['AddNew'] = 'AddNew';
    }
    // if (balances.exists && balances.data() != null) {
    //   totals.value = BalancesModel.fromJson(balances.data() as Map<String, dynamic>);
    //   cashBalances.value = totals.value.cashBalances;
    //   counters.value = totals.value.transactionCounters;
    //   // payments.value = totals.value.payments;
    //   transactionCounter.value = counters['paymentsCounter'];
    // }
  }

  /// *-----------------------------Create and share pdf receipt----------------------------------*

  Future<void> createPdf() async {
    // try {
      /// Create the receipt.
      final font = await rootBundle.load("assets/fonts/Poppins-Regular.ttf");
      final ttf = pw.Font.ttf(font);
      final pdf = pw.Document();


      pdf.addPage(pw.Page(
          margin: pw.EdgeInsets.fromLTRB(
            10,
            30,
            10,
            20,
          ),
          build: (pw.Context context) => pw.Container(
              decoration: pw.BoxDecoration(border: pw.Border.all(color: PdfColors.black),
                  borderRadius: pw.BorderRadius.all(
                      pw.Radius.circular(12))),
              child: pw.Column(mainAxisSize: pw.MainAxisSize.min,
                mainAxisAlignment: pw.MainAxisAlignment.start,
                children: [
                  pw.Container(
                    decoration: pw.BoxDecoration(
                        borderRadius: pw.BorderRadius.only(
                          topLeft: pw.Radius.circular(12),
                          topRight: pw.Radius.circular(12),
                        ),
                        color: PdfColors.blue),
                    width: double.maxFinite,
                    height: 70,
                    child: pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.center,
                      children: [
                        pw.Text(
                          'Expense receipt',
                          style: pw.TextStyle(color: PdfColors.white, fontSize: 24, font: ttf),
                        ),
                      ],
                    ),
                  ),
                  // Gap(10),
                  pw.Padding(
                    padding: pw.EdgeInsets.all(8.0),
                    child: pw.Column(
                      children: [
                        pw.SizedBox(
                          height: 10,
                        ),
                        pw.Row(
                          children: [
                            pw.Expanded(
                              child: pw.Text(
                                style: pw.TextStyle(font: ttf),
                                "Transaction type",
                              ),
                            ),
                            pw.Text('Expense', style: pw.TextStyle(font: ttf, color: PdfColors.black, fontWeight: pw.FontWeight.bold)),
                          ],
                        ),
                        pw.SizedBox(
                          height: 10,
                        ),
                        pw.Divider(thickness: 1, color: PdfColors.grey),
                        pw.SizedBox(
                          height: 10,
                        ),
                        pw.Row(
                          children: [
                            pw.Expanded(
                              child: pw.Text(
                                style: pw.TextStyle(font: ttf),
                                "Transaction id",
                              ),
                            ),
                            pw.Text('EXP-${counters['expenseCounter']}', style: pw.TextStyle(color: PdfColors.black, fontWeight: pw.FontWeight.bold, font: ttf)),
                          ],
                        ),
                        pw.SizedBox(
                          height: 10,
                        ),
                        pw.Divider(thickness: 1, color: PdfColors.grey),
                        pw.SizedBox(
                          height: 10,
                        ),
                        pw.Row(
                          children: [
                            pw.Expanded(
                              child: pw.Text(
                                style: pw.TextStyle(font: ttf),
                                "Category",
                              ),
                            ),
                            pw.Text(category.text.trim(), style: pw.TextStyle(color: PdfColors.black, fontWeight: pw.FontWeight.bold, font: ttf)),
                          ],
                        ),
                        pw.SizedBox(
                          height: 10,
                        ),
                        pw.Divider(thickness: 1, color: PdfColors.grey),
                        pw.SizedBox(
                          height: 10,
                        ),
                        pw.Row(
                          children: [
                            pw.Expanded(
                              child: pw.Text(
                                style: pw.TextStyle(font: ttf),
                                "Currency paid",
                              ),
                            ),
                            pw.Text(amount.text.trim(), style: pw.TextStyle(color: PdfColors.black, fontWeight: pw.FontWeight.bold, font: ttf)),
                          ],
                        ),
                        pw.SizedBox(
                          height: 10,
                        ),
                        pw.Divider(thickness: 1, color: PdfColors.grey),
                        pw.SizedBox(
                          height: 10,
                        ),
                        pw.Row(
                          children: [
                            pw.Expanded(
                              child: pw.Text(
                                style: pw.TextStyle(font: ttf),
                                "Amount",
                              ),
                            ),
                            pw.Text(paidCurrency.text.trim(), style: pw.TextStyle(color: PdfColors.black, fontWeight: pw.FontWeight.bold, font: ttf)),
                          ],
                        ),
                        pw.SizedBox(
                          height: 10,
                        ),
                        pw.Divider(thickness: 1, color: PdfColors.grey),
                        pw.SizedBox(
                          height: 10,
                        ),
                        pw.Row(
                          children: [
                            pw.Expanded(
                              child: pw.Text(maxLines: 1,
                                overflow: pw.TextOverflow.clip,
                                style: pw.TextStyle(
                                    font: ttf),
                                "Description",
                              ),
                            ),
                            pw.Text(description.text.trim(),overflow: pw.TextOverflow.clip, style: pw.TextStyle(font: ttf, color: PdfColors.black, fontWeight: pw.FontWeight.bold)),
                          ],
                        ),
                        pw.SizedBox(
                          height: 10,
                        ),
                        pw.Divider(thickness: 1, color: PdfColors.grey),
                        pw.SizedBox(
                          height: 10,
                        ),
                        pw.Row(
                          children: [
                            pw.Expanded(
                              child: pw.Text("Date & Time", style: pw.TextStyle(font: ttf, fontWeight: pw.FontWeight.normal)),
                            ),
                            pw.Text(
                              DateFormat('dd MMM yyy HH:mm').format(DateTime.now()),
                              style: pw.TextStyle(font: ttf, color: PdfColors.black, fontWeight: pw.FontWeight.bold),
                            ),
                          ],
                        ),
                        pw.SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  ),
                ],
              ))));

      ///Share or download the receipt
      final directory = await getTemporaryDirectory();
      final path = directory.path;
      final file = File('$path/PAY-${counters['paymentsCounter']}.pdf');
      await file.writeAsBytes(await pdf.save());
      if (await file.exists()) {
        await Share.shareXFiles([XFile(file.path)], text: "Here is your PDF receipt!");

      }
    // } catch (e) {

     // print(e.toString());
    // }
  }

///Dispose Controllers
  clearControllers(){
    category.clear();
    paidCurrency.clear();
    amount.clear();
    description.clear();
  }
  Future createExpense(BuildContext context) async {
    isLoading.value = true;

    try {
      ///Compare cash and amount to be paid
      cashBalance.value = double.tryParse(cashBalances[paidCurrency.text.trim()].toString()) ?? 0.0;
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
        isLoading.value = false;

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
          'If you make this payment, you will have no cash left',
          backgroundColor: Colors.orangeAccent,
          colorText: Colors.white,
        );
        // return;
      }

      /// Initialize batch
      final db = FirebaseFirestore.instance;
      final batch = db.batch();

      ///Doc references
      final expenseRef = db.collection('Users').doc(_uid).collection('transactions').doc('exp-${counters['expenseCounter']}');
      final counterRef = db.collection('Users').doc(_uid).collection('Setup').doc('Balances');
      final cashRef = db.collection('Users').doc(_uid).collection('Setup').doc('Balances');

      final newExpense = ExpenseModel(
          transactionId: 'exp-${counters['expenseCounter']}',
          category: category.text.trim(),
          description: description.text.trim(),
          dateCreated: DateTime.now(),
          currency: paidCurrency.text.trim(),
          amountPaid: double.tryParse(amount.text.trim()) ?? 0.0,
          transactionType: 'expense');

      ///Create payment transaction
      batch.set(expenseRef, newExpense.toJson());

      ///update cash balance
      batch.update(cashRef, {"cashBalances.${paidCurrency.text.trim()}": FieldValue.increment(-num.parse(amount.text.trim()))});

      ///update expense total
      batch.update(cashRef, {"expense.${paidCurrency.text.trim()}": FieldValue.increment(num.parse(amount.text.trim()))});

      ///Update expense counter
      batch.update(counterRef, {"transactionCounters.expenseCounter": FieldValue.increment(1)});

      await batch.commit().then((_) {
        Get.snackbar(
          icon: Icon(
            Icons.cloud_done,
            color: Colors.white,
          ),
          shouldIconPulse: true,
          "Success",
          'expense created successfully',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      });
      isLoading.value = false;
      createPdf();
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
      print(e.toString());

      throw 'Something went wrong. Please try again';
    }
  }

  /// *-----------------------------End data submission----------------------------------*
}
