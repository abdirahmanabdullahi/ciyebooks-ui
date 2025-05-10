import 'dart:async';
import 'dart:io';

import 'package:ciyebooks/features/pay/screens/expense/confirm_expense.dart';
import 'package:ciyebooks/features/stats/models/stats_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../common/widgets/error_dialog.dart';
import '../../../utils/exceptions/firebase_auth_exceptions.dart';
import '../../../utils/exceptions/firebase_exceptions.dart';
import '../../../utils/exceptions/format_exceptions.dart';
import '../../../utils/exceptions/platform_exceptions.dart';
import '../../accounts/model/model.dart';
import '../../setup/models/setup_model.dart';
import '../models/expense_model.dart';
import '../screens/expense/expense_success_screen.dart';

class PayExpenseController extends GetxController {
  static PayExpenseController get instance => Get.find();
  final String today = DateFormat("dd MMM yyyy ").format(DateTime.now());

  final NumberFormat formatter = NumberFormat.decimalPatternDigits(
    locale: 'en_us',
    decimalDigits: 2,
  );
  final counters = {}.obs;
  Rx<BalancesModel> totals = BalancesModel.empty().obs;
  final cashBalances = {}.obs;
  final bankBalances = {}.obs;
  final expenseCategories = {}.obs;
  final cashBalance = 0.0.obs;
  final paidAmount = 0.0.obs;
  final isButtonEnabled = false.obs;
  final newCategoryButtonEnabled = false.obs;
  final dailyReportCreated = false.obs;


  ///Sort by date
  final sortCriteria = 'dateCreated'.obs;
  // sortExpenses(){
  //
  // }

  RxList<AccountModel> accounts = <AccountModel>[].obs;
  final currency = [].obs;
  final payExpenseFormKey = GlobalKey<FormState>();
  final transactionCounter = 0.obs;
  final paymentType = ''.obs;

  ///Controllers
  final category = TextEditingController();
  final paymentTypeController = TextEditingController();
  final amount = TextEditingController();
  final paidCurrency = TextEditingController();
  final description = TextEditingController();

  /// Clear controllers after data submission
  clearControllers(){
    category.clear();
    paymentTypeController.clear();
    amount.clear();
    paidCurrency.clear();
    description.clear();
  }

  final _uid = FirebaseAuth.instance.currentUser?.uid;

