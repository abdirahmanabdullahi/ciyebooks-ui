import 'dart:async';
import 'dart:io';

import 'package:ciyebooks/features/pay/pay_client/pay_client_model/pay_client_model.dart';
import 'package:ciyebooks/features/transafers/bank_transfer/models/bank_transfer_model.dart';
import 'package:ciyebooks/features/transafers/internal_transfer/models/internal_transfer_model.dart';
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

class BankTransferController extends GetxController {
  static BankTransferController get instance => Get.find();

  final counters = {}.obs;
  Rx<BalancesModel> totals = BalancesModel.empty().obs;
  final isButtonEnabled = false.obs;
  final isLoading = false.obs;

  RxList<AccountModel> accounts = <AccountModel>[].obs;
  final currency = [].obs;
  final internalTransferFormKey = GlobalKey<FormState>();
  final transactionCounter = 0.obs;

  ///Controllers
  final transferredAmount = TextEditingController();
  final transferredCurrency = TextEditingController();
  final transferringAccountName = TextEditingController();
  final transferringAccountNo = TextEditingController();
  final receiverName = TextEditingController();
  final description = TextEditingController();

  ///Sort criteria
  final sortCriteria = 'DateCreated'.obs;

  final _uid = FirebaseAuth.instance.currentUser?.uid;

  /// *-----------------------------Start keypad--------------------------------------------*

  void addCharacter(buttonValue) {
    ///Limit the number of decimals
    if (buttonValue == '.' && transferredAmount.text.contains('.')) {
      return;
    }

    ///Limit the number of decimal places
    if (transferredAmount.text.contains('.')) {
      if (transferredAmount.text.split('.')[1].length < 2) {
        transferredAmount.text += buttonValue;
      }
      return;
    }

    if (transferredAmount.text.length >= 12) {
      return;
    }

    ///Add other values
    transferredAmount.text += buttonValue;
  }

  ///Remove characters
  void removeCharacter() {
    if (transferredAmount.text.isNotEmpty) {
      transferredAmount.text = transferredAmount.text.substring(0, transferredAmount.text.length - 1);
    }
  }

  /// *-----------------------------End keypad--------------------------------------------*

