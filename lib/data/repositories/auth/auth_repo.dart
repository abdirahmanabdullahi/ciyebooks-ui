import 'package:ciyebooks/features/auth/models/user_model.dart';
import 'package:ciyebooks/features/auth/screens/signup/verify_email.dart';
import 'package:ciyebooks/utils/exceptions/firebase_auth_exceptions.dart';
import 'package:ciyebooks/utils/exceptions/firebase_exceptions.dart';
import 'package:ciyebooks/utils/exceptions/format_exceptions.dart';
import 'package:ciyebooks/utils/exceptions/platform_exceptions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../../../features/auth/screens/login/login.dart';
import '../../../features/setup/setup_screen.dart';
import '../../../navigation_menu.dart';

class AuthRepo extends GetxController {
  static AuthRepo get instance => Get.find();

  //Variables
  // final deviceStorage = GetStorage();
  final _auth = FirebaseAuth.instance;
  Rx<UserModel> userData = UserModel.empty().obs;
  final accountIssetup = false.obs;


// Called from main.dart on app launch
  @override
  void onReady() {

    // FlutterNativeSplash.remove();
    screenRedirect();
  }

  screenRedirect() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {

      ///Check if email is verified
      if (user.emailVerified) {

        /// Check if setup is complete
        final accountIssetup = await fetchsetupStatus();
        accountIssetup?Get.offAll(() => NavigationMenu()):Get.offAll(() => setupScreen());


      } else {
        Get.offAll(() => VerifyEmail());
      }
    } else {
      Get.offAll(() => Login());
    }
  }

  /// Check if account is setup
  Future<bool> fetchsetupStatus() async {
    try {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      final data = await FirebaseFirestore.instance.collection('users').doc(uid).get();
      if (data.exists) {
        userData.value = UserModel.fromJson(data.data()!);
      }
      return userData.value.accountIssetup;
    } on FirebaseAuthException catch (e) {
      throw TFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatException();
    } on TPlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw e.toString();
    }
  }
  /*------------------------ Email and password sign-in ------------------------*/

/// sign-in
  Future<UserCredential> login(String email, String password) async {
    try {
      return await _auth.signInWithEmailAndPassword(email: email, password: password);
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

/// Sign-up

  Future<UserCredential> registerWithEmailAndPassword(String email, String password) async {
    try {
      return await _auth.createUserWithEmailAndPassword(email: email, password: password);
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

  /// Send Email verification
  Future<void> sendEmailVerification() async {
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
      Get.offAll(() => Login());
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

  /// Send password reset link

  Future<void> sendPasswordResetLink(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
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

  /// Resend password reset link

  Future<void> resendPasswordResetLink(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
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
}
