
import 'package:ciyebooks/features/bank/withdraw/withdraw_receipt_screen.dart';
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

class WithdrawConfirmScreen extends StatelessWidget {
  const WithdrawConfirmScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(
        showBackArrow: true,
        title: const Text("Confirm cash withdraw"),
        actions: [
          IconButton(
              onPressed: () => Get.offAll(() => NavigationMenu()),
              icon: const Icon(Icons.clear))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(6, 12, 6, 0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                Gap(20),
                CustomContainer(
                  darkColor: AppColors.quinary,
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AmountAndReceiptTileHeader(
                          title: "Confirm bank withdraw",
                          icon: Icon(
                            Icons.account_balance,
                            color: AppColors.quinary,
                          )),
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
                              trailing: const Icon(
                                Icons.edit,
                                color: Colors.grey,
                              ),
                              dense: true,
                              minTileHeight: 30,
                              leading: const Icon(Icons.payments_outlined),
                              title: const Text("US Dollar"),
                              subtitle: Text("Currency"),
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
                              subtitle: Text("Amount"),
                            ),
                            // ListTile(
                            //   // isThreeLine: true,
                            //   trailing: const Icon(
                            //     Icons.edit,
                            //     color: Colors.grey,
                            //   ),
                            //   dense: true,
                            //   minTileHeight: 30,
                            //   leading: const Icon(Icons.payments_outlined),
                            //   title: const Text("Faarah Warsame"),
                            //   subtitle: Text(receiverOrDepositor),
                            // ),
                            const ListTile(
                              isThreeLine: true,
                              dense: true,
                              minTileHeight: 30,
                              leading: Icon(Icons.note_add_outlined),
                              title:
                                  Text("Waxalasiyay gaariga xamuulka Abdiyare"),
                              subtitle: Text("Description"),
                            ),
                            Gap(AppSizes.sm), Divider(),
                            Gap(AppSizes.sm),
                            StatusText(
                                label: "Confirmation pending",
                                color: Colors.red),
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
              onPressed: () => Get.to(
                () => WithdrawReceiptScreen(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
