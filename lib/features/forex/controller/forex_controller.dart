import 'dart:async';
import 'dart:io';

import 'package:ciyebooks/features/bank/deposit/model/deposit_model.dart';
import 'package:ciyebooks/features/forex/model/forex_model.dart';
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
import '../../setup/models/setup_model.dart';
import '../model/new_currency_model.dart';

class ForexController extends GetxController {
  static ForexController get instance => Get.find();
  final NumberFormat formatter = NumberFormat.decimalPatternDigits(
    locale: 'en_us',
    decimalDigits: 2,
  );
  final selectedTransaction = 'buyFx'.obs;
  final counters = {}.obs;
  final selectedField = ''.obs;

  RxList<CurrencyModel> currencyStock = <CurrencyModel>[].obs;
  final isButtonEnabled = false.obs;
  final isLoading = false.obs;
  final bankBalances = {}.obs;
  final cashBalances = {}.obs;
  Rx<BalancesModel> totals = BalancesModel.empty().obs;


  ///Sort by date for the history screen
  final sortCriteria = 'dateCreated'.obs;

  final transactionCounter = 0.obs;

  ///Controllers
  TextEditingController currency = TextEditingController();
  TextEditingController transactionType = TextEditingController();
  TextEditingController rate = TextEditingController();
  TextEditingController amount = TextEditingController();
  TextEditingController total = TextEditingController();
  TextEditingController description = TextEditingController();

  ///

  final _uid = FirebaseAuth.instance.currentUser?.uid;

  @override
  onInit() async {
    fetchTotals();

    ///Add listeners to the controllers
    rate.addListener(updateButtonStatus);
    amount.addListener(updateButtonStatus);
    total.addListener(updateButtonStatus);

    ///Get the totals and balances
    fetchTotals();

    super.onInit();
  }

  ///Calculate the fields
  onAmountChanged(String? value) {
    total.text = formatter.format(((double.tryParse(amount.text.trim().replaceAll(',', ',').removeAllWhitespace) ?? 0.0) * (double.tryParse(rate.text.trim()) ?? 0.0)));
  }

  onTotalChanged(String? value) {
    if ((double.tryParse(rate.text.trim().replaceAll(',', '').removeAllWhitespace) ?? 0.0) <= 0) {
      return;
    }

    amount.text = formatter.format(((double.tryParse(total.text.trim()) ?? 0.0) / (double.tryParse(rate.text.trim()) ?? 0.0)));
  }

  updateButtonStatus() {
    isButtonEnabled.value = rate.text.isNotEmpty &&
        amount.text.isNotEmpty &&
        total.text.isNotEmpty &&
        ((num.tryParse(rate.text) ?? 0) > 0 && (num.tryParse(amount.text) ?? 0) > 0 && (num.tryParse(total.text.replaceAll(',', '')) ?? 0) > 0);
  }

  /// *-----------------------------Start data submission---------------------------------*
  fetchTotals() async {
    FirebaseFirestore.instance
        .collection('Users')
        .doc(_uid)
        .collection('Currency stock')
        // .where('transactionType', isEqualTo: 'payment')

        .snapshots()
        .listen((querySnapshot) {
      currencyStock.clear();
      currencyStock.value = querySnapshot.docs.map((doc) {
        return CurrencyModel.fromJson(doc.data());
      }).toList();
    });
  }


  ///Get currencies for the new currency popup form

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


  /// *-----------------------------Create the payment----------------------------------*

  Future createForexTransaction(BuildContext context) async {
    isLoading.value = true;

    try {
      /// Initialize batch
      final db = FirebaseFirestore.instance;
      final batch = db.batch();

      ///Doc references
      final depositRef = db.collection('Users').doc(_uid).collection('transactions').doc('selectedTransaction.value-${counters['bankDepositCounter']}');
      final counterRef = db.collection('Users').doc(_uid).collection('Setup').doc('Balances');
      final cashRef = db.collection('Users').doc(_uid).collection('Setup').doc('Balances');

      final newDeposit = ForexModel(
        transactionType: selectedTransaction.value,
        transactionId: 'selectedTransaction.value-${counters['bankDepositCounter']}',
        amount: double.tryParse(amount.text.trim()) ?? 0.0,
        dateCreated: DateTime.now(), currencyName: currency.text.trim(), currencyCode: '', rate: double.tryParse(rate.text.trim())??0.0, totalCost: double.tryParse(total.text.trim())??0.0,
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
