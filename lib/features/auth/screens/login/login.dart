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
                      child: TextFormField(
                        decoration: InputDecoration(contentPadding: EdgeInsets.symmetric(horizontal: 16), labelText: 'Email'),
                        onChanged: (value) => controller.updateSubmitButton(), autocorrect: false, enableSuggestions: false,
                      ),
                    ),
                    Gap(10),
                    SizedBox(
                      height: 45,
                      child: Obx( 
                            () => TextFormField(
                          decoration: InputDecoration(suffixIcon: GestureDetector(onTap: ()=>controller.hidePassword.value=!controller.hidePassword.value,
                              child: Icon(controller.hidePassword.value?Icons.visibility:Icons.visibility_off,color: Colors.grey,),
                            ),

                              contentPadding: EdgeInsets.symmetric(horizontal: 16),
                              labelText: 'Password'),
                          onChanged: (value) => controller.updateSubmitButton(),
                          autocorrect: false, enableSuggestions: false,
                          obscureText: controller.hidePassword.value,
                          controller: controller.password,
                          // placeholder: 'Password',
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Align(
                          alignment: Alignment.topRight,
                          child: GestureDetector(
                              onTap: () => Navigator.push(context, CupertinoPageRoute(builder: (context) => ForgotPassword())),
                              child: Text(
                                'Forgot password?',
                                style: TextStyle(fontWeight: FontWeight.w500, color: CupertinoColors.systemBlue),
                              ))),
                    ),
                    SizedBox(
                      width: double.maxFinite,
                      height: 45,
                      child: Obx(
                        () => FloatingActionButton(
                          disabledElevation: 0,
                          elevation: 3,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          backgroundColor: AppColors.prettyBlue,
                          onPressed: (!controller.isButtonEnabled.value || controller.isLoading.value) ? null : () => controller.checkInternetConnection(context),
                          child: Text(
                            'Sign in',
                            style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.quinary),
                          ),
                        ),
                      ),
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
