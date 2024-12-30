import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../utils/constants/colors.dart';
import '../onboarding_controller.dart';

class DotNavigator extends StatelessWidget {
  const DotNavigator({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final controller = OnboardingController.instance;
    return Positioned(
      bottom: 56,
      left: 24,
      child: SmoothPageIndicator(
        controller: controller.pageController,
        effect: ExpandingDotsEffect(
          dotWidth: 12,
          dotHeight: 6,
          activeDotColor: AppColors.prettyDark,
          dotColor: Colors.grey.shade400,
        ),
        count: 8,
      ),
    );
  }
}
