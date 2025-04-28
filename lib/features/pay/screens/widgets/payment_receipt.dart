import 'dart:io';

import 'package:ciyebooks/features/pay/controllers/pay_client_controller.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:share_plus/share_plus.dart';

final NumberFormat formatter = NumberFormat.decimalPatternDigits(
  locale: 'en_us',
  decimalDigits: 2,
);
createReceiptPdf() async {
  try {
    /// Create the receipt.
    final normalFont = await rootBundle.load('assets/fonts/Roboto-VariableFont_wdth,wght.ttf');
    final boldFonts = await rootBundle.load('assets/fonts/Roboto-Bold.ttf');

    final customNormalFont = pw.Font.ttf(normalFont);
    final customBoldFont = pw.Font.ttf(boldFonts);
    final pdf = pw.Document();
    final img = await rootBundle.load('assets/images/icons/checkMark.png');
    final imageBytes = img.buffer.asUint8List();
    pw.Image image1 = pw.Image(pw.MemoryImage(imageBytes));

    pdf.addPage(
      pw.Page(
        margin: pw.EdgeInsets.all(16),
        build: (pw.Context context) => pw.Column(
          children: [
            // Top success box
            pw.Container(
                width: double.maxFinite,
                padding: const pw.EdgeInsets.all(24),
                decoration: pw.BoxDecoration(
                  color: PdfColors.grey100,
                  borderRadius: pw.BorderRadius.circular(20),
                ),
                child: pw.Padding(
                  padding: pw.EdgeInsets.all(24),
                  child: pw.Column(
                    children: [
                      pw.Container(
                        alignment: pw.Alignment.center,
                        height: 120,
                        child: image1,
                      ),
                      pw.SizedBox(height: 24),
                      pw.Text(
                        "Payment Success!",
                        style: pw.TextStyle(letterSpacing: 2, fontSize: 25, font: customNormalFont, fontWeight: pw.FontWeight.bold),
                      ),
                      pw.SizedBox(height: 15),
                      pw.Text(
                        formatter.format(num.parse(PayClientController.instance.amount.text.trim())),
                        style: pw.TextStyle(
                          font: customBoldFont,
                          fontSize: 35,
                          fontWeight: pw.FontWeight.bold,
                          color: PdfColors.black,
                        ),
                      ),
                    ],
                  ),
                )),                      pw.SizedBox(height: 15),

            pw.Container(
                width: double.maxFinite,
                padding: const pw.EdgeInsets.all(24),
                decoration: pw.BoxDecoration(
                  color: PdfColors.grey100,
                  borderRadius: pw.BorderRadius.circular(20),
                ),
                child: pw.Padding(
                  padding: pw.EdgeInsets.all(24),
                  child: pw.Column(
                    children: [

                      pw.SizedBox(height: 24),
                      pw.Text(
                        "Payment Details!",
                        style: pw.TextStyle(letterSpacing: 2, fontSize: 25, font: customNormalFont, fontWeight: pw.FontWeight.bold),
                      ),
                      pw.SizedBox(height: 15),
                      pw.Text(
                        formatter.format(num.parse(PayClientController.instance.amount.text.trim())),
                        style: pw.TextStyle(
                          font: customBoldFont,
                          fontSize: 35,
                          fontWeight: pw.FontWeight.bold,
                          color: PdfColors.black,
                        ),
                      ),
                    ],
                  ),
                )),

            // Payment Details box
          ],
        ),
      ),
    );

    ///Share or download the receipt
    final directory = await getTemporaryDirectory();
    final path = directory.path;
    final file = File('$path/PAY-${PayClientController.instance.counters['paymentsCounter']}.pdf');
    await file.writeAsBytes(await pdf.save());
    if (await file.exists()) {
      await Share.shareXFiles([XFile(file.path)], text: "Here is your PDF receipt!");
    } else {}
  } catch (e) {}
}
