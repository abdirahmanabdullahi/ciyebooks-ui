import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../../utils/constants/image_strings.dart';
import '../../../../utils/constants/text_strings.dart';


class CustomHeader extends StatelessWidget {
  const CustomHeader({
    super.key,
    required this.title,
    required this.height,
    required this.subtitle,
    required this.label,
  });
  final double height;
  final String title, subtitle, label;

  @override
  Widget build(BuildContext context) {
    // final dark = HelperFunctions.isDarkMode(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Image(
          height: height,
          image: const AssetImage(AppImages.logoDark),
        ),
        const Gap(15),
        Text(
          title,
          style: TextStyle(fontWeight: FontWeight.bold)
        ),
        Text(
          AppTexts.loginSubTitle,
          style: TextStyle(),
        ),
      ],
    );
  }
}
