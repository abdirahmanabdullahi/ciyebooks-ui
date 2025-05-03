import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../utils/constants/colors.dart';

class UploadRepo extends GetxController {
  static UploadRepo get instance => Get.find();

  // Future<List?> uploadData({
  //   required BuildContext context,
  //   required List checkList,
  //   required String fileName,
  // }) async {
  //   ///Todo: upload the file.
  //   FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ['csv']);
  //   if (result != null) {
  //     File file = File(result.files.single.path!);
  //
  //     ///Todo:Check if file type is CSV.
  //     if (!file.path.endsWith('.csv')) {
  //       if (context.mounted) {
  //         showErrorDialog(context, "Oops! Unsupported File Type.", "The selected file is not supported. Please upload a CSV file.");
  //       }
  //       return null;
  //     }
  //     //Todo:Check if file is not empty.
  //     if (file.readAsLinesSync(encoding: utf8).isEmpty) {
  //       if (context.mounted) {
  //         showErrorDialog(context, "Oops! File is empty.", "The selected file has no content. Please upload a valid CSV file with data.");
  //       }
  //       return null;
  //     }
  //
  //     ///Todo: Check if all headers exist in the file.
  //     final lines = file.readAsLinesSync(encoding: utf8);
  //     final List headers = lines.isNotEmpty ? lines[0].split(',').map((e) => e.replaceAll('"', '').trim()).toList() : [];
  //
  //     if (!listEquals(headers, checkList)) {
  //       if (context.mounted) {
  //         showErrorDialog(context, "Oops! Unsupported data format!.", 'Column headers mismatch or missing. Please use the provided "$fileName" to upload your data');
  //       }
  //       return null;
  //     }
  //
  //     return lines;
  //   }
  //
  //   return null;
  // }

  /// Function to show an error dialog
  void showErrorDialog(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        insetPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        elevation: 10,
        titlePadding: EdgeInsets.zero,
        title: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 15),
              decoration: BoxDecoration(
                color: AppColors.quarternary,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline_outlined, color: Color(0xffFF2929), size: 30),
                  SizedBox(width: 10),
                  Text(
                    title,
                    style: TextStyle(
                      color: Color(0xffFF2929),
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        content: Text(
          message,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        actionsAlignment: MainAxisAlignment.center,
        actionsPadding: EdgeInsets.only(bottom: 15),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xffFF2929),
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 5,
            ),
            child: Text(
              "OK",
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
