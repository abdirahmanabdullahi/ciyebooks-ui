
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
import '../../common/widgets/share_or_download_buttons.dart';
import '../../common/widgets/status_text.dart';

class PayReceiptScreen extends StatelessWidget {
  const PayReceiptScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(
        title: Text("Payment receipt"),
        actions: [
          IconButton(
              onPressed: () => Get.offAll(() => NavigationMenu()),
              icon: Icon(Icons.clear))
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
                          title: "Cash payment",
                          icon: Icon(
                            Icons.north_east,
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
                              subtitle: Text("Paying account"),
                            ),
                            ListTile(
                              isThreeLine: true,
                              dense: true,
                              minTileHeight: 30,
                              leading: const Icon(Icons.payments_outlined),
                              title: const Text("US Dollar"),
                              subtitle: Text("Paid currency"),
                            ),
                            ListTile(
                              dense: true,
                              minTileHeight: 30,
                              leading: const Icon(Icons.pin_outlined),
                              title: const Text("2,345,566"),
                              subtitle: Text("Amount"),
                            ),
                            ListTile(
                              isThreeLine: true,
                              dense: true,
                              minTileHeight: 30,
                              leading: const Icon(Icons.person),
                              title: const Text("Faarah Warsame"),
                              subtitle: Text("Receiver"),
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
                            Divider(),
                            Gap(AppSizes.sm),
                            StatusText(label: "Cash paid", color: Colors.green),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),Gap(70),ShareOrDownloadButtons()
              ],
            ),
            ContinueButton(
                label: "Done",
                onPressed: () => Get.offAll(() => NavigationMenu()))
          ],
        ),
      ),
    );
  }
}
