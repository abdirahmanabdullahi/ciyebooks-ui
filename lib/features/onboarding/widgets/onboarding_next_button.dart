import 'package:flutter/material.dart';

import '../../../utils/constants/colors.dart';
import '../../../utils/helpers/helper_functions.dart';
import '../onboarding_controller.dart';

class OnboardingNextButton extends StatelessWidget {
  const OnboardingNextButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final dark = HelperFunctions.isDarkMode(context);
    return SizedBox(width: 100,height: 45,
      child: FloatingActionButton(
        elevation: 0,
        backgroundColor: dark ? AppColors.tertiary : AppColors.prettyDark,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
        onPressed: () => OnboardingController.instance.nextPage(),
        child:  Text("Next",style:Theme.of(context).textTheme.titleLarge!.apply(color: Colors.white),)
      ),
    );
  }
}
