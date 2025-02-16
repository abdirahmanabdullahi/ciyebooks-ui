import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import '../../../common/custom_appbar.dart';
import '../../../common/styles/custom_container.dart';
import '../../../utils/constants/colors.dart';
import '../../../utils/constants/sizes.dart';

import '../common/widgets/amount_and_receipt_tile_header.dart';
import '../common/widgets/continue_button.dart';
import '../common/widgets/status_text.dart';
import '../dashboard/home.dart';
import 'internal_transfer_receipt_screen.dart';

class InternalTransferConfirmScreen extends StatelessWidget {
  const InternalTransferConfirmScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(
        showBackArrow: true,
        title: const Text("Internal transfer"),
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
                      AmountAndReceiptTileHeader(
                        title: "Confirm \ninternal transfer",
                        icon: Icon(
                          Icons.swap_horiz,
                          color: AppColors.quinary,
                        ),
                      ),
                      const Divider(
                        indent: 47,
                      ),
                      const Padding(
                        padding: EdgeInsets.fromLTRB(24, 12, 6, 6),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ListTile(
                              dense: true,
                              minTileHeight: 30,
                              leading: Icon(Icons.person_outline),
                              title: Text("Abdirahman Abdullahi Abdi"),
                              subtitle: Text("Transferring account"),
                            ),
                            ListTile(
                              isThreeLine: true,
                              trailing: Icon(
                                Icons.edit,
                                color: Colors.grey,
                              ),
                              dense: true,
                              minTileHeight: 30,
                              leading: Icon(Icons.payments_outlined),
                              title: Text("US Dollar"),
                              subtitle: Text("Currency"),
                            ),
                            ListTile(
                              trailing: Icon(
                                Icons.edit,
                                color: Colors.grey,
                              ),
                              dense: true,
                              minTileHeight: 30,
                              leading: Icon(Icons.pin_outlined),
                              title: Text("2,345,566"),
                              subtitle: Text("Amount"),
                            ),
                            ListTile(
                              // isThreeLine: true,
                              trailing: Icon(
                                Icons.edit,
                                color: Colors.grey,
                              ),
                              dense: true,
                              minTileHeight: 30,
                              leading: Icon(Icons.person),
                              title: Text("Faarah Warsame"),
                              subtitle: Text("Receiving account"),
                            ),
                            ListTile(
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
            ContinueButton(
                label: "Confirm",
                onPressed: () => Get.to(() => InternalTransferReceiptScreen()))
          ],
        ),
      ),
    );
  }
}
