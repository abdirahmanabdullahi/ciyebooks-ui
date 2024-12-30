import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../utils/constants/colors.dart';
import '../../utils/constants/sizes.dart';
import '../../utils/constants/text_strings.dart';

class SuccessScreen extends StatelessWidget {
  const SuccessScreen({
    super.key,
    required this.image,
    required this.title,
    required this.subtitle,
    required this.onPressed,
  });
  final String image, title, subtitle;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(AppSizes.sm

            ),
            child: Column(
              children: [
                Image(image: AssetImage(image)),
                const Gap(AppSizes.spaceBtwSections),
                Text(
                  title,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const Gap(AppSizes.spaceBtwItems),
                Text(
                  subtitle,
                  style: Theme.of(context).textTheme.labelMedium,
                  textAlign: TextAlign.center,
                ),
                const Gap(AppSizes.spaceBtwItems),
                SizedBox(height: 50,
                  width: double.infinity,
                  child: FloatingActionButton(elevation: 2,backgroundColor: AppColors.prettyDark,
                    onPressed: onPressed,
                    child:  Text(AppTexts.tContinue,style: Theme.of(context).textTheme.titleLarge!.apply(color: AppColors.quinary)),
                    // onPressed: () => Get.to(() => const Login()),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
