import 'package:ciyebooks/data/repositories/auth/auth_repo.dart';
import 'package:ciyebooks/features/setup/models/setup_model.dart';
import 'package:ciyebooks/features/setup/repo/setup_repo.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../utils/constants/text_strings.dart';
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

  GlobalKey<FormState> setUpFormKey = GlobalKey<FormState>();


  /// Save setup data to firestore
  Future<void> saveSetupData() async {
    try{
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

        return;
      }

      //Form validation
      // if (!setUpFormKey.currentState!.validate()) {
      //   return;
      // }
      final newSetup = BalancesModel(
          capital: double.tryParse(capital.text.trim()) ?? 00,
          kesCashBalance: double.tryParse(kesCashBalance.text.trim()) ?? 00,
          usdCashBalance: double.tryParse(usdCashBalance.text.trim()) ?? 00,
          kesBankBalance:double.tryParse(kesBankBalance.text.trim()) ?? 00,
          usdBankBalance: double.tryParse(usdBankBalance.text.trim()) ?? 00,
          kesReceivables:double.tryParse(kesReceivables.text.trim()) ?? 00,
          usdReceivables:double.tryParse(usdReceivables.text.trim()) ?? 00,
          kesPayables: double.tryParse(kesPayables.text.trim()) ?? 00,
          usdPayables:double.tryParse(usdPayables.text.trim()) ?? 00,
          accountIsSetup: true,
          profitBalance: double.tryParse(profitBalance.text.trim()) ?? 00,
          );

final setupRepo = Get.put(SetupRepo());
await setupRepo.saveUserDate(newSetup);
///Success message
      Get.snackbar('Congratulations',' Account setup complete',
          backgroundColor: Colors.green, colorText: Colors.white);

      ///Go to ScreenRedirect
      AuthRepo.instance.screenRedirect();

    }catch(e){
      Get.snackbar("Oh snap!", e.toString(),
          backgroundColor: Color(0xffFF0033), colorText: Colors.white);
    }
  }
}