  @override
  onInit() {
    ///Add listeners to the controllers
    category.addListener(updateExpenseSubmitButtonStatus);
    category.addListener(updateNewCategoryButton);
    amount.addListener(updateExpenseSubmitButtonStatus);
    paidCurrency.addListener(updateExpenseSubmitButtonStatus);
    paymentTypeController.addListener(updateExpenseSubmitButtonStatus);

    ///Get the totals and balances
    fetchTotals();
    /// Check and create daily report
    createDailyReport();

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
      Get.snackbar(
        icon: Icon(
          Icons.cloud_done,
          color: Colors.white,
        ),
        shouldIconPulse: true,
        "Success",
        'New category added',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
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
/// Enable/disable the client submit button if the pay client form dialog
  updateExpenseSubmitButtonStatus() {
    isButtonEnabled.value = category.text.isNotEmpty &&paymentTypeController.text.isNotEmpty&& amount.text.isNotEmpty && paidCurrency.text.isNotEmpty && (num.parse(amount.text) > 0);
  }
/// Update the new category submit button in the new expense category dialog
  updateNewCategoryButton() {
    newCategoryButtonEnabled.value =category.text.isNotEmpty;}

  /// *-----------------------------Start data submission---------------------------------*
  fetchTotals() async {
    FirebaseFirestore.instance.collection('Users').doc(_uid).collection('Setup').doc('Balances').snapshots().listen((snapshot) {
      if (snapshot.exists) {
        totals.value = BalancesModel.fromJson(snapshot.data()!);
        cashBalances.value = totals.value.cashBalances;
        bankBalances.value = totals.value.bankBalances;
        counters.value = totals.value.transactionCounters;
        transactionCounter.value = counters['expenseCounter'];
      }
    });

    FirebaseFirestore.instance.collection('Users').doc(_uid).collection('expenses').doc('expense categories').snapshots().listen((snapshot) {
      if (snapshot.exists) {
        expenseCategories.value = snapshot.data() as Map<String, dynamic>;
      }
    });
    // if (balances.exists && balances.data() != null) {
    //   totals.value = BalancesModel.fromJson(balances.data() as Map<String, dynamic>);
    //   cashBalances.value = totals.value.cashBalances;
    //   counters.value = totals.value.transactionCounters;
    //   // payments.value = totals.value.payments;
    //   transactionCounter.value = counters['paymentsCounter'];
    // }
  }

  /// *-----------------------------Create and share pdf receipt----------------------------------*

  ///Dispose Controllers
  // createReceiptPdf() async {
  //   try {
  //     /// Create the receipt.
  //     final font = await rootBundle.load("assets/fonts/Poppins-Regular.ttf");
  //     final ttf = pw.Font.ttf(font);
  //     final pdf = pw.Document();
  //
  //     pdf.addPage(pw.Page(
  //         margin: pw.EdgeInsets.fromLTRB(
  //           10,
  //           30,
  //           10,
  //           20,
  //         ),
  //         build: (pw.Context context) => pw.Container(
  //             decoration: pw.BoxDecoration(border: pw.Border.all(color: PdfColors.black), borderRadius: pw.BorderRadius.all(pw.Radius.circular(12))),
  //             child: pw.Column(
  //               mainAxisSize: pw.MainAxisSize.min,
  //               mainAxisAlignment: pw.MainAxisAlignment.start,
  //               children: [
  //                 pw.Container(
  //                   decoration: pw.BoxDecoration(
  //                     borderRadius: pw.BorderRadius.only(
  //                       topLeft: pw.Radius.circular(12),
  //                       topRight: pw.Radius.circular(12),
  //                     ),
  //                   ),
  //                   width: double.maxFinite,
  //                   height: 70,
  //                   child: pw.Row(
  //                     mainAxisAlignment: pw.MainAxisAlignment.center,
  //                     children: [
  //                       pw.Text(
  //                         'Expense receipt',
  //                         style: pw.TextStyle(color: PdfColors.black, fontSize: 26, font: ttf),
  //                       ),
  //                     ],
  //                   ),
  //                 ),
  //                 pw.Divider(
  //                   thickness: 1,
  //                   color: PdfColors.black,
  //                 ),
  //                 pw.Padding(
  //                   padding: pw.EdgeInsets.all(8.0),
  //                   child: pw.Column(
  //                     children: [
  //                       pw.SizedBox(
  //                         height: 10,
  //                       ),
  //                       pw.Row(
  //                         children: [
  //                           pw.Expanded(
  //                             child: pw.Text(
  //                               style: pw.TextStyle(fontSize: AppSizes.receiptFontSize, font: ttf),
  //                               "Transaction type",
  //                             ),
  //                           ),
  //                           pw.Text('Expense', style: pw.TextStyle(font: ttf, color: PdfColors.black, fontSize: AppSizes.receiptFontSize)),
  //                         ],
  //                       ),
  //                       pw.SizedBox(
  //                         height: 10,
  //                       ),
  //                       pw.Divider(
  //                         thickness: 0.11,
  //                         color: PdfColors.black,
  //                       ),
  //                       pw.SizedBox(
  //                         height: 10,
  //                       ),
  //                       pw.Row(
  //                         children: [
  //                           pw.Expanded(
  //                             child: pw.Text(
  //                               style: pw.TextStyle(fontSize: AppSizes.receiptFontSize, font: ttf),
  //                               "Transaction id",
  //                             ),
  //                           ),
  //                           pw.Text('EXP-${counters['expenseCounter'] - 1}', style: pw.TextStyle(fontSize: AppSizes.receiptFontSize, color: PdfColors.black, font: ttf)),
  //                         ],
  //                       ),
  //                       pw.SizedBox(
  //                         height: 10,
  //                       ),
  //                       pw.Divider(
  //                         thickness: 0.11,
  //                         color: PdfColors.black,
  //                       ),
  //                       pw.SizedBox(
  //                         height: 10,
  //                       ),
  //                       pw.Row(
  //                         children: [
  //                           pw.Expanded(
  //                             child: pw.Text(
  //                               style: pw.TextStyle(fontSize: AppSizes.receiptFontSize, font: ttf),
  //                               "Category",
  //                             ),
  //                           ),
  //                           pw.Text(category.text.trim(), style: pw.TextStyle(color: PdfColors.black, fontSize: AppSizes.receiptFontSize, font: ttf)),
  //                         ],
  //                       ),
  //                       pw.SizedBox(
  //                         height: 10,
  //                       ),
  //                       pw.Divider(
  //                         thickness: 0.11,
  //                         color: PdfColors.black,
  //                       ),
  //
  //
  //                       pw.SizedBox(
  //                         height: 10,
  //                       ),
  //                       pw.Row(
  //                         children: [
  //                           pw.Expanded(
  //                             child: pw.Text(
  //                               style: pw.TextStyle(font: ttf, fontSize: AppSizes.receiptFontSize),
  //                               "Currency paid",
  //                             ),
  //                           ),
  //                           pw.Text(paidCurrency.text.trim(), style: pw.TextStyle(color: PdfColors.black, fontSize: AppSizes.receiptFontSize, font: ttf)),
  //                         ],
  //                       ),
  //                       pw.SizedBox(
  //                         height: 10,
  //                       ),
  //                       pw.Divider(
  //                         thickness: 0.11,
  //                         color: PdfColors.black,
  //                       ),
  //                       pw.SizedBox(
  //                         height: 10,
  //                       ),
  //                       pw.Row(
  //                         children: [
  //                           pw.Expanded(
  //                             child: pw.Text(
  //                               style: pw.TextStyle(fontSize: AppSizes.receiptFontSize, font: ttf),
  //                               "Amount",
  //                             ),
  //                           ),
  //                           pw.Text(formatter.format(double.parse(amount.text.trim())),
  //                               style: pw.TextStyle(
  //                                 fontSize: AppSizes.receiptFontSize,
  //                                 font: ttf,
  //                                 color: PdfColors.black,
  //                               )),
  //                         ],
  //                       ),
  //                       pw.SizedBox(
  //                         height: 10,
  //                       ),
  //                       pw.Divider(
  //                         thickness: 0.11,
  //                         color: PdfColors.black,
  //                       ),
  //                       pw.SizedBox(
  //                         height: 10,
  //                       ),
  //                       pw.Row(
  //                         children: [
  //                           pw.Expanded(
  //                             child: pw.Text(
  //                               style: pw.TextStyle(fontSize: AppSizes.receiptFontSize, font: ttf),
  //                               "Description",
  //                             ),
  //                           ),
  //                           pw.Text(description.text.trim(),
  //                               style: pw.TextStyle(
  //                                 font: ttf,
  //                                 fontSize: AppSizes.receiptFontSize,
  //                                 color: PdfColors.black,
  //                               )),
  //                         ],
  //                       ),
  //                       pw.SizedBox(
  //                         height: 10,
  //                       ),
  //                       pw.Divider(
  //                         thickness: 0.11,
  //                         color: PdfColors.black,
  //                       ),
  //                       pw.SizedBox(
  //                         height: 10,
  //                       ),
  //                       pw.Row(
  //                         children: [
  //                           pw.Expanded(
  //                             child: pw.Text("Date & Time", style: pw.TextStyle(font: ttf, fontSize: AppSizes.receiptFontSize)),
  //                           ),
  //                           pw.Text(
  //                             DateFormat('dd MMM yyy HH:mm').format(DateTime.now()),
  //                             style: pw.TextStyle(font: ttf, color: PdfColors.black, fontSize: AppSizes.receiptFontSize),
  //                           ),
  //                         ],
  //                       ),
  //                       pw.SizedBox(
  //                         height: 10,
  //                       ),
  //                     ],
  //                   ),
  //                 ),
  //               ],
  //             ))));
  //
  //     ///Share or download the receipt
  //     final directory = await getTemporaryDirectory();
  //     final path = directory.path;
  //     final file = File('$path/PAY-${counters['paymentsCounter']}.pdf');
  //     await file.writeAsBytes(await pdf.save());
  //     if (await file.exists()) {
  //       await Share.shareXFiles([XFile(file.path)], text: "Here is your PDF receipt!");
  //     } else {}
  //   } catch (e) {
  //     Get.snackbar(
  //       icon: Icon(
  //         Icons.cloud_done,
  //         color: Colors.white,
  //       ),
  //       shouldIconPulse: true,
  //       "There was an error",
  //       e.toString(),
  //       backgroundColor: Colors.green,
  //       colorText: Colors.white,
  //     );
  //   }
  // }
  ///Check internet connection
  checkInternetConnection(BuildContext context) async {
    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        if (context.mounted) {
          createExpense(context);
        }
      }
    } on SocketException catch (_) {
      if (context.mounted) {
        showErrorDialog(context: context, errorTitle: 'Connection error!', errorText: 'Please check your network connection and try again.');
      }
      return;
    }
  }

