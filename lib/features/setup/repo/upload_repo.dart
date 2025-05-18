
import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../common/widgets/error_dialog.dart';

class UploadRepo extends GetxController {
  static UploadRepo get instance => Get.find();

  Future<List?> uploadData({
    required BuildContext context,
    required List checkList,
    required String fileName,
  }) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ['csv']);
    if (result != null) {
      File file = File(result.files.single.path!);

      if (!file.path.endsWith('.csv')) {
        if (context.mounted) {
          showErrorDialog(context:context, errorTitle: "Unsupported File Type.", errorText: "The selected file is not supported. Please upload a CSV file.");
        }
        return null;
      }
      if (file.readAsLinesSync(encoding: utf8).isEmpty) {
        if (context.mounted) {
          showErrorDialog(context:context,errorTitle:  "File empty.",errorText:  "The selected file has no data. Please upload a valid CSV file with data.");
        }
        return null;
      }

      final lines = file.readAsLinesSync(encoding: utf8);
      final List headers = lines.isNotEmpty ? lines[0].split(',').map((e) => e.replaceAll('"', '').trim()).toList() : [];
      if (!listEquals(headers, checkList)) {
        if (context.mounted) {
          showErrorDialog(context:context, errorTitle:  "Unsupported data format!.", errorText: 'Please use the provided "Totals template" excel sheet to upload your data');
        }
// showErrorDialog(context: context,errorTitle:  "Oops! Unsupported data format!.",errorText:  'Please use the provided "Total template" excel sheet to upload your data')        }
        return null;
      }

      return lines;
    }

    return null;
  }

  /// Function to show an error dialog
}
