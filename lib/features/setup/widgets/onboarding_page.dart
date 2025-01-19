import 'dart:core';

import 'package:ciyebooks/features/auth/screens/login/login.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../../utils/constants/colors.dart';
import '../../../utils/constants/sizes.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({
    super.key,
    required this.title,
    required this.subtitle,
    this.image,
    this.icon,
  });
  final String title, subtitle;
  final String? image;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    // final dark = HelperFunctions.isDarkMode(context);
    return Padding(
      padding: const EdgeInsets.all(AppSizes.defaultSpace + 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          image == null
              ? Icon(
                  icon,
                  size: 150,
                  color: AppColors.darkGrey,
                )
              : Image(width: 150, image: AssetImage(image!)),
          const Gap(AppSizes.spaceBtwItems / 2),
          Text(
            textAlign: TextAlign.center,
            title,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const Gap(AppSizes.spaceBtwItems / 2),
          Text(
            textAlign: TextAlign.center,
            subtitle,
            style: Theme.of(context).textTheme.bodyMedium,
          ),FloatingActionButton(onPressed: ()=> Get.offAll(()=>Login()))
        ],
      ),
    );
  }
}
