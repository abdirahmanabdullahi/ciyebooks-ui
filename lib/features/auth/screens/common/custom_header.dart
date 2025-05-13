import 'package:flutter/material.dart';

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
        // Padding(
        //   padding: const EdgeInsets.symmetric(horizontal: 10.0),
        //   child: Text(
        //     title,
        //     style: TextStyle(fontWeight: FontWeight.bold)
        //   ),
        // ),

        Padding(
          padding: const EdgeInsets.fromLTRB( 12,6,10,0),
          child: Text(
            AppTexts.loginTitle,
            style: TextStyle(fontWeight: FontWeight.w500,wordSpacing: 2,fontSize: 18),
          ),
        ),
      ],
    );
  }
}
