import 'dart:async';
import 'dart:io';

import 'package:ciyebooks/features/bank/deposit/model/deposit_model.dart';
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
import 'package:iconsax/iconsax.dart';
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
import '../../setup/models/setup_model.dart';
import '../ui/forex_form.dart';

class ForexController extends GetxController {
  static ForexController get instance => Get.find();
  final NumberFormat formatter = NumberFormat.decimalPatternDigits(
    locale: 'en_us',
    decimalDigits: 2,
  );
  final selectedTransaction = 'Buy'.obs;
  final counters = {}.obs;
  final selectedField = ''.obs;
  Rx<BalancesModel> totals = BalancesModel.empty().obs;
  final enableOverlayButton = true.obs;

  final isButtonEnabled = false.obs;
  final isLoading = false.obs;
  final selectedTransactionType = ''.obs;
  final bankBalances = {}.obs;
  final cashBalances = {}.obs;

  ///Sort by date for the history screen
  final sortCriteria = 'dateCreated'.obs;
  // sortExpenses(){
  //
  // }

  // final currency = [].obs;
  // final withCashFormKey = GlobalKey<FormState>();
  final transactionCounter = 0.obs;

  ///Controllers
  TextEditingController currency = TextEditingController();
  TextEditingController transactionType = TextEditingController();
  TextEditingController rate = TextEditingController();
  TextEditingController amount = TextEditingController();
  TextEditingController total = TextEditingController();

  ///

  final _uid = FirebaseAuth.instance.currentUser?.uid;

  /// *-----------------------------Start keypad--------------------------------------------*

  void addCharacter(buttonValue) {
    final target = selectedField.value == 'rate' ? rate :selectedField.value=='total'?total: amount;


    ///Limit the number of decimals
    if (buttonValue == '.' && target.text.contains('.')) {
      return;
    }

    ///Limit the number of decimal places

    if (target.text.contains('.')) {
      if (target.text.split('.')[1].length < 2) {
        target.text += buttonValue;
      }
      return;
    }

    if (target.text.length >= 12) {
      return;
    }

    ///Add other values
    target.text += buttonValue;
  }

  ///Remove characters
  void removeCharacter() {    final target = selectedField.value == 'rate' ? rate :selectedField.value=='total'?total: amount;


    if (target.text.isNotEmpty) {
      target.text = target.text.substring(0, target.text.length - 1);
    }
  }

  /// *-----------------------------End keypad--------------------------------------------*

  @override
  onInit() {


    fetchTotals();

    ///Add listeners to the controllers
    rate.addListener(updateButtonStatus);
    amount.addListener(updateButtonStatus);
    total.addListener(updateButtonStatus);

    ///Get the totals and balances
    fetchTotals();

    super.onInit();
  }
  // void _updateFromTotal() {
  //   // if (_isManualUpdate) return; // prevent loops
  //   // _isManualUpdate = true;
  //
  //
  //   // _isManualUpdate = false;
  // }
  /// *-----------------------------Add new expense category----------------------------------*

  /// *-----------------------------Enable or disable the continue button----------------------------------*

  updateButtonStatus() {
    isButtonEnabled.value =
        rate.text.isNotEmpty && amount.text.isNotEmpty && total.text.isNotEmpty && (num.parse(rate.text) > 0 && (num.parse(amount.text) > 0 && (num.parse(total.text.replaceAll(',', '')) > 0)));
    double rateVal = double.tryParse(rate.text) ?? 0;
    double amountVal = double.tryParse(amount.text) ?? 0;
    double totalVal = double.tryParse(total.text) ?? 0;


    // if (selectedField.value == 'amount' && rateVal > 0) {

      total.text = formatter.format(amountVal *rateVal);
    // }
    // if (selectedField.value == 'total' && rateVal > 0) {
    //
    //   amount.text = (totalVal / rateVal).toStringAsFixed(2);
    // }
     }

  /// *-----------------------------Start data submission---------------------------------*
  fetchTotals() async {
    DocumentSnapshot balances = await FirebaseFirestore.instance.collection('Users').doc(_uid).collection('Setup').doc('Balances').get();
    DocumentSnapshot expenses = await FirebaseFirestore.instance.collection('Users').doc(_uid).collection('expenses').doc('expense categories').get();

    if (balances.exists && balances.data() != null) {
      totals.value = BalancesModel.fromJson(balances.data() as Map<String, dynamic>);
      cashBalances.value = totals.value.cashBalances;
      counters.value = totals.value.transactionCounters;
      bankBalances.value = totals.value.bankBalances;
      transactionCounter.value = counters['bankWithdrawCounter'];
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
                                    pw.Text('category.text.trim()', style: pw.TextStyle(color: PdfColors.black, fontWeight: pw.FontWeight.bold, font: ttf)),
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
                                    pw.Text('depositedCurrency.text', style: pw.TextStyle(color: PdfColors.black, fontWeight: pw.FontWeight.bold, font: ttf)),
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
                                    pw.Text('description.text', style: pw.TextStyle(font: ttf, color: PdfColors.black, fontWeight: pw.FontWeight.bold)),
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
                        Text('category.text.trim()', style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w600)),
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
                        Text('depositedCurrency.text' '.trim()', style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w600)),
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
                        Text('description.text.trim()', style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w600)),
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
      /// Initialize batch
      final db = FirebaseFirestore.instance;
      final batch = db.batch();

      ///Doc references
      final depositRef = db.collection('Users').doc(_uid).collection('transactions').doc('DPST-${counters['bankDepositCounter']}');
      final counterRef = db.collection('Users').doc(_uid).collection('Setup').doc('Balances');
      final cashRef = db.collection('Users').doc(_uid).collection('Setup').doc('Balances');

      final newDeposit = DepositModel(
        depositedBy: rate.text.trim(),
        transactionType: 'deposit',
        transactionId: 'DPST-${counters['bankDepositCounter']}',
        currency: amount.text.trim(),
        amount: double.tryParse(amount.text.trim()) ?? 0.0,
        dateCreated: DateTime.now(),
        description: rate.text.trim(),
      );

      ///Create payment transaction
      batch.set(depositRef, newDeposit.toJson());

      ///update cash balance
      batch.update(cashRef, {"cashBalances.${rate.text.trim()}": FieldValue.increment(-num.parse(amount.text.trim()))});

      ///update expense total
      batch.update(cashRef, {"deposits.${rate.text.trim()}": FieldValue.increment(num.parse(amount.text.trim()))});

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
