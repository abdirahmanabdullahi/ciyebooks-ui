
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class HelperFunctions {
  static bool isDarkMode(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark;
  }

  static Size screenSize() {
    return MediaQuery.of(Get.context!).size;
  }

  static double screenHeight() {
    return MediaQuery.of(Get.context!).size.height;
  }

  static double screenWidth() {
    return MediaQuery.of(Get.context!).size.width;
  }
  //
  // ///Check internet connection
  // static isConnected(BuildContext context, Future<dynamic> functionToCallWhenSuccessful) async {
  //   try {
  //     final result = await InternetAddress.lookup('example.com');
  //     if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
  //       functionToCallWhenSuccessful;
  //     } else {
  //       return;
  //     }
  //   } on SocketException catch (_) {
  //     if (context.mounted) {
  //       showErrorDialog(context: context, errorTitle: 'Connection error!', errorText: 'Please check your network connection and try again.');
  //     }
  //   }
  // }
}
