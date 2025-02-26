import 'dart:io';

import 'package:ciyebooks/features/calculator/controller.dart';
import 'package:ciyebooks/features/pay/pay_client/pay_client_model/pay_client_model.dart';
import 'package:ciyebooks/utils/device/device_utility.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
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

class PayClientController extends GetxController {
  static PayClientController get instance => Get.find();

  final counters = {}.obs;
  Rx<BalancesModel> totals = BalancesModel.empty().obs;
  final cashBalances = {}.obs;
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
  final amount = TextEditingController();
  final paidCurrency = TextEditingController();
  final receiver = TextEditingController();
  final accountNo = TextEditingController();
  final description = TextEditingController();

  ///

  final _uid = FirebaseAuth.instance.currentUser?.uid;

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

  void updateButtonStatus() {
    isButtonEnabled.value = from.text.isNotEmpty && accountNo.text.isNotEmpty && amount.text.isNotEmpty && paidCurrency.text.isNotEmpty && (num.parse(amount.text) > 0);
  }

  /// *-----------------------------Start data submission---------------------------------*
  fetchTotals() async {
    DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance.collection('Users').doc(_uid).collection('Setup').doc('Balances').get();

    if (documentSnapshot.exists && documentSnapshot.data() != null) {
      totals.value = BalancesModel.fromJson(documentSnapshot.data() as Map<String, dynamic>);
      cashBalances.value = totals.value.cashBalances;
      counters.value = totals.value.transactionCounters;
      payments.value = totals.value.payments;
      transactionCounter.value = counters['paymentsCounter'];
      print('[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[$transactionCounter]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]');
    }
  }

  /// *-----------------------------Create and share pdf receipt----------------------------------*

  Future<void> createPdf() async {
    final font = await rootBundle.load("assets/fonts/Poppins-Regular.ttf");
    final ttf = pw.Font.ttf(font);
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) => pw.Column(children: [ pw.Container(
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
                    // pw.Icon(
                    //   pw.Icon(pw.IconData(0xe156), size: 40, color: PdfColors.blue) as pw.IconData,
                    // ),
                    // SizedBox(pw.height: 10),
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
                        pw.Text('pymnt-${counters['paymentsCounter']}', style: pw.TextStyle(color: PdfColors.black, fontWeight: pw.FontWeight.bold, font: ttf)),
                      ],
                    ),  pw.SizedBox(
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
                    ),  pw.SizedBox(
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
                        pw.Text(paidToOwner.value ? 'Account holder' : receiver.text.trim(), style: pw.TextStyle(color: PdfColors.black, fontWeight: pw.FontWeight.bold, font: ttf)),
                      ],
                    ),  pw.SizedBox(
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
                    ),  pw.SizedBox(
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
                        pw.Text(amount.text.trim().toString(), style: pw.TextStyle(font: ttf, color: PdfColors.black, fontWeight: pw.FontWeight.bold)),
                      ],
                    ),  pw.SizedBox(
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
                          DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now()),
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
          ),),],)


      ),
    );
    final directory = await getApplicationDocumentsDirectory();
    final path = directory.path;
    final file = File('$path/pymnt-${counters['paymentsCounter']}.pdf');
    await file.writeAsBytes(await pdf.save());
    if (await file.exists()) {
      Share.shareXFiles([XFile(file.path)], text: "Here is your PDF receipt!");
    } else {
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
                height: 70,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.task_alt_outlined,
                      size: 40,
                      color: AppColors.quinary,
                    ),
                    Gap(20),
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
                        Text('pymnt-${counters['paymentsCounter']}', style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w600)),
                      ],
                    ),
                    Gap(5),
                    Divider(thickness: 1, color: Colors.grey[300]),
                    Row(
                      children: [
                        Expanded(
                          child: Text("From", style: TextStyle()),
                        ),
                        Text(from.text.trim(), style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w600)),
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
                        Text(paidToOwner.value ? 'Account holder' : receiver.text.trim(), style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w600)),
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
                        Text(formatter.format(int.parse(amount.text)), style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w600)),
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
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Image(
                        height: 50,
                        image: NetworkImage('https://media.istockphoto.com/id/828088276/vector/qr-code-illustration.jpg?s=612x612&w=0&k=20&c=FnA7agr57XpFi081ZT5sEmxhLytMBlK4vzdQxt8A70M=')),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                                onPressed: () => createPdf(),
                                icon: Icon(
                                  color: CupertinoColors.systemBlue,
                                  Icons.download_for_offline_outlined,
                                  size: 30,
                                )),
                            Text(
                              'Download',
                              style: TextStyle(fontSize: 12),
                            )
                          ],
                        ),
                        Gap(30),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                                onPressed: () {},
                                icon: Icon(
                                  color: CupertinoColors.systemBlue,
                                  Icons.share,
                                  size: 30,
                                )),
                            Text(
                              'Share',
                              style: TextStyle(fontSize: 12),
                            )
                          ],
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future createPayment(BuildContext context) async {
    if (!paidToOwner.value) {
      if (!payClientFormKey.currentState!.validate()) {
        print('Form not valid');
        return;
      }
    }
    try {
      print('Submitting data...');

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
      final paymentRef = db.collection('Users').doc(_uid).collection('transactions').doc('pymnt-${counters['paymentsCounter']}');
      final counterRef = db.collection('Users').doc(_uid).collection('Setup').doc('Balances');
      final cashRef = db.collection('Users').doc(_uid).collection('Setup').doc('Balances');
      final accountRef = db.collection('Users').doc(_uid).collection('accounts').doc(accountNo.text.trim());

      ///Get data from the controllers
      final newPayment = PayClientModel(
          transactionId: 'pymnt-${counters['paymentsCounter']}',
          transactionType: 'payment',
          accountFrom: from.text.trim(),
          currency: paidCurrency.text.trim(),
          amountPaid: double.tryParse(amount.text.trim()) ?? 0.0,
          receiver: receiver.text.trim(),
          dateCreated: DateTime.now(),
          description: description.text.trim());

      ///Update account
      batch.update(accountRef, {'Currencies.${paidCurrency.text.trim()}': FieldValue.increment(-num.parse(amount.text.trim()))});

      ///Create payment transaction
      batch.set(paymentRef, newPayment.toJson());

      ///update cash balance
      batch.update(cashRef, {"cashBalances.${paidCurrency.text.trim()}": FieldValue.increment(-num.parse(amount.text.trim()))});

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
        Get.offAll(() => NavigationMenu());
        if (context.mounted) {
          showReceiptDialog(context);
        }
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
      print(e.toString());
      throw 'Something went wrong. Please try again';
    }
  }

  /// *-----------------------------End data submission----------------------------------*
}
