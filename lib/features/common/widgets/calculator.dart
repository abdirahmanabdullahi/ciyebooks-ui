import 'package:flutter/material.dart';

import '../../../utils/constants/colors.dart';
import '../../calculator/calculator_screen.dart';

showCalculator(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
          titlePadding: EdgeInsets.zero,
          insetPadding: EdgeInsets.fromLTRB(20,200,20,0),
          backgroundColor: AppColors.quarternary,
          contentPadding: EdgeInsets.all(15),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(35)),
          content: CalculatorScreen());
    },
  ).then((value) {
    // controller.enableOverlayButton.value = true;
  });
}
