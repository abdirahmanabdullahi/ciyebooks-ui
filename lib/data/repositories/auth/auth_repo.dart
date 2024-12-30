import 'package:flutter/foundation.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../features/auth/screens/login/login.dart';
import '../../../features/onboarding/onboarding.dart';

class AuthRepo extends GetxController{
  static AuthRepo get instance =>Get.find();

  //Variables
final deviceStorage =  GetStorage();


// Called from main.dart on app launch
  @override
  void onReady() {
    FlutterNativeSplash.remove();
    screenRedirect();
  }

// Function to show relevant Screen
screenRedirect() async{
    if (kDebugMode){
      print('============================================== Get Storage Auth repo ==============================================');
      print(deviceStorage.read('IsFirstTime'));
    }

    //Local storage
    deviceStorage.writeIfNull('IsFirstTime', true);

    deviceStorage.read('IsFirstTime')!= true ? Get.offAll(()=>Login()):Get.offAll(()=>WelcomeScreen());
}

}