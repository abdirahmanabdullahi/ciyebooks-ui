
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../../common/custom_appbar.dart';
import '../../common/styles/custom_container.dart';
import '../../navigation_menu.dart';
import '../../utils/constants/colors.dart';
import '../../utils/constants/sizes.dart';
import '../common/widgets/amount_and_receipt_tile_header.dart';
import '../common/widgets/continue_button.dart';
import '../common/widgets/status_text.dart';
import 'account_statement.dart';

class AccountPreview extends StatelessWidget {
  const AccountPreview({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(
        actions: [
          IconButton(
              onPressed: () => Get.to(() => NavigationMenu()),
              icon: Icon(Icons.clear))
        ],
        title: Text("Account preview"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppSizes.spaceBtwItems / 2),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomContainer(
              darkColor: AppColors.quinary,
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const AmountAndReceiptTileHeader(
                      title: "Abdirahman Abdullahi",
                      icon: Icon(
                        Icons.person,
                        color: AppColors.quinary,
                      )),
                  const Divider(
                    indent: 47,
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(44, 8, 6, 6),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const ListTile(
                          dense: true,
                          minTileHeight: 30,
                          leading: Icon(Icons.person_outline),
                          title: Text("3454567"),
                          subtitle: Text("Account number"),
                        ),
                        const ListTile(
                          dense: true,
                          minTileHeight: 30,
                          leading: Icon(Icons.calendar_month_outlined),
                          title: Text("12/3/2023"),
                          subtitle: Text("Date created"),
                        ),
                        const ListTile(
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
                          title: Text("Abdiciye2@gmail.com"),
                          subtitle: Text("Email"),
                        ),
                        const ListTile(
                          dense: true,
                          minTileHeight: 30,
                          leading: Icon(Icons.account_balance_wallet_outlined),
                          title: Text("2,345,566"),
                          subtitle: Text("USD balance"),
                        ),
                        const ListTile(
                          dense: true,
                          minTileHeight: 30,
                          leading: Icon(Icons.account_balance_wallet_outlined),
                          title: Text("-2,345,566"),
                          subtitle: Text("KES balance"),
                        ),
                        Gap(AppSizes.sm),
                      ],
                    ),
                  ),
                  const Divider(
                      // indent: 17,
                      ),
                  Gap(AppSizes.sm),
                  StatusText(label: "KES overdrawn", color: Colors.red)
                ],
              ),
            ),
            ContinueButton(
                label: "View statement",
                onPressed: () => Get.to(() => AccountStatement()))
          ],
        ),
      ),
    );
    // Gap(AppSizes.spaceBtwSections),
    // ContinueButton(label: "View account statement", onPressed: () {}),);
  }
}
