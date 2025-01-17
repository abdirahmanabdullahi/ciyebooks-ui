import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../utils/constants/colors.dart';
class PageOne extends StatelessWidget {
  const PageOne({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: ClampingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Let’s set up your account with accurate details to get started. This will help us provide you with a seamless experience!",
                  style: Theme
                      .of(context)
                      .textTheme
                      .bodyLarge,
                  // textAlign: TextAlign.center,
                ),
              ],
            ),
            const Gap(30),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Before You Begin:",
                  style: Theme
                      .of(context)
                      .textTheme
                      .headlineSmall
                      ?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.secondary,
                  ),
                ),
                const Gap(10),
                Text(
                  "Here are a few things to keep in mind before setting up your account:",
                  style: Theme
                      .of(context)
                      .textTheme
                      .bodyLarge,
                ),
                const Gap(20),
                Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: Row(
                    children: [
                      const Icon(Icons.lightbulb_outline,
                          color: Colors.black, size: 20),
                      const Gap(10),
                      Expanded(
                        child: Text(
                          "Prepare a list of your current cash balances.",
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: Row(
                    children: [
                      const Icon(Icons.lightbulb_outline,
                          color: Colors.black, size: 20),
                      const Gap(10),
                      Expanded(
                        child: Text(
                          "Note any foreign currency balances you have.",
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: Row(
                    children: [
                      const Icon(Icons.lightbulb_outline,
                          color: Colors.black, size: 20),
                      const Gap(10),
                      Expanded(
                        child: Text(
                          "Have details of your outstanding expenses.",
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: Row(
                    children: [
                      const Icon(Icons.lightbulb_outline,
                          color: Colors.black, size: 20),
                      const Gap(10),
                      Expanded(
                        child: Text(
                          "Review your entries carefully before submitting to avoid mistakes.",
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
            const Gap(30),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Steps to Complete Your Setup:",
                  style: Theme
                      .of(context)
                      .textTheme
                      .headlineSmall
                      ?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.secondary,
                  ),
                ),
                const Gap(10),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Row(
                    children: [
                      const Icon(Icons.task_alt,
                          color: Colors.green, size: 20),
                      const Gap(10),
                      Expanded(
                        child: Text(
                          "1. Enter your starting cash balances.",
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Row(
                    children: [
                      const Icon(Icons.task_alt,
                          color: Colors.green, size: 20),
                      const Gap(10),
                      Expanded(
                        child: Text(
                          "2. Add any foreign currencies you may have.",
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Row(
                    children: [
                      const Icon(Icons.task_alt,
                          color: Colors.green, size: 20),
                      const Gap(10),
                      Expanded(
                        child: Text(
                          "3. Include any outstanding expenses.",
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Row(
                    children: [
                      const Icon(Icons.task_alt,
                          color: Colors.green, size: 20),
                      const Gap(10),
                      Expanded(
                        child: Text(
                          "4. Review and confirm your entries.",
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Row(
                    children: [
                      const Icon(Icons.task_alt,
                          color: Colors.green, size: 20),
                      const Gap(10),
                      Expanded(
                        child: Text(
                          "5. Submit your setup details.",
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Gap(30),

          ],
        ),
      ),
    );
  }
}