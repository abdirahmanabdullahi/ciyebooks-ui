import 'package:flutter/material.dart';

import '../../../utils/constants/colors.dart';

class ContinueButton extends StatelessWidget {
  const ContinueButton({
    super.key,
    required this.onPressed,
    this.label = "Continue",
  });
  final String? label;

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 50.0),
      child: SizedBox(
        height: 40,
        width: double.infinity,
        child: FloatingActionButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          onPressed: onPressed,
          // onPressed: () => Get.to(() => const ReceiptScreen()),
          backgroundColor: AppColors.prettyDark,
          child: Text(
            label!,
            style: Theme.of(context)
                .textTheme
                .titleMedium!
                .apply(color: AppColors.quinary),
          ),
        ),
      ),
    );
  }
}
