import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../../../common/custom_appbar.dart';
import '../../../common/styles/custom_container.dart';
import '../../../utils/constants/colors.dart';
import '../../../utils/constants/sizes.dart';
import '../../common/widgets/continue_button.dart';
import '../../common/widgets/status_text.dart';
import '../../dashboard/home.dart';
import 'sell_receipt_screen.dart';

class SellConfirmScreen extends StatelessWidget {
  const SellConfirmScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(
        showBackArrow: true,
        title: Text("Sell Currency"),
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
            Column(
              children: [
                CustomContainer(
                  darkColor: AppColors.quinary,
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 35,
                            height: 35,
                            decoration: BoxDecoration(
                                color: AppColors.prettyDark,
                                borderRadius: BorderRadius.circular(30),
                                border: Border.all(
                                    width: 1, color: AppColors.darkGrey)),
                            child: const Center(
                              child: Icon(
                                Icons.currency_exchange,
                                size: 20,
                                color: AppColors.quinary,
                              ),
                            ),
                          ),
                          const Gap(12),
                          Text(
                            "Sell Currency",
                            style: const TextStyle(
                                // fontFamily: "Oswald",
                                color: AppColors.prettyDark,
                                fontSize: 25,
                                height: 1.2),
                          ),
                        ],
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
                              isThreeLine: true,
                              trailing: const Icon(
                                Icons.edit,
                                color: Colors.grey,
                              ),
                              dense: true,
                              minTileHeight: 30,
                              leading: const Icon(Icons.payments_outlined),
                              title: const Text("US Dollar"),
                              subtitle: Text("Currency sold"),
                            ),
                            ListTile(
                              isThreeLine: true,
                              trailing: const Icon(
                                Icons.edit,
                                color: Colors.grey,
                              ),
                              dense: true,
                              minTileHeight: 30,
                              leading: const Icon(Icons.pin_outlined),
                              title: const Text("2,345,566"),
                              subtitle: Text("Amount"),
                            ),
                            ListTile(
                              isThreeLine: true,

                              // isThreeLine: true,
                              trailing: const Icon(
                                Icons.edit,
                                color: Colors.grey,
                              ),
                              dense: true,
                              minTileHeight: 30,
                              leading: const Icon(Icons.trending_up_sharp),
                              title: const Text("Rate"),
                              subtitle: Text("128"),
                            ),
                            ListTile(
                              isThreeLine: true,

                              // isThreeLine: true,
                              trailing: const Icon(
                                Icons.edit,
                                color: Colors.grey,
                              ),
                              dense: true,
                              minTileHeight: 30,
                              leading: const Icon(
                                  Icons.check_circle_outline_outlined),
                              title: const Text("12,800"),
                              subtitle: Text("Total"),
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
                            Gap(AppSizes.sm),
                            Divider(
                              indent: 17,
                            ),
                            Gap(AppSizes.sm),
                            StatusText(
                                label: "Pending approval", color: Colors.red)
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            ContinueButton(
                label: "Confirm",
                onPressed: () => Get.to(() => SellReceiptScreen()))
          ],
        ),
      ),
    );
  }
}
