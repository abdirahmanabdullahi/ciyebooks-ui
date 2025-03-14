
import 'package:ciyebooks/features/bank/withdraw/screens/withdraw_amount_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/custom_appbar.dart';
import '../../../../navigation_menu.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../common/widgets/acounts_tile.dart';

class WithdrawAccountSelector extends StatelessWidget {
  const WithdrawAccountSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(
        actions: [
          IconButton(
              onPressed: () => Get.offAll(() => NavigationMenu()),
              icon: const Icon(Icons.clear))
        ],
        showBackArrow: true,
        leadingWidget: IconButton(
          onPressed: () {},
          icon: const Icon(Icons.clear),
        ),
        title: const Text("Withdraw cash"),
        // title: Text("Select receiving/paying account"),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              color: AppColors.quarternary,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                child: TextFormField(
                  autofocus: true,
                  decoration: const InputDecoration().copyWith(
                    filled: true,
                    fillColor: AppColors.quinary,
                    focusedBorder: const OutlineInputBorder().copyWith(
                      borderRadius:
                          BorderRadius.circular(AppSizes.inputFieldRadius),
                      borderSide:
                          const BorderSide(width: 1, color: Colors.blueAccent),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    isDense: true,
                    suffixIcon: const Icon(
                      Icons.search,
                      size: 25,
                      color: Colors.blueAccent,
                    ),
                    label: const Text("Search account"),
                  ),
                ),
              ),
            ),
            AccountsTile(
              onPressedAccountTile: () => Get.to(() => WithdrawAmountScreen()),
              accountName: 'Abdirahman Abdullahi',
              initials: 'AA',
              accountNo: '123,234',
              currency: 'USD',
            ),
          ],
        ),
      ),
    );
  }
}
