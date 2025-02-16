import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../../../common/custom_appbar.dart';
import '../../../common/styles/custom_container.dart';
import '../../../utils/constants/colors.dart';
import '../../../utils/constants/sizes.dart';
import '../../dashboard/home.dart';
import '../widgets/continue_button.dart';
import '../widgets/status_text.dart';

class ConfirmScreen extends StatelessWidget {
  const ConfirmScreen(
      {super.key,
      required this.screenTitle,
      required this.previewBoxTitle,
      required this.currencySubtitle,
      required this.amountSubtitle,
      required this.accountLabel,
      required this.receiverOrDepositor,
      required this.onPressed});
  final String screenTitle,
      previewBoxTitle,
      currencySubtitle,
      amountSubtitle,
      accountLabel,
      receiverOrDepositor;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(
        showBackArrow: true,
        title: Text(screenTitle),
        actions: [
          IconButton(
              onPressed: () => Get.offAll(() => const Dashboard()),
              icon: const Icon(Icons.clear))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppSizes.defaultSpace / 2),
        child: Column(
          // mainAxisSize: MainAxisSize.max,
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
                                Icons.north_east,
                                size: 20,
                                color: AppColors.quinary,
                              ),
                            ),
                          ),
                          const Gap(12),
                          Text(
                            previewBoxTitle,
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
                              dense: true,
                              minTileHeight: 30,
                              leading: const Icon(Icons.person_outline),
                              title: const Text("Abdirahman Abdullahi Abdi"),
                              subtitle: Text(accountLabel),
                            ),
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
                              subtitle: Text(currencySubtitle),
                            ),
                            ListTile(
                              trailing: const Icon(
                                Icons.edit,
                                color: Colors.grey,
                              ),
                              dense: true,
                              minTileHeight: 30,
                              leading: const Icon(Icons.pin_outlined),
                              title: const Text("2,345,566"),
                              subtitle: Text(amountSubtitle),
                            ),
                            ListTile(
                              // isThreeLine: true,
                              trailing: const Icon(
                                Icons.edit,
                                color: Colors.grey,
                              ),
                              dense: true,
                              minTileHeight: 30,
                              leading: const Icon(Icons.payments_outlined),
                              title: const Text("Faarah Warsame"),
                              subtitle: Text(receiverOrDepositor),
                            ),
                            const ListTile(
                              isThreeLine: true,
                              dense: true,
                              minTileHeight: 30,
                              leading: Icon(Icons.note_add_outlined),
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
            ContinueButton(label: "Confirm", onPressed: onPressed)
          ],
        ),
      ),
    );
  }
}