  checkBalances(BuildContext context) {
    if (paymentType.value == 'Bank') {
      final currencyKey = paidCurrency.text.trim();

      final availableAmount = double.parse('${bankBalances[currencyKey]}');
      final requestedAmount = double.parse(amount.text.trim());

      if (requestedAmount > availableAmount) {
        showErrorDialog(
          context: context,
          errorTitle: 'Balance at bank not enough',
          errorText: 'You only have $currencyKey ${formatter.format(availableAmount)} at bank and cannot pay ${formatter.format(requestedAmount)}. Please check your balances and try again.',
        );
        return;
      }
    }
    if (paymentType.value != 'Bank') {
      final currencyKey = paidCurrency.text.trim();

      final availableAmount = double.parse(cashBalances[currencyKey].toString());
      final requestedAmount = double.parse(amount.text.trim());

      if (requestedAmount > availableAmount) {
        showErrorDialog(
          context: context,
          errorTitle: 'Not enough cash in hand:',
          errorText: 'You only have $currencyKey ${formatter.format(availableAmount)} in cash and cannot pay ${formatter.format(requestedAmount)}. Please check your balances and try again.',
        );
        return;
      }
    }
    showConfirmExpenseDialog(context);
  }

  /// Check and create daily report if not Created

  createDailyReport() async {
    final reportRef = FirebaseFirestore.instance.collection('Users').doc(_uid).collection('DailyReports').doc(today);
    final snapshot = await reportRef.get();
    if (snapshot.exists) {
      dailyReportCreated.value = true;
    }
  }

