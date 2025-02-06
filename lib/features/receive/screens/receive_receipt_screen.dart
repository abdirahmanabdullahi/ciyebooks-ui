
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import '../../../../common/custom_appbar.dart';
import '../../../../common/styles/custom_container.dart';
import '../../../../navigation_menu.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/sizes.dart';
import '../../common/widgets/amount_and_receipt_tile_header.dart';
import '../../common/widgets/continue_button.dart';
import '../../common/widgets/status_text.dart';

class ReceiveReceiptScreen extends StatelessWidget {
  const ReceiveReceiptScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(
        title: Text(
          "Cash deposit receipt",
        ),
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
                          title: "Cash deposit",
                          icon: Icon(
                            Icons.arrow_downward,
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
                            const ListTile(
                              dense: true,
                              minTileHeight: 30,
                              leading: Icon(Icons.person_outline),
                              title: Text("Abdirahman Abdullahi Abdi"),
                              subtitle: Text("accountLabel"),
                            ),
                            const ListTile(
                              isThreeLine: true,
                              dense: true,
                              minTileHeight: 30,
                              leading: Icon(Icons.payments_outlined),
                              title: Text("US Dollar"),
                              subtitle: Text("currencySubtitle"),
                            ),
                            const ListTile(
                              dense: true,
                              minTileHeight: 30,
                              leading: Icon(Icons.pin_outlined),
                              title: Text("2,345,566"),
                              subtitle: Text("amountSubtitle"),
                            ),
                            const ListTile(
                              // isThreeLine: true,

                              dense: true,
                              minTileHeight: 30,
                              leading: Icon(Icons.payments_outlined),
                              title: Text("Faarah Warsame"),
                              subtitle: Text("receiverOrDepositor"),
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
                            const Gap(AppSizes.sm),
                            const Divider(),
                            const Gap(AppSizes.sm),
                            StatusText(
                                label: "Cash deposited", color: Colors.green)
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
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
