
import 'package:ciyebooks/utils/theme/widget_themes/appbar_theme.dart';
import 'package:ciyebooks/utils/theme/widget_themes/bottom_sheet_theme.dart';
import 'package:ciyebooks/utils/theme/widget_themes/checkbox_theme.dart';
import 'package:ciyebooks/utils/theme/widget_themes/elevated_button_theme.dart';
import 'package:ciyebooks/utils/theme/widget_themes/outlined_button_theme.dart';
import 'package:ciyebooks/utils/theme/widget_themes/text_field_theme.dart';
import 'package:ciyebooks/utils/theme/widget_themes/text_theme.dart';
import 'package:flutter/material.dart';
import '../constants/colors.dart';

class AppTheme {
  AppTheme._();

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    fontFamily: 'Roboto',
    disabledColor: AppColors.prettyGrey,
    brightness: Brightness.light,
    primaryColor: AppColors.primary,
    textTheme: AppTextTheme.lightTextTheme,
    // chipTheme: AppChipTheme.lightChipTheme,
    scaffoldBackgroundColor: AppColors.quarternary,
    appBarTheme: CustomAppBarTheme.lightAppBarTheme,
    checkboxTheme: TCheckboxTheme.lightCheckboxTheme,
    bottomSheetTheme: TBottomSheetTheme.lightBottomSheetTheme,
    elevatedButtonTheme: CustomElevatedButtonTheme.lightElevatedButtonTheme,
    outlinedButtonTheme: TOutlinedButtonTheme.lightOutlinedButtonTheme,
    inputDecorationTheme: TextFormFieldTheme.lightInputDecorationTheme,
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    fontFamily: 'Poppins',
    disabledColor: AppColors.prettyGrey,
    brightness: Brightness.dark,  
    primaryColor: AppColors.primary,
    textTheme: AppTextTheme.darkTextTheme,
    // chipTheme: AppChipTheme.darkChipTheme,
    scaffoldBackgroundColor: Color(0xff373A40),
    appBarTheme: CustomAppBarTheme.darkAppBarTheme,
    checkboxTheme: TCheckboxTheme.darkCheckboxTheme,
    bottomSheetTheme: TBottomSheetTheme.darkBottomSheetTheme,
    elevatedButtonTheme: CustomElevatedButtonTheme.darkElevatedButtonTheme,
    outlinedButtonTheme: TOutlinedButtonTheme.darkOutlinedButtonTheme,
    inputDecorationTheme: TextFormFieldTheme.darkInputDecorationTheme,
  );
}
