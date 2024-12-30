import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/sizes.dart';

class SwitchScreens extends StatelessWidget {
  const SwitchScreens({
    super.key,
    required this.title,
    required this.label,
    required this.onPressed,
  });
  final String title, label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(
          title,
          style: Theme.of(context)
              .textTheme
              .bodyLarge!
              .apply(color: AppColors.darkGrey),
        ),
        GestureDetector(
          onTap: onPressed,
          child: Text(
            label,
            style: Theme.of(context).textTheme.headlineSmall!.apply(
                  color: Colors.blue,
                ),
          ),
        ),
        Gap(AppSizes.defaultSpace)
      ],
    );
  }
}
