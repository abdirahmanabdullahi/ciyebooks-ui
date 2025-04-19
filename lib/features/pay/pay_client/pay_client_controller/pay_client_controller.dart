import 'dart:async';
import 'dart:io';

import 'package:ciyebooks/features/bank/withdraw/screens/deposits.dart';
import 'package:ciyebooks/features/pay/pay_client/pay_client_model/pay_client_model.dart';
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

import '../../../../common/widgets/error_dialog.dart';
import '../../../../navigation_menu.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/exceptions/firebase_auth_exceptions.dart';
import '../../../../utils/exceptions/firebase_exceptions.dart';
import '../../../../utils/exceptions/format_exceptions.dart';
import '../../../../utils/exceptions/platform_exceptions.dart';
import '../../../accounts/model/model.dart';
import '../../../setup/models/setup_model.dart';
import '../../screens/payment_home.dart';

class PayClientController extends GetxController {
  static PayClientController get instance => Get.find();
  final _uid = FirebaseAuth.instance.currentUser?.uid;

  final counters = {}.obs;
  Rx<BalancesModel> totals = BalancesModel.empty().obs;
  final cashBalances = {}.obs;
  final bankBalances = {}.obs;
  final payments = {}.obs;
  final cashBalance = 0.0.obs;
  final paidAmount = 0.0.obs;
  final isButtonEnabled = false.obs;
  final isLoading = false.obs;

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
    print('[[[[[[[[[[[[[[[[[[[[[[[[[width]]]]]]]]]]]]]]]]]]]]]]]]]');


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
        print(bankBalances);


        if (cashBalances.containsKey('KES')) {
        } else {
          print('Nobe');
        }
        counters.value = totals.value.transactionCounters;
        transactionCounter.value = counters['paymentsCounter'];
      }
    });
  }

  /// *-----------------------------Create and share pdf receipt----------------------------------*

  createPdf() async {
    try {
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
              decoration: pw.BoxDecoration(border: pw.Border.all(color: PdfColors.black), borderRadius: pw.BorderRadius.all(pw.Radius.circular(12))),
              child: pw.Column(
                mainAxisSize: pw.MainAxisSize.min,
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
                          'Payment receipt',
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
                            pw.Text('Payment', style: pw.TextStyle(font: ttf, color: PdfColors.black, fontWeight: pw.FontWeight.bold)),
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
                            pw.Text('PAY-${counters['paymentsCounter']}', style: pw.TextStyle(color: PdfColors.black, fontWeight: pw.FontWeight.bold, font: ttf)),
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
                                "From",
                              ),
                            ),
                            pw.Text(from.text.trim(), style: pw.TextStyle(color: PdfColors.black, fontWeight: pw.FontWeight.bold, font: ttf)),
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
                                "Receiver",
                              ),
                            ),
                            pw.Text(paidToOwner.value ? from.text.trim() : receiver.text.trim(), style: pw.TextStyle(color: PdfColors.black, fontWeight: pw.FontWeight.bold, font: ttf)),
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
                            pw.Text(double.parse(description.text.trim()).toStringAsFixed(2), style: pw.TextStyle(font: ttf, color: PdfColors.black, fontWeight: pw.FontWeight.bold)),
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

  Future createPayment(
    BuildContext context,
  ) async {
    isLoading.value = true;

    /// Check if currency is at bank and amount is enough to pay amount requested
    if (paymentType.text.trim() == 'Bank transfer') {
      final currencyKey = paidCurrency.text.trim();

      if (!bankBalances.containsKey(currencyKey)) {
        showErrorDialog(context, 'You do not have $currencyKey at bank. Please check your balances and try again.');
        return;
      }

      final availableAmount = double.parse('${bankBalances[currencyKey]}')  ;
      final requestedAmount = double.parse(amount.text.trim()) ;

      if (requestedAmount > availableAmount) {
        showErrorDialog(
          context,
          'You only have $currencyKey ${formatter.format(availableAmount)} at bank and cannot pay ${formatter.format(requestedAmount)}. Please check your balances and try again.',
        );
        return;
      }

    }

    /// Check if currency is in cash and amount is enough to pay amount requested
    if (paymentType.text.trim() != 'Bank transfer') {
      final currencyKey = paidCurrency.text.trim();

      if (!cashBalances.containsKey(currencyKey)) {
        showErrorDialog(context, 'You do not have $currencyKey in cash. Please check your balances and try again.');
        return;
      }

      final availableAmount = double.parse('${cashBalances[currencyKey]}')  ;
      final requestedAmount = double.parse(amount.text.trim()) ;

      if (requestedAmount > availableAmount) {
        showErrorDialog(
          context,
          'You only have $currencyKey ${formatter.format(availableAmount)} in cash and cannot pay ${formatter.format(requestedAmount)}. Please check your balances and try again.',
        );
        return;
      }

    }

    try {
      ///Compare cash and amount to be paid
      cashBalance.value = double.tryParse('${cashBalances[paidCurrency.text.trim()]}') ?? 0.0;
      paidAmount.value = double.tryParse(amount.text.trim()) ?? 0.0;

      // if (paidAmount.value > cashBalance.value) {
      //   Get.snackbar(
      //     icon: Icon(
      //       Icons.cloud_done,
      //       color: Colors.white,
      //     ),
      //     shouldIconPulse: true,
      //     "Payment failed",
      //     'Amount to be paid cannot be more than cash in hand',
      //     backgroundColor: Colors.red,
      //     colorText: Colors.white,
      //   );
      //   return;
      // }
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
        // disposeControllers();
        createPdf();

        isLoading.value = false;
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
