import 'dart:async';
import 'dart:io';

import 'package:ciyebooks/features/pay/pay_client/pay_client_model/pay_client_model.dart';
import 'package:ciyebooks/features/pay/pay_expense/screens/expense_history.dart';
import 'package:ciyebooks/features/pay/pay_expense/screens/pay_expense_form.dart';
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

import '../../../../navigation_menu.dart';
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

  /// Compare dates to display the divider conditionally
  bool isSameDate(DateTime date1, DateTime date2) {
    return date1.year == date2.year && date1.month == date2.month && date1.day == date2.day;
  }

  /// *-----------------------------Start keypad--------------------------------------------*

  void addCharacter(buttonValue) {
    ///Limit the number of decimals
    if (buttonValue == '.' && amount.text.contains('.')) {
      return;
    }

    ///Limit the number of decimal places
    if (amount.text.contains('.')) {
      if (amount.text.split('.')[1].length < 2) {
        amount.text += buttonValue;
      }
      return;
    }

    if (amount.text.length >= 12) {
      return;
    }

    ///Add other values
    amount.text += buttonValue;
  }

  ///Remove characters
  void removeCharacter() {
    if (amount.text.isNotEmpty) {
      amount.text = amount.text.substring(0, amount.text.length - 1);
    }
  }

  /// *-----------------------------End keypad--------------------------------------------*

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
    DocumentSnapshot balances = await FirebaseFirestore.instance.collection('Users').doc(_uid).collection('Setup').doc('Balances').get();
    DocumentSnapshot expenses = await FirebaseFirestore.instance.collection('Users').doc(_uid).collection('expenses').doc('expense categories').get();

    if (expenses.exists && expenses.data() != null) {
      expenseCategories.value = expenses.data() as Map<String, dynamic>;

      ///Add the last entry of the map to enable users to add a new category
      expenseCategories['AddNew'] = 'AddNew';
    }
    if (balances.exists && balances.data() != null) {
      totals.value = BalancesModel.fromJson(balances.data() as Map<String, dynamic>);
      cashBalances.value = totals.value.cashBalances;
      counters.value = totals.value.transactionCounters;
      // payments.value = totals.value.payments;
      transactionCounter.value = counters['paymentsCounter'];
    }
  }

  /// *-----------------------------Create and share pdf receipt----------------------------------*

  createPdf() async {
    try {
      /// Create the receipt.
      final font = await rootBundle.load("assets/fonts/Poppins-Regular.ttf");
      final ttf = pw.Font.ttf(font);
      final pdf = pw.Document();
      final ByteData image = await rootBundle.load('assets/images/icons/checkMark.png');

      Uint8List imageData = (image).buffer.asUint8List();

      pdf.addPage(
        pw.Page(
            build: (pw.Context context) => pw.Column(
                  children: [
                    pw.Container(
                      decoration: pw.BoxDecoration(
                          border: pw.Border.all(
                            width: 1,
                            color: PdfColors.black,
                          ),
                          borderRadius: pw.BorderRadius.circular(12)),
                      child: pw.Column(
                        mainAxisSize: pw.MainAxisSize.min,
                        mainAxisAlignment: pw.MainAxisAlignment.center,
                        children: [
                          pw.Container(
                            decoration: pw.BoxDecoration(borderRadius: pw.BorderRadius.only(topLeft: pw.Radius.circular(12), topRight: pw.Radius.circular(12)), color: PdfColors.blue),
                            width: double.maxFinite,
                            height: 70,
                            child: pw.Row(
                              mainAxisAlignment: pw.MainAxisAlignment.center,
                              children: [
                                pw.Image(height: 60, pw.MemoryImage(imageData)),
                                pw.SizedBox(width: 20),
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
                                    pw.Text('exp-${counters['expenseCounter']}', style: pw.TextStyle(color: PdfColors.black, fontWeight: pw.FontWeight.bold, font: ttf)),
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
                                        "Expense category",
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
                                        "Currency",
                                      ),
                                    ),
                                    pw.Text(paidCurrency.text, style: pw.TextStyle(color: PdfColors.black, fontWeight: pw.FontWeight.bold, font: ttf)),
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
                                    pw.Text(double.parse(amount.text.trim()).toStringAsFixed(2), style: pw.TextStyle(font: ttf, color: PdfColors.black, fontWeight: pw.FontWeight.bold)),
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
                                        "Description",
                                      ),
                                    ),
                                    pw.Text(description.text, style: pw.TextStyle(font: ttf, color: PdfColors.black, fontWeight: pw.FontWeight.bold)),
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
                      ),
                    ),
                  ],
                )),
      );

      ///Share or download the receipt
      final directory = await getApplicationDocumentsDirectory();
      final path = directory.path;
      final file = File('$path/EXP-${counters['expenseCounter']}.pdf');
      await file.writeAsBytes(await pdf.save());
      if (await file.exists()) {
        Share.shareXFiles([XFile(file.path)], text: "Here is your PDF receipt!");
      } else {}
    } catch (e) {
      Get.snackbar(
        icon: Icon(
          Icons.cloud_done,
          color: Colors.white,
        ),
        shouldIconPulse: true,
        "There was an error",
        e.toString(),
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    }
  }

  /// *-----------------------------Show receipt preview----------------------------------*

  showReceiptDialog(BuildContext context) {
    final NumberFormat formatter = NumberFormat.decimalPatternDigits(
      locale: 'en_us',
      decimalDigits: 2,
    );

    showDialog(
      context: context,
      builder: (context) {
        Future.delayed(Duration(seconds: 5), () {
          if (context.mounted) {
            Navigator.of(context).pop();
          } // Close the dialog
        });
        return AlertDialog(
          titlePadding: EdgeInsets.zero,
          insetPadding: EdgeInsets.all(8),
          backgroundColor: AppColors.quinary,
          contentPadding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(borderRadius: BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12)), color: CupertinoColors.systemBlue),
                width: double.maxFinite,
                height: 60,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.task_alt_outlined,
                      size: 40,
                      color: AppColors.quinary,
                    ),
                    Gap(15),
                    Text(
                      'Expense receipt',
                      style: TextStyle(color: AppColors.quinary, fontSize: 24),
                    ),
                  ],
                ),
              ),
              Gap(10),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text("Transaction type", style: TextStyle()),
                        ),
                        Text('Expense', style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w600)),
                      ],
                    ),
                    Gap(5),
                    Divider(thickness: 1, color: Colors.grey[300]),
                    Row(
                      children: [
                        Expanded(
                          child: Text("Transaction id", style: TextStyle()),
                        ),
                        Text('exp-${counters['expenseCounter']}', style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w600)),
                      ],
                    ),
                    Gap(5),
                    Divider(thickness: 1, color: Colors.grey[300]),
                    Row(
                      children: [
                        Expanded(
                          child: Text("Category", style: TextStyle()),
                        ),
                        Text(category.text.trim(), style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w600)),
                      ],
                    ),
                    Gap(5),
                    Divider(thickness: 1, color: Colors.grey[300]),
                    Gap(5),
                    Row(
                      children: [
                        Expanded(
                          child: Text("Currency", style: TextStyle()),
                        ),
                        Text(paidCurrency.text.trim(), style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w600)),
                      ],
                    ),
                    Gap(5),
                    Divider(thickness: 1, color: Colors.grey[300]),
                    Gap(5),
                    Row(
                      children: [
                        Expanded(
                          child: Text("Amount", style: TextStyle()),
                        ),
                        Text(formatter.format(double.parse(amount.text)), style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w600)),
                      ],
                    ),
                    Gap(5),
                    Divider(thickness: 1, color: Colors.grey[300]),
                    Gap(5),
                    Row(
                      children: [
                        Expanded(
                          child: Text("Description", style: TextStyle()),
                        ),
                        Text(description.text.trim(), style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w600)),
                      ],
                    ),
                    Gap(5),
                    Divider(thickness: 1, color: Colors.grey[300]),
                    Gap(5),
                    Row(
                      children: [
                        Expanded(
                          child: Text("Date & Time", style: TextStyle(fontWeight: FontWeight.normal)),
                        ),
                        Text(DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now()), style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w600)),
                      ],
                    ),
                    Gap(10),
                  ],
                ),
              ),
              Divider(
                height: 0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton.outlined(
                            onPressed: () => createPdf(),
                            icon: Icon(
                              Icons.share,
                              color: CupertinoColors.systemBlue,
                            )

                            // backgroundColor: AppColors.prettyDark,
                            // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100),
                            // ),
                            ),
                        Text(
                          'Share',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  /// *-----------------------------Create the payment----------------------------------*

  Future createPayment(BuildContext context) async {
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
      if (context.mounted) {
        Navigator.of(context).pop();
        createPdf();
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => const ExpenseHistory()),
        );
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
