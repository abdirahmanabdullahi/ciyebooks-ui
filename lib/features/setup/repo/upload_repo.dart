import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UploadRepo extends GetxController {
  static UploadRepo get instance => Get.find();


  Future uploadFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles();
      if (result != null) {
        File file = File(result.files.single.path!);


      }else{       Get.snackbar('title',  'message',backgroundColor: Colors.orange);
      }
    } catch (e) {
      throw e.toString();
    }
    return null;
  }


}

