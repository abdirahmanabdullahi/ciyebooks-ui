import 'package:flutter/material.dart';

import '../../../utils/constants/colors.dart';
import '../../../utils/constants/text_strings.dart';
import '../onboarding_controller.dart';

class OnboardingSkip extends StatelessWidget {
  const OnboardingSkip({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 24,
      right: 24,
      child: TextButton(
        onPressed: () => OnboardingController.instance.skip(),
        child: Text(AppTexts.skip,style: TextStyle(color: AppColors.prettyDark),),
      ),
    );
  }
}
