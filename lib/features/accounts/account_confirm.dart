
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../../common/custom_appbar.dart';
import '../../common/styles/custom_container.dart';
import '../../utils/constants/colors.dart';
import '../../utils/constants/sizes.dart';
import '../common/widgets/amount_and_receipt_tile_header.dart';
import '../common/widgets/continue_button.dart';
import '../common/widgets/status_text.dart';
import '../dashboard/home.dart';
import 'account_receipt.dart';

class AccountConfirm extends StatelessWidget {
  const AccountConfirm({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(
        showBackArrow: true,
        title: const Text("Create a personal account"),
        actions: [
          IconButton(
              onPressed: () => Get.offAll(() => const Home()),
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
                      AmountAndReceiptTileHeader(
                          title: "Create account",
                          icon: Icon(
                            Icons.person,
                            color: AppColors.quinary,
                          )),
                      Divider(
                        indent: 47,
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(24, 12, 6, 6),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const ListTile(
                              dense: true,
                              minTileHeight: 30,
                              leading: Icon(Icons.person_outline),
                              title: Text("Abdirahman Abdullahi Abdi"),
                              subtitle: Text("Account name"),
                            ),
                            const ListTile(
                              isThreeLine: true,
                              trailing: Icon(
                                Icons.edit,
                                color: Colors.grey,
                              ),
                              dense: true,
                              minTileHeight: 30,
                              leading: Icon(Icons.payments_outlined),
                              title: Text("US Dollar, KES"),
                              subtitle: Text("Account currencies"),
                            ),
                            const ListTile(
                              trailing: Icon(
                                Icons.edit,
                                color: Colors.grey,
                              ),
                              dense: true,
                              minTileHeight: 30,
                              leading:
                                  Icon(Icons.account_balance_wallet_outlined),
                              title: Text("2,345,566"),
                              subtitle: Text("USD balance"),
                            ),
                            const ListTile(
                              trailing: Icon(
                                Icons.edit,
                                color: Colors.grey,
                              ),
                              dense: true,
                              minTileHeight: 30,
                              leading:
                                  Icon(Icons.account_balance_wallet_outlined),
                              title: Text("2,345,566"),
                              subtitle: Text("KES balance"),
                            ),
                            const ListTile(
                              // isThreeLine: true,
                              trailing: Icon(
                                Icons.edit,
                                color: Colors.grey,
                              ),
                              dense: true,
                              minTileHeight: 30,
                              leading: Icon(Icons.phone_outlined),
                              title: Text("07 009 05900"),
                              subtitle: Text("Phone no"),
                            ),
                            const ListTile(
                              isThreeLine: true,
                              dense: true,
                              minTileHeight: 30,
                              leading: Icon(Icons.email_outlined),
                              title: Text("Abdirahman@gmail.com"),
                              subtitle: Text("Description"),
                            ),
                            Gap(AppSizes.sm),
                            const Divider(
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
              onPressed: () => Get.to(() => AccountReceipt()),
            )
          ],
        ),
      ),
    );
  }
}