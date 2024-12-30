import 'package:flutter/material.dart';

import '../../../utils/constants/colors.dart';

class BottomSheetButton extends StatelessWidget {
  const BottomSheetButton({
    super.key,
    required this.label,
    required this.icon,
    required this.onPressed,
    required this.heroTag,
    this.amountScreen,
    // this.height = 40,
  });
  final String label, heroTag;
  final IconData icon;
  final VoidCallback? onPressed;
  final Widget? amountScreen;
  // final double? height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      width: double.infinity,
      child: FloatingActionButton(
        heroTag: heroTag,
        backgroundColor: AppColors.quinary,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
        onPressed: onPressed,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Align(alignment: Alignment.centerLeft,
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
        ),
      ),
    );
  }
}
