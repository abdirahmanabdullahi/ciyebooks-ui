
import 'package:ciyebooks/features/onboarding/widgets/dot_navigator.dart';
import 'package:ciyebooks/features/onboarding/widgets/onboarding_nextButton.dart';
import 'package:ciyebooks/features/onboarding/widgets/onboarding_skipButton.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../utils/constants/image_strings.dart';
import '../../utils/constants/text_strings.dart';
import 'onboarding_controller.dart';
import 'widgets/onboarding_page.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(OnboardingController());
    // final dark = HelperFunctions.isDarkMode(context);
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            PageView(
              controller: controller.pageController,
              onPageChanged: controller.updatePageIndex,
              // physics: const NeverScrollableScrollPhysics(),
              children: const [
                OnboardingPage(
                  image: AppImages.logoDark,
                  title: AppTexts.onBoardingTitle1,
                  subtitle: AppTexts.onBoardingSubTitle1,
                ),
                OnboardingPage(
                  icon: Icons.manage_accounts,
                  title: AppTexts.onBoardingTitle2,
                  subtitle: AppTexts.onBoardingSubTitle2,
                ),
                OnboardingPage(
                  icon: Icons.group_add,
                  title: AppTexts.onBoardingTitle3,
                  subtitle: AppTexts.onBoardingSubTitle3,
                ),
                OnboardingPage(
                  icon: Icons.payment,
                  title: AppTexts.onBoardingTitle4,
                  subtitle: AppTexts.onBoardingSubTitle4,
                ),
                OnboardingPage(
                  icon: Icons.currency_exchange,
                  title: AppTexts.onBoardingTitle5,
                  subtitle: AppTexts.onBoardingSubTitle5,
                ),
                OnboardingPage(
                  icon: Icons.format_list_bulleted,
                  title: AppTexts.onBoardingTitle6,
                  subtitle: AppTexts.onBoardingSubTitle6,
                ),
                OnboardingPage(
                  icon: Icons.notifications_active,
                  title: AppTexts.onBoardingTitle7,
                  subtitle: AppTexts.onBoardingSubTitle7,
                ),OnboardingPage(
                  icon: Icons.calculate_outlined,
                  title: AppTexts.onBoardingTitle8,
                  subtitle: AppTexts.onBoardingSubTitle8,
                ),
              ],
            ),
            const OnboardingSkip(),
            const Positioned(
              right: 24,
              bottom: 40,
              child: OnboardingNextButton(),
            ),
            const DotNavigator()
          ],
        ),
      ),
    );
  }
}
