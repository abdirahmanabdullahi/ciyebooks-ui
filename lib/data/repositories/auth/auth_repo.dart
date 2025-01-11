import 'package:ciyebooks/features/auth/screens/signup/verify_email.dart';
import 'package:ciyebooks/navigation_menu.dart';
import 'package:ciyebooks/utils/exceptions/firebase_auth_exceptions.dart';
import 'package:ciyebooks/utils/exceptions/firebase_exceptions.dart';
import 'package:ciyebooks/utils/exceptions/format_exceptions.dart';
import 'package:ciyebooks/utils/exceptions/platform_exceptions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../features/auth/screens/login/login.dart';
import '../../../features/onboarding/onboarding.dart';

class AuthRepo extends GetxController {
  static AuthRepo get instance => Get.find();

  //Variables
  final deviceStorage = GetStorage();
  final _auth = FirebaseAuth.instance;

// Called from main.dart on app launch
  @override
  void onReady() {
    FlutterNativeSplash.remove();
    screenRedirect();
  }

// Function to show relevant Screen
  screenRedirect() async {
    final user = FirebaseAuth.instance.currentUser;
    if(user == null){
      //Local storage
      deviceStorage.writeIfNull('IsFirstTime', true);

      deviceStorage.read('IsFirstTime') != true
          ? Get.offAll(() => Login())
          : Get.offAll(
            () => WelcomeScreen(),
      );

    }else{
      if(user.emailVerified){
        Get.offAll(()=>NavigationMenu());
      }else{
        Get.offAll(()=>VerifyEmail());

      }

    }

  }

  /*------------------------ Email and password sign-in ------------------------*/

// sign-in

// Sign-up
  Future<UserCredential> registerWithEmailAndPassword(
      String email, String password) async {
    try {
      return await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
    } on FirebaseAuthException catch (e) {
      throw TFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatException();
    } on TPlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }

  ///Email verification
  Future<void> sendEmailVerification(
    ) async {
    try {
       await _auth.currentUser?.sendEmailVerification();
    } on FirebaseAuthException catch (e) {
      throw TFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatException();
    } on TPlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }



/// Logout user

Future<void> logoutUser() async {
  try {
     await FirebaseAuth.instance.signOut();
     Get.offAll(()=>Login());
  } on FirebaseAuthException catch (e) {
    throw TFirebaseAuthException(e.code).message;
  } on FirebaseException catch (e) {
    throw TFirebaseException(e.code).message;
  } on FormatException catch (_) {
    throw const TFormatException();
  } on TPlatformException catch (e) {
    throw TPlatformException(e.code).message;
  } catch (e) {
    throw 'Something went wrong. Please try again';
  }
}}