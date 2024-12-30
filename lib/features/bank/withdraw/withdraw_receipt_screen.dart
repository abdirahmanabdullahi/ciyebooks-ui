
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../../../common/custom_appbar.dart';
import '../../../common/styles/custom_container.dart';
import '../../../navigation_menu.dart';
import '../../../utils/constants/colors.dart';
import '../../../utils/constants/sizes.dart';
import '../../common/widgets/amount_and_receipt_tile_header.dart';
import '../../common/widgets/continue_button.dart';
import '../../common/widgets/status_text.dart';
import '../../dashboard/widgets/top_button.dart';

class WithdrawReceiptScreen extends StatelessWidget {
  const WithdrawReceiptScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(
        title: const Text("Withdraw cash receipt"),
        actions: [
          IconButton(
              onPressed: () => Get.offAll(() => NavigationMenu()),
              icon: const Icon(Icons.clear))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(12, 20, 12, 0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                CustomContainer(
                  darkColor: AppColors.quinary,
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AmountAndReceiptTileHeader(
                        title: 'Cash withdraw',
                        icon: Icon(
                          Icons.account_balance,
                          color: AppColors.quinary,
                        ),
                      ),
                      const Divider(
                        indent: 47,
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(24, 12, 6, 6),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ListTile(
                              dense: true,
                              minTileHeight: 30,
                              leading: const Icon(Icons.person_outline),
                              title: const Text("Abdirahman Abdullahi Abdi"),
                              subtitle: Text("Account withdrawn from"),
                            ),
                            ListTile(
                              isThreeLine: true,
                              dense: true,
                              minTileHeight: 30,
                              leading: const Icon(Icons.payments_outlined),
                              title: const Text("US Dollar"),
                              subtitle: Text("Currency withdrawn"),
                            ),
                            ListTile(
                              dense: true,
                              minTileHeight: 30,
                              leading: const Icon(Icons.pin_outlined),
                              title: const Text("2,345,566"),
                              subtitle: Text("Amount"),
                            ),
                            const ListTile(
                              isThreeLine: true,
                              dense: true,
                              minTileHeight: 30,
                              leading: Icon(Icons.description_outlined),
                              title:
                                  Text("Waxalasiyay gaariga xamuulka Abdiyare"),
                              subtitle: Text("Description"),
                            ),
                            const ListTile(
                              isThreeLine: true,
                              dense: true,
                              minTileHeight: 30,
                              leading: Icon(Icons.calendar_month),
                              title: Text("2/3/2024   12:45 pm"),
                              subtitle: Text("Date"),
                            ),
                            Gap(AppSizes.sm),
                            Divider(),
                            Gap(AppSizes.sm),
                            StatusText(
                                label: "Cash withdrawn", color: Colors.green),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Gap(AppSizes.spaceBtwSections * 2),
                // Continue Button
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
              ],
            ),
            ContinueButton(
              label: "Done",
              onPressed: () => Get.offAll(
                () => NavigationMenu(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
