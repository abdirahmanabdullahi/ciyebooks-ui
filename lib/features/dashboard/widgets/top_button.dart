import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../utils/constants/colors.dart';
import '../../../utils/constants/sizes.dart';

class TopButton extends StatelessWidget {
  const TopButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onPressed,
    required this.heroTag,
    this.backgroundColor = AppColors.prettyDark,
    this.iconColor = AppColors.quinary,
  });
  final VoidCallback onPressed;
  final IconData icon;
  final String label, heroTag;
  final Color? backgroundColor;
  final Color? iconColor;
  @override
  Widget build(BuildContext context) {
    // final dark = HelperFunctions.isDarkMode(context);
    return Column(mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: 55,
          width: 55,
          child: FloatingActionButton(
            heroTag: heroTag,
            backgroundColor: AppColors.quinary,
            shape: RoundedRectangleBorder(side: BorderSide(
                color: AppColors.prettyBlue,width: 1.5
            ),
                borderRadius: BorderRadius.circular(100)),
            onPressed: onPressed,
            child: Icon(
              // size: 20,
              icon,
              color: AppColors.prettyDark,
            ),
          ),
        ),
        Gap(AppSizes.sm / 2),
        Text(
          label, style: TextStyle(fontSize: 12,
            fontWeight:FontWeight.w700,color: AppColors.quinary),
        )
      ],
    );
  }
}
