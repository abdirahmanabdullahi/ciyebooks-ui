import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../../../common/custom_appbar.dart';
import '../../../common/styles/custom_container.dart';
import '../../../utils/constants/colors.dart';
import '../../../utils/constants/sizes.dart';
import '../../navigation_menu.dart';
import '../common/widgets/amount_and_receipt_tile_header.dart';
import '../common/widgets/continue_button.dart';
import '../common/widgets/status_text.dart';
import '../dashboard/home.dart';

class InternalTransferReceiptScreen extends StatelessWidget {
  const InternalTransferReceiptScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(
        showBackArrow: true,
        title: const Text("Internal transfer"),
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
                      const AmountAndReceiptTileHeader(
                        title: "Internal\ntransfer receipt",
                        icon: Icon(
                          Icons.swap_horiz,
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
                            const ListTile(
                              dense: true,
                              minTileHeight: 30,
                              leading: Icon(Icons.person_outline),
                              title: Text("Abdirahman Abdullahi Abdi"),
                              subtitle: Text("Transferring account"),
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
                              title: Text("US Dollar"),
                              subtitle: Text("Currency"),
                            ),
                            const ListTile(
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
                            const ListTile(
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
                            const Divider(
                              indent: 17,
                            ),
                            Gap(AppSizes.sm),
                            StatusText(
                                label: "Transfer complete", color: Colors.green)
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            ContinueButton(
                label: "Done", onPressed: () => Get.to(() => NavigationMenu()))
          ],
        ),
      ),
    );
  }
}
