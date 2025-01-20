import 'dart:ffi';

import 'package:ciyebooks/data/repositories/auth/auth_repo.dart';
import 'package:ciyebooks/features/setup/models/setup_model.dart';
import 'package:ciyebooks/features/setup/repo/setup_repo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../utils/helpers/network_manager.dart';

class SetupController extends GetxController {
  static SetupController get instance => Get.find();

  final isLoading = false.obs;
  final capital = TextEditingController();
  final kesCashBalance = TextEditingController();
  final usdCashBalance = TextEditingController();
  final kesBankBalance = TextEditingController();
  final usdBankBalance = TextEditingController();
  final kesReceivables = TextEditingController();
  final usdReceivables = TextEditingController();
  final kesPayables = TextEditingController();
  final usdPayables = TextEditingController();
  final accountIsSetup = TextEditingController();
  final profitBalance = TextEditingController();
  final dateCreated = TextEditingController();

  GlobalKey<FormState> capitalFormKey = GlobalKey<FormState>();
  GlobalKey<FormState> cashKesInHandFormKey = GlobalKey<FormState>();
  Rx<BalancesModel> balances = BalancesModel.empty().obs;
  final setupRepo = Get.put(SetupRepo());

  ///
  final capitalAmount = ''.obs;


  final setUpStream =  FirebaseFirestore.instance
      .collection('Users')
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .collection('Setup')
      .doc('Balances')
      .snapshots();


  final receivablesStream =  FirebaseFirestore.instance
      .collection('Users')
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .collection('Setup')
      .doc('Accounts')
      .snapshots();



  // / Fetch setup data
  Future<void> fetchBalanceSData() async {
    try {
      capitalAmount.value =  capital.value.toString();

      final balances = await SetupRepo.instance.getSetupData();
      this.balances(balances);
    } catch (e) {
      Get.snackbar("There was an error fetching data",
          "Please check your internet connection and try again",
          icon: Icon(
            Icons.cloud_off,
            color: Colors.white,
          ),
          backgroundColor: Color(0xffFF0033),
          colorText: Colors.white);

      balances(BalancesModel.empty());
    }
  }


  /// Save setup data to firestore
  Future<void> saveSetupData() async {
    try {
      //Start loading
      isLoading.value = true;
      //Check connectivity
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        Get.snackbar("Oh snap! No internet connection.",
            "Please check your internet connection and try again",
            icon: Icon(
              Icons.cloud_off,
              color: Colors.white,
            ),
            backgroundColor: Color(0xffFF0033),
            colorText: Colors.white);
        return;
      }

      final newSetup = BalancesModel(
        capital: double.tryParse(capital.text.trim()) ?? 0.0,
        kesCashBalance: double.tryParse(kesCashBalance.text.trim()) ?? 0.0,
        usdCashBalance: double.tryParse(usdCashBalance.text.trim()) ?? 0.0,
        kesBankBalance: double.tryParse(kesBankBalance.text.trim()) ?? 0.0,
        usdBankBalance: double.tryParse(usdBankBalance.text.trim()) ?? 0.0,
        kesReceivables: double.tryParse(kesReceivables.text.trim()) ?? 0.0,
        usdReceivables: double.tryParse(usdReceivables.text.trim()) ?? 0.0,
        kesPayables: double.tryParse(kesPayables.text.trim()) ?? 0.0,
        usdPayables: double.tryParse(usdPayables.text.trim()) ?? 0.0,
        accountIsSetup: false,
        profitBalance: double.tryParse(profitBalance.text.trim()) ?? 0.0,
      );

      final setupRepo = Get.put(SetupRepo());
      await setupRepo.saveSetupData(newSetup);

      ///Success message
      // Get.snackbar('Congratulations', ' Account setup complete',
      //     backgroundColor: Colors.green, colorText: Colors.white);

      ///Go to ScreenRedirect
      // AuthRepo.instance.screenRedirect();
    } catch (e) {
      Get.snackbar("Oh snap!", e.toString(),
          backgroundColor: Color(0xffFF0033), colorText: Colors.white);
    }
  }

  ///Update capital
  Future<void> setupCapital() async {
    final setupRepo = Get.put(SetupRepo());

    try {
      // Validate the form before proceeding
      if (!capitalFormKey.currentState!.validate()) {
        return;
      }
      final connection = await NetworkManager.instance.isConnected();
      connection
          ? null
          : Get.snackbar(
              "Success!",
              "Capital has been saved locally and will sync once you're online.",
              backgroundColor: Colors.blue,
              colorText: Colors.white,
            );

      // Prepare data to update
      Map<String, dynamic> capitalBalance = {
        'Capital': double.tryParse(capital.text.trim()) ?? 00,
      };

      // Update the single field in the repository
      await setupRepo.updateSingleField(capitalBalance);
      Get.back();

      // Notify the user of success
      Get.snackbar(
        "Success!",
        "Capital has been updated successfully.",
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      // Handle errors and notify the user
      print(e.toString());
      Get.snackbar(
        "Oh snap!",
        e.toString(),
        backgroundColor: Colors.black,
        colorText: Colors.white,
      );
    }
  }

  ///Update kenya shilling cash in hand
  Future<void> updateKesCashInHand() async {
    final setupRepo = Get.put(SetupRepo());

    try {
      // Validate the form before proceeding
      if (!cashKesInHandFormKey.currentState!.validate()) {
        return;
      }

      // Prepare data to update
      Map<String, dynamic> balances = {
        'KesCashBalance': double.tryParse(kesCashBalance.text.trim()) ?? 00,
        'KesBankBalance': double.tryParse(kesBankBalance.text.trim()) ?? 00,
      };

      // Update the single field in the repository
      await setupRepo.updateSingleField(balances);
      Get.back();

      // Notify the user of success
      Get.snackbar(
        "Success!",
        "Capital has been updated successfully.",
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      // Handle errors and notify the user
      print(e.toString());
      Get.snackbar(
        "Oh snap!",
        e.toString(),
        backgroundColor: Colors.black,
        colorText: Colors.white,
      );
    }
  }
}