  Future createExpense(BuildContext context) async {
    try {
      /// Initialize batch
      final db = FirebaseFirestore.instance;
      final batch = db.batch();

      ///Doc references
      final dailyReportRef = db.collection('Users').doc(_uid).collection('DailyReports').doc(today);

      final expenseRef = db.collection('Users').doc(_uid).collection('transactions').doc('EXP-${counters['expenseCounter']}');
      final counterRef = db.collection('Users').doc(_uid).collection('Setup').doc('Balances');
      final cashRef = db.collection('Users').doc(_uid).collection('Setup').doc('Balances');

      final newExpense = ExpenseModel(
          transactionId: 'EXP-${counters['expenseCounter']}',
          category: category.text.trim(),
          paymentType: paymentTypeController.text.trim(),
          description: description.text.trim(),
          dateCreated: DateTime.now(),
          currency: paidCurrency.text.trim(),
          amountPaid: double.tryParse(amount.text.trim()) ?? 0.0,
          transactionType: 'expense');

      /// Create daily report
      if(!dailyReportCreated.value){
        batch.set(dailyReportRef, DailyReportModel.empty().toJson());
      }

      ///Create payment transaction
      batch.set(expenseRef, newExpense.toJson());

      ///update cash balance
      batch.update(
          cashRef,
          paymentType.value == 'Bank'
              ? {"bankBalances.${paidCurrency.text.trim()}": FieldValue.increment(-num.parse(amount.text.trim()))}
              : {"cashBalances.${paidCurrency.text.trim()}": FieldValue.increment(-num.parse(amount.text.trim()))});

      ///update expense total
      batch.update(dailyReportRef, {"expenses.${paidCurrency.text.trim()}": FieldValue.increment(num.parse(amount.text.trim()))});

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
        if (context.mounted) {
          Navigator.of(context).pop();
          showExpenseInfo(context:context,
              transactionCode: 'EXP-${counters['expenseCounter'].toString()}',
              category:category.text.trim(), amountPaid: amount.text.trim(),
              description: description.text.trim(), 
              currency: paidCurrency.text.trim(), date: DateTime.now());

        }        clearControllers();


      });
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
