import 'package:ciyebooks/features/auth/controllers/signin_controller.dart';
import 'package:ciyebooks/features/auth/screens/password_config/reset_password.dar/forgot_password.dart';
import 'package:ciyebooks/utils/constants/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SignInController());
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Image(height: 150, image: AssetImage('assets/logos/logo.png')),
            Padding(
              padding: const EdgeInsets.only(left: 12.0),
              child: const Text(
                'Welcome back',
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 45,
                      child: CupertinoTextField(decoration: BoxDecoration(color: AppColors.quinary, borderRadius: BorderRadius.circular(10)), placeholder: 'Email', controller: controller.email),
                    ),
                    Gap(10),
                    SizedBox(
                      height: 45,
                      child:
                           CupertinoTextField(
                
                            decoration: BoxDecoration(color: AppColors.quinary, borderRadius: BorderRadius.circular(10)),
                            obscureText: true,
                            controller: controller.password,
                            placeholder: 'Password',
                
                        ),
                
                    ),
                    Gap(25),
                    SizedBox(
                      width: double.maxFinite,
                      height: 45,
                      child: Obx(
                        () => FloatingActionButton(
                          elevation: 3,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          backgroundColor: AppColors.prettyBlue,
                          // elevation: 0,
                          onPressed: controller.isLoading.value ? null : () => controller.checkInternetConnection(context),
                          child: Text(
                            'Sign in',
                            style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.quinary),
                          ),
                        ),
                      ),
                    ),
                    Gap(6),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Align(
                          alignment: Alignment.topRight,
                          child: GestureDetector(
                            onTap: () => Navigator.push(context, CupertinoPageRoute(builder: (context) => ForgotPassword())),
                            child: RichText(
                                text: TextSpan(
                              children: [
                                TextSpan(
                                  text: 'Forgot password? Reset ',
                                  style: TextStyle(fontWeight: FontWeight.bold, color: CupertinoColors.systemBlue),
                                ),
                                TextSpan(
                                  text: 'here',
                                  style: TextStyle(decoration:TextDecoration.underline,fontWeight: FontWeight.bold, color: CupertinoColors.systemBlue),
                                ),
                              ],
                            )),
                          )),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
