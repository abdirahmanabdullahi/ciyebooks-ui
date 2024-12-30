
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../auth/screens/login/login.dart';


class OnboardingController extends GetxController {
  static OnboardingController get instance => Get.find();

  final pageController = PageController();
  Rx<int> currentPageIndex = 0.obs;

  void updatePageIndex(index) => currentPageIndex.value = index;

  void skip() {
    int page = 8;
    pageController.jumpToPage(page);
  }

  // Update current index and skip to next page
  void nextPage() {

    if (currentPageIndex.value == 7) {
      Get.offAll(Login());
      final storage = GetStorage();



      storage.write('IsFirstTime', false);


    } else {
      int page = currentPageIndex.value + 1;
      pageController.jumpToPage(page);
    }
  }
}