  @override
  onInit() {
    fetchTotals();

    ///Add listeners to the controllers
    transferringAccountName.addListener(updateButtonStatus);
    transferringAccountNo.addListener(updateButtonStatus);
    transferredAmount.addListener(updateButtonStatus);
    receiverName.addListener(updateButtonStatus);

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

  void updateButtonStatus() {
    isButtonEnabled.value =
        transferredCurrency.text.isNotEmpty && transferringAccountNo.text.isNotEmpty && receiverName.text.isNotEmpty && transferredAmount.text.isNotEmpty && (num.parse(transferredAmount.text) > 0);
  }

  /// *-----------------------------Start data submission---------------------------------*
  fetchTotals() async {
    DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance.collection('Users').doc(_uid).collection('Setup').doc('Balances').get();

    if (documentSnapshot.exists && documentSnapshot.data() != null) {
      totals.value = BalancesModel.fromJson(documentSnapshot.data() as Map<String, dynamic>);
      counters.value = totals.value.transactionCounters;
      transactionCounter.value = counters['bankTransferCounter'];
    }
  }

  /// *-----------------------------Create and share pdf receipt----------------------------------*

  Future<void> createPdf() async {
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
                                  'Bank transfer receipt',
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
                                    pw.Text('Internal transfer', style: pw.TextStyle(font: ttf, color: PdfColors.black, fontWeight: pw.FontWeight.bold)),
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
                                    pw.Text('BNKTRNSFR-${counters['internalTransferCounter']}', style: pw.TextStyle(color: PdfColors.black, fontWeight: pw.FontWeight.bold, font: ttf)),
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
                                    pw.Text(transferringAccountName.text.trim(), style: pw.TextStyle(color: PdfColors.black, fontWeight: pw.FontWeight.bold, font: ttf)),
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
                                    pw.Text(receiverName.text.trim(), style: pw.TextStyle(color: PdfColors.black, fontWeight: pw.FontWeight.bold, font: ttf)),
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
                                    pw.Text(transferredCurrency.text.trim(), style: pw.TextStyle(color: PdfColors.black, fontWeight: pw.FontWeight.bold, font: ttf)),
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
                                    pw.Text(double.parse(transferredAmount.text.trim()).toStringAsFixed(2), style: pw.TextStyle(font: ttf, color: PdfColors.black, fontWeight: pw.FontWeight.bold)),
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
      final file = File('$path/pymnt-${counters['paymentsCounter']}.pdf');
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

  void showReceiptDialog(BuildContext context) {
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
                      'Payment receipt',
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
                        Text('Payment', style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w600)),
                      ],
                    ),
                    Gap(5),
                    Divider(thickness: 1, color: Colors.grey[300]),
                    Row(
                      children: [
                        Expanded(
                          child: Text("Transaction id", style: TextStyle()),
                        ),
                        Text('INTRNSFR-${counters['internalTransferCounter']}', style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w600)),
                      ],
                    ),
                    Gap(5),
                    Divider(thickness: 1, color: Colors.grey[300]),
                    Row(
                      children: [
                        Expanded(
                          child: Text("From", style: TextStyle()),
                        ),
                        Text(transferringAccountName.text.trim(), style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w600)),
                      ],
                    ),
                    Gap(5),
                    Divider(thickness: 1, color: Colors.grey[300]),
                    Gap(5),
                    Row(
                      children: [
                        Expanded(
                          child: Text("Receiver", style: TextStyle()),
                        ),
                        Text(transferringAccountName.text.trim(), style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w600)),
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
                        Text(transferredCurrency.text.trim(), style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w600)),
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
                        Text(formatter.format(double.parse(transferredAmount.text)), style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w600)),
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

  Future createBankTransfer(BuildContext context) async {
    isLoading.value = true;

    try {
      //

      /// Initialize batch
      final db = FirebaseFirestore.instance;
      final batch = db.batch();

      ///Doc references
      final bankTransferRef = db.collection('Users').doc(_uid).collection('transactions').doc('BKTR-${counters['bankTransferCounter']}');
      final counterRef = db.collection('Users').doc(_uid).collection('Setup').doc('Balances');
      final cashRef = db.collection('Users').doc(_uid).collection('Setup').doc('Balances');
      final transferringAccountRef = db.collection('Users').doc(_uid).collection('accounts').doc('PA-${transferringAccountNo.text.trim()}');

      ///Get data from the controllers
      final newBankTransfer = BankTransferModel(
          transactionId: 'BKTR-${counters['bankTransferCounter']}',
          transactionType: 'bank transfer',
          currency: transferredCurrency.text.trim(),
          amount: double.tryParse(transferredAmount.text.trim()) ?? 0.0,
          dateCreated: DateTime.now(),
          description: description.text.trim(),
          transferringAccountNo: transferringAccountNo.text.trim(),
          transferringAccountName: transferringAccountName.text.trim(),
          receiverName: receiverName.text.trim());

      ///Update account
      batch.update(transferringAccountRef, {'Currencies.${transferredCurrency.text.trim()}': FieldValue.increment(-num.parse(transferredAmount.text.trim()))});

      ///Create payment transaction
      batch.set(bankTransferRef, newBankTransfer.toJson());

      ///update bank transfer total
      batch.update(cashRef, {"transfers.${transferredCurrency.text.trim()}": FieldValue.increment(num.parse(transferredAmount.text.trim()))});

      ///Update  counter
      batch.update(counterRef, {"transactionCounters.bankTransferCounter": FieldValue.increment(1)});

      await batch.commit().then((_) {
        Get.snackbar(
          icon: Icon(
            Icons.cloud_done,
            color: Colors.white,
          ),
          shouldIconPulse: true,
          "Success",
          'Bank transfer created successfully',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        Get.offAll(() => NavigationMenu());
        if (context.mounted) {
          showReceiptDialog(context);
        }
      });
    } on FirebaseAuthException catch (e) {
      throw TFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      print(e.toString());
      throw TFirebaseException(e.code).message;
    } on TPlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {        isLoading.value = false;

    throw 'Something went wrong. Please try again';
    }
    isLoading.value = false;
  }

  /// *-----------------------------End data submission----------------------------------*
}
