import 'package:ciyebooks/features/setup/widgets/cash_in_hand_page.dart';
import 'package:ciyebooks/features/setup/widgets/expense_page.dart';
import 'package:ciyebooks/features/setup/widgets/foreign_currencies_page.dart';
import 'package:ciyebooks/features/setup/widgets/page_one.dart';
import 'package:ciyebooks/features/setup/widgets/payables_page.dart';
import 'package:ciyebooks/features/setup/widgets/receivables_page.dart';
import 'package:ciyebooks/features/setup/widgets/starting_capital_page.dart';
import 'package:ciyebooks/features/setup/widgets/summary.dart';
import 'package:ciyebooks/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../../utils/constants/image_strings.dart';
import '../../utils/constants/text_strings.dart';
import 'widgets/onboarding_page.dart';

class Setup extends StatelessWidget {
  const Setup({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(Setup());
    return Scaffold(
      backgroundColor: AppColors.quarternary,
      body: SafeArea(
        child: Stack(
          children: [
            PageView(allowImplicitScrolling: false,
              controller: PageController(),
              children: [
                // Positioned(bottom:AppSizes.appBarHeight,child: DotNavigator()),
                OnboardingPage(
                  image: AppImages.logoDark,
                  title: AppTexts.onBoardingTitle1,
                  subtitle: AppTexts.onBoardingSubTitle1,
                ),
                HowItWorksPage(),
                PageOne(),
                StartingCapitalPage(),
                CashInHandPage(),
                ReceivablesPage(),
                PayablesPage(),
                ExpensesPage(),
                ForeignCurrenciesPage(),
                Summary(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class HowItWorksPage extends StatelessWidget {
  const HowItWorksPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Page Title
          Text(
            'How the App Works',
            style: Theme.of(context).textTheme.headlineMedium,
            textAlign: TextAlign.center,
          ),
          Divider(),
          const SizedBox(height: 20),
          Text(
            'The app has two modes:',
            style: Theme.of(context).textTheme.titleLarge,
            textAlign: TextAlign.center,
          ),
          Gap(60),

          // Online and Offline States
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Online State
              Column(
                children: const [
                  Icon(
                    Icons.wifi,
                    size: 64,
                    color: Colors.blue,
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Online',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                  ),
                ],
              ),

              // Offline State
              Column(
                children: const [
                  Icon(
                    Icons.wifi_off,
                    size: 64,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Offline',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 32),

          // Explanation
          Expanded(
            child: ListView(
              children: [
                const Text(
                  'Online Mode:',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const Divider(),
                const SizedBox(height: 8),
                const Text(
                  'In online mode, the app synchronizes data with a remote or cloud data source. '
                  'All changes made while online are immediately saved and reflected in the cloud.',
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Offline Mode:',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const Divider(),
                const SizedBox(height: 8),
                const Text(
                  'In offline mode, the app uses locally cached data to ensure seamless usage. '
                  'When the network is restored, the app updates the remote database automatically.',
                  style: TextStyle(fontSize: 16),
                ),
                const Gap(120),
                Divider(),
                Gap(30),
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w100,
                      color: Colors
                          .black, // Default color for non-highlighted text
                    ),
                    children: [
                      const TextSpan(text: 'Offering you '),
                      TextSpan(
                        text: 'smooth, ',
                        style: const TextStyle(
                          fontSize: 24, // Bigger font size for highlight
                          color: Colors.blue, // Highlight color
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(
                        text: 'continuous',
                        style: const TextStyle(
                          fontSize: 28, // Bigger font size for highlight
                          color: Colors.blue, // Highlight color
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const TextSpan(text: ', '),
                      const TextSpan(text: ' and '),
                      TextSpan(
                        text: 'seamless',
                        style: const TextStyle(
                          fontSize: 34, // Bigger font size for highlight
                          color: Colors.blue, // Highlight color
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const TextSpan(
                          text: ' user experience.',
                          style: TextStyle(
                              color: AppColors.prettyDark,
                              fontWeight: FontWeight.w300)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
