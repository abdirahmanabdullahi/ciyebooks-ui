import 'package:ciyebooks/bindings/general_bindings.dart';
import 'package:ciyebooks/utils/constants/colors.dart';
import 'package:ciyebooks/utils/constants/text_strings.dart';
import 'package:ciyebooks/utils/theme/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:lottie/lottie.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        initialBinding: GeneralBindings(),
        title: AppTexts.appName,
        // themeMode: ThemeMode.system,
        theme: AppTheme.lightTheme,
        // darkTheme: AppTheme.darkTheme,
        debugShowCheckedModeBanner: false,
        // initialBinding: GeneralBindings(),
        home: Scaffold(
            backgroundColor: AppColors.primary,
            body: Column(mainAxisAlignment: MainAxisAlignment.center,crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(width: double.maxFinite,),
                Image(height:100,image: AssetImage('assets/logos/logo dark.png')),
                Text('Fetching records...',style: TextStyle(fontSize: 12,fontWeight: FontWeight.w400,color: Colors.black),)
              ],
            )));
  }
}
