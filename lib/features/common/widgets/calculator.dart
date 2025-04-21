import 'package:flutter/material.dart';

import '../../../utils/constants/colors.dart';
import '../../calculator/calculator_screen.dart';

showCalculator(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
          titlePadding: EdgeInsets.zero,
          insetPadding: EdgeInsets.fromLTRB(70, 0, 30, 0),
          backgroundColor: AppColors.quarternary,
          contentPadding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          content: SizedBox(
              width: double.maxFinite,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 20.0, 0, 16),
                child: CalculatorScreen(),
              )));
    },
  ).then((value) {
    // controller.enableOverlayButton.value = true;
  });
}
