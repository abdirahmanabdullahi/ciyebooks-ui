import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart'; // Add this import for date formatting

import '../../../common/custom_appbar.dart';
import '../../../common/styles/custom_container.dart';
import '../../../navigation_menu.dart';
import '../../../utils/constants/colors.dart';
import '../../../utils/constants/sizes.dart';
import '../../dashboard/home.dart';
import '../../dashboard/widgets/top_button.dart';

class ReceiptScreen extends StatelessWidget {
  const ReceiptScreen({
    super.key,
    required this.title,
    required this.receiptHeader,
  });
  final String title, receiptHeader;
  @override
  Widget build(BuildContext context) {
    // Get current date and time
    String formattedDate =
        DateFormat('yyyy-MM-dd').format(DateTime.now()); // Format for date
    String formattedTime =
        DateFormat('HH:mm:ss').format(DateTime.now()); // Format for time

    return Scaffold(
      appBar: CustomAppbar(
        showBackArrow: false,
        title: Text(title),
        actions: [
          IconButton(
              onPressed: () => Get.offAll(() => const Home()),
              icon: const Icon(Icons.clear))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppSizes.defaultSpace / 2),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Receipt Design
            Column(
              children: [
                Gap(AppSizes.spaceBtwSections / 2),
                CustomContainer(
                  darkColor: AppColors.quinary,
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        receiptHeader,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: AppColors.prettyDark,
                        ),
                      ),
                      const Divider(),
                      const Gap(8),

                      // Sender Details
                      Row(
                        children: [
                          const Icon(Icons.person_outline,
                              color: AppColors.prettyDark),
                          const Gap(12),
                          const Text(
                            "From: Abdirahman Abdullahi Abdi",
                            style: TextStyle(
                                fontSize: 16, color: AppColors.darkGrey),
                          ),
                        ],
                      ),
                      const Gap(8),

                      // Receiver Details
                      Row(
                        children: [
                          const Icon(Icons.person, color: AppColors.prettyDark),
                          const Gap(12),
                          const Text(
                            "To: Faarah Warsame",
                            style: TextStyle(
                                fontSize: 16, color: AppColors.darkGrey),
                          ),
                        ],
                      ),
                      const Gap(8),

                      // Transaction Amount
                      Row(
                        children: [
                          const Icon(Icons.attach_money,
                              color: AppColors.prettyDark),
                          const Gap(12),
                          const Text(
                            "Amount: 2,345,566 USD",
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: AppColors.darkGrey),
                          ),
                        ],
                      ),
                      const Gap(8),

                      // Description
                      Row(
                        children: [
                          const Icon(
                            Icons.note_add_outlined,
                          ),
                          const Gap(12),
                          const SizedBox(
                            width: 300,
                            child: Text(
                              "Description: Waxalasiyay gaariga xamuulka Abdiyare",
                              style: TextStyle(
                                  fontSize: 16, color: AppColors.darkGrey),
                            ),
                          ),
                        ],
                      ),
                      const Gap(8),
                      Row(
                        children: [
                          const Icon(Icons.calendar_month_outlined,
                              color: AppColors.prettyDark),
                          const Gap(12),
                          Text(
                            "Date: $formattedDate",
                            style: const TextStyle(
                                fontSize: 16, color: AppColors.darkGrey),
                          ),
                        ],
                      ),
                      const Gap(8),
                      Row(
                        children: [
                          const Icon(Icons.access_time,
                              color: AppColors.prettyDark),
                          const Gap(12),
                          Text(
                            "Time: $formattedTime",
                            style: const TextStyle(
                                fontSize: 16, color: AppColors.darkGrey),
                          ),
                        ],
                      ),
                      Gap(16),

                      // Payment Status
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            "Status: Completed",
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.green),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                Gap(AppSizes.spaceBtwSections * 4),
                // Continue Button
              ],
            ),

            // Receipt Container
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                TopButton(
                  backgroundColor: AppColors.quinary,
                  iconColor: AppColors.prettyDark,
                  icon: Icons.arrow_downward,
                  onPressed: () {},
                  heroTag: "Download",
                  label: 'Download',
                ),
                Gap(30),
                TopButton(
                    backgroundColor: AppColors.quinary,
                    iconColor: AppColors.prettyDark,
                    icon: Icons.ios_share_rounded,
                    label: "Share",
                    onPressed: () {},
                    heroTag: "Share"),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 50.0),
              child: SizedBox(
                height: 40,
                width: double.infinity,
                child: FloatingActionButton(
                  heroTag: "Receipt done",
                  backgroundColor: AppColors.prettyDark,
                  elevation: 0.3,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100)),
                  onPressed: () => Get.offAll(
                    () => const NavigationMenu(),
                  ),
                  child: Text(
                    "Done",
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium!
                        .apply(color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
