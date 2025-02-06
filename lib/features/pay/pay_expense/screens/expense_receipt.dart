
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/custom_appbar.dart';
import '../../../../common/styles/custom_container.dart';
import '../../../../navigation_menu.dart';
import '../../../../utils/constants/colors.dart';
import '../../../common/widgets/amount_and_receipt_tile_header.dart';
import '../../../common/widgets/continue_button.dart';
import '../../../common/widgets/share_or_download_buttons.dart';
import '../../../common/widgets/status_text.dart';

class ExpenseReceipt extends StatelessWidget {
  const ExpenseReceipt({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(
        actions: [
          IconButton(
              onPressed: () => Get.offAll(() => NavigationMenu()),
              icon: Icon(Icons.clear))
        ],
        title: Text("Expense receipt"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomContainer(
              darkColor: AppColors.quinary,
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  const AmountAndReceiptTileHeader(
                    title: "Expense receipt",
                    icon: Icon(
                      Icons.credit_card,
                      color: AppColors.quinary,
                    ),
                  ),
                  const Divider(
                    indent: 47,
                  ),
                  ListTile(
                    leading: Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          border:
                              Border.all(width: 1, color: AppColors.darkGrey)),
                      child: Center(
                        child: Icon(Icons.directions_bus),
                      ),
                    ),
                    contentPadding: const EdgeInsets.only(left: 47),
                    isThreeLine: true,
                    dense: true,
                    title: const Text("Transport"),
                    subtitle: const Text("Expense type"),
                  ),
                  ListTile(
                    // leading: Icon(Icons.directions_bus),
                    contentPadding: const EdgeInsets.only(left: 92),
                    isThreeLine: true,
                    dense: true,
                    title: const Text("KES"),
                    subtitle: const Text("Currency"),
                  ),
                  ListTile(
                    // leading: Icon(Icons.directions_bus),
                    contentPadding: const EdgeInsets.only(left: 92),
                    isThreeLine: true,
                    dense: true,
                    title: const Text("568.00"),
                    subtitle: const Text("Amount"),
                  ),
                  const ListTile(
                    contentPadding: EdgeInsets.only(left: 92),
                    isThreeLine: true,
                    dense: true,
                    minTileHeight: 30,
                    title: Text("2/3/2024  1:42 pm"),
                    subtitle: Text("Date"),
                  ),
                  Divider(
                      // indent: 47,
                      ),
                  StatusText(
                    label: "Expense paid",
                    color: Colors.green,
                  )
                ],
              ),
            ),
            ShareOrDownloadButtons(),
            ContinueButton(
              label: "Done",
              onPressed: () => Get.offAll(() => NavigationMenu()),
            ),
          ],
        ),
      ),
    );
  }
}
