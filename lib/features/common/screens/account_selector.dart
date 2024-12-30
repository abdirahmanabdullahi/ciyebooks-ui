import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import '../../../common/custom_appbar.dart';
import '../../../common/styles/custom_container.dart';
import '../../../navigation_menu.dart';
import '../../../utils/constants/colors.dart';
import '../../../utils/constants/sizes.dart';
import '../widgets/acounts_tile.dart';

class AccountSelector extends StatelessWidget {
  const AccountSelector({
    super.key,
    required this.accountTitle,
    required this.onTilePressed,
  });
  final String accountTitle;
  final VoidCallback onTilePressed;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(
        actions: [
          IconButton(
              onPressed: () => Get.offAll(() => NavigationMenu()),
              icon: const Icon(Icons.clear))
        ],
        // showBackArrow: true,
        leadingWidget: IconButton(
          onPressed: () {},
          icon: const Icon(Icons.clear),
        ),
        title: Text(accountTitle),
        // title: Text("Select receiving/paying account"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              color: AppColors.quarternary,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 2, vertical: 12),
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
            CustomContainer(
              height: 650,
              width: double.infinity,
              padding: EdgeInsets.zero,
              child: SingleChildScrollView(physics: ClampingScrollPhysics(),
                child: Column(
                  children: [
                    AccountsTile(
                      onPressedAccountTile: onTilePressed,
                      accountName: 'Abdirahman Abdullahi',
                      initials: 'AA',
                      accountNo: '142135345',
                      currency: 'KES,EUR,USD',
                    ),
                    Gap(6),
                    AccountsTile(
                      onPressedAccountTile: onTilePressed,
                      accountName: 'Abdirahman Abdullahi',
                      initials: 'AA',
                      accountNo: '142135345',
                      currency: 'KES,EUR,USD',
                    ),
                    Gap(6),
                    AccountsTile(
                      onPressedAccountTile: onTilePressed,
                      accountName: 'Abdirahman Abdullahi',
                      initials: 'AA',
                      accountNo: '142135345',
                      currency: 'KES,EUR,USD',
                    ),
                    Gap(6),
                    AccountsTile(
                      onPressedAccountTile: onTilePressed,
                      accountName: 'Abdirahman Abdullahi',
                      initials: 'AA',
                      accountNo: '142135345',
                      currency: 'KES,EUR,USD',
                    ),
                    Gap(6),
                    AccountsTile(
                      onPressedAccountTile: onTilePressed,
                      accountName: 'Abdirahman Abdullahi',
                      initials: 'AA',
                      accountNo: '142135345',
                      currency: 'KES,EUR,USD',
                    ),
                    Gap(6),
                    AccountsTile(
                      onPressedAccountTile: onTilePressed,
                      accountName: 'Abdirahman Abdullahi',
                      initials: 'AA',
                      accountNo: '142135345',
                      currency: 'KES,EUR,USD',
                    ),
                    Gap(6),
                    AccountsTile(
                      onPressedAccountTile: onTilePressed,
                      accountName: 'Abdirahman Abdullahi',
                      initials: 'AA',
                      accountNo: '142135345',
                      currency: 'KES,EUR,USD',
                    ),
                    Gap(6),
                    AccountsTile(
                      onPressedAccountTile: onTilePressed,
                      accountName: 'Abdirahman Abdullahi',
                      initials: 'AA',
                      accountNo: '142135345',
                      currency: 'KES,EUR,USD',
                    ),
                    Gap(6),
                    AccountsTile(
                      onPressedAccountTile: onTilePressed,
                      accountName: 'Abdirahman Abdullahi',
                      initials: 'AA',
                      accountNo: '142135345',
                      currency: 'KES,EUR,USD',
                    ),
                    Gap(6),
                    AccountsTile(
                      onPressedAccountTile: onTilePressed,
                      accountName: 'Abdirahman Abdullahi',
                      initials: 'AA',
                      accountNo: '142135345',
                      currency: 'KES,EUR,USD',
                    ),
                    Gap(6),
                    AccountsTile(
                      onPressedAccountTile: onTilePressed,
                      accountName: 'Abdirahman Abdullahi',
                      initials: 'AA',
                      accountNo: '142135345',
                      currency: 'KES,EUR,USD',
                    ),
                    Gap(6),
                    AccountsTile(
                      onPressedAccountTile: onTilePressed,
                      accountName: 'Abdirahman Abdullahi',
                      initials: 'AA',
                      accountNo: '142135345',
                      currency: 'KES,EUR,USD',
                    ),
                    Gap(6),
                    AccountsTile(
                      onPressedAccountTile: onTilePressed,
                      accountName: 'Abdirahman Abdullahi',
                      initials: 'AA',
                      accountNo: '142135345',
                      currency: 'KES,EUR,USD',
                    ),
                    Gap(6),
                    AccountsTile(
                      onPressedAccountTile: onTilePressed,
                      accountName: 'Abdirahman Abdullahi',
                      initials: 'AA',
                      accountNo: '142135345',
                      currency: 'KES,EUR,USD',
                    ),
                    Gap(6),
                    AccountsTile(
                      onPressedAccountTile: onTilePressed,
                      accountName: 'Abdirahman Abdullahi',
                      initials: 'AA',
                      accountNo: '142135345',
                      currency: 'KES,EUR,USD',
                    ),
                    Gap(6),
                    AccountsTile(
                      onPressedAccountTile: onTilePressed,
                      accountName: 'Abdirahman Abdullahi',
                      initials: 'AA',
                      accountNo: '142135345',
                      currency: 'KES,EUR,USD',
                    ),
                    Gap(6),
                    AccountsTile(
                      onPressedAccountTile: onTilePressed,
                      accountName: 'Abdirahman Abdullahi',
                      initials: 'AA',
                      accountNo: '142135345',
                      currency: 'KES,EUR,USD',
                    ),
                    Gap(6),
                    AccountsTile(
                      onPressedAccountTile: onTilePressed,
                      accountName: 'Abdirahman Abdullahi',
                      initials: 'AA',
                      accountNo: '142135345',
                      currency: 'KES,EUR,USD',
                    ),
                    Gap(6),
                    AccountsTile(
                      onPressedAccountTile: onTilePressed,
                      accountName: 'Abdirahman Abdullahi',
                      initials: 'AA',
                      accountNo: '142135345',
                      currency: 'KES,EUR,USD',
                    ),
                    Gap(6),
                    AccountsTile(
                      onPressedAccountTile: onTilePressed,
                      accountName: 'Abdirahman Abdullahi',
                      initials: 'AA',
                      accountNo: '142135345',
                      currency: 'KES,EUR,USD',
                    ),
                    Gap(6),
                    AccountsTile(
                      onPressedAccountTile: onTilePressed,
                      accountName: 'Abdirahman Abdullahi',
                      initials: 'AA',
                      accountNo: '142135345',
                      currency: 'KES,EUR,USD',
                    ),
                    Gap(6),
                    AccountsTile(
                      onPressedAccountTile: onTilePressed,
                      accountName: 'Abdirahman Abdullahi',
                      initials: 'AA',
                      accountNo: '142135345',
                      currency: 'KES,EUR,USD',
                    ),
                    Gap(6),
                    AccountsTile(
                      onPressedAccountTile: onTilePressed,
                      accountName: 'Abdirahman Abdullahi',
                      initials: 'AA',
                      accountNo: '142135345',
                      currency: 'KES,EUR,USD',
                    ),
                    Gap(6),
                    AccountsTile(
                      onPressedAccountTile: onTilePressed,
                      accountName: 'Abdirahman Abdullahi',
                      initials: 'AA',
                      accountNo: '142135345',
                      currency: 'KES,EUR,USD',
                    ),
                    Gap(6),
                    AccountsTile(
                      onPressedAccountTile: onTilePressed,
                      accountName: 'Abdirahman Abdullahi',
                      initials: 'AA',
                      accountNo: '142135345',
                      currency: 'KES,EUR,USD',
                    ),
                    Gap(6),
                    AccountsTile(
                      onPressedAccountTile: onTilePressed,
                      accountName: 'Abdirahman Abdullahi',
                      initials: 'AA',
                      accountNo: '142135345',
                      currency: 'KES,EUR,USD',
                    ),
                    Gap(6),
                    AccountsTile(
                      onPressedAccountTile: onTilePressed,
                      accountName: 'Abdirahman Abdullahi',
                      initials: 'AA',
                      accountNo: '142135345',
                      currency: 'KES,EUR,USD',
                    ),
                    Gap(6),
                    AccountsTile(
                      onPressedAccountTile: onTilePressed,
                      accountName: 'Abdirahman Abdullahi',
                      initials: 'AA',
                      accountNo: '142135345',
                      currency: 'KES,EUR,USD',
                    ),
                    Gap(6),
                    AccountsTile(
                      onPressedAccountTile: onTilePressed,
                      accountName: 'Abdirahman Abdullahi',
                      initials: 'AA',
                      accountNo: '142135345',
                      currency: 'KES,EUR,USD',
                    ),
                    Gap(6),
                    AccountsTile(
                      onPressedAccountTile: onTilePressed,
                      accountName: 'Abdirahman Abdullahi',
                      initials: 'AA',
                      accountNo: '142135345',
                      currency: 'KES,EUR,USD',
                    ),
                    Gap(6),
                    AccountsTile(
                      onPressedAccountTile: onTilePressed,
                      accountName: 'Abdirahman Abdullahi',
                      initials: 'AA',
                      accountNo: '142135345',
                      currency: 'KES,EUR,USD',
                    ),
                    Gap(6),
                    AccountsTile(
                      onPressedAccountTile: onTilePressed,
                      accountName: 'Abdirahman Abdullahi',
                      initials: 'AA',
                      accountNo: '142135345',
                      currency: 'KES,EUR,USD',
                    ),
                    Gap(6),
                    AccountsTile(
                      onPressedAccountTile: onTilePressed,
                      accountName: 'Abdirahman Abdullahi',
                      initials: 'AA',
                      accountNo: '142135345',
                      currency: 'KES,EUR,USD',
                    ),
                    Gap(6),
                    AccountsTile(
                      onPressedAccountTile: onTilePressed,
                      accountName: 'Abdirahman Abdullahi',
                      initials: 'AA',
                      accountNo: '142135345',
                      currency: 'KES,EUR,USD',
                    ),
                    Gap(6),
                    AccountsTile(
                      onPressedAccountTile: onTilePressed,
                      accountName: 'Abdirahman Abdullahi',
                      initials: 'AA',
                      accountNo: '142135345',
                      currency: 'KES,EUR,USD',
                    ),
                    Gap(6),
                    AccountsTile(
                      onPressedAccountTile: onTilePressed,
                      accountName: 'Abdirahman Abdullahi',
                      initials: 'AA',
                      accountNo: '142135345',
                      currency: 'KES,EUR,USD',
                    ),
                    Gap(6),
                    AccountsTile(
                      onPressedAccountTile: onTilePressed,
                      accountName: 'Abdirahman Abdullahi',
                      initials: 'AA',
                      accountNo: '142135345',
                      currency: 'KES,EUR,USD',
                    ),
                    Gap(6),
                    AccountsTile(
                      onPressedAccountTile: onTilePressed,
                      accountName: 'Abdirahman Abdullahi',
                      initials: 'AA',
                      accountNo: '142135345',
                      currency: 'KES,EUR,USD',
                    ),
                    Gap(6),
                    AccountsTile(
                      onPressedAccountTile: onTilePressed,
                      accountName: 'Abdirahman Abdullahi',
                      initials: 'AA',
                      accountNo: '142135345',
                      currency: 'KES,EUR,USD',
                    ),
                    Gap(6),
                    AccountsTile(
                      onPressedAccountTile: onTilePressed,
                      accountName: 'Abdirahman Abdullahi',
                      initials: 'AA',
                      accountNo: '142135345',
                      currency: 'KES,EUR,USD',
                    ),
                    Gap(6),
                    AccountsTile(
                      onPressedAccountTile: onTilePressed,
                      accountName: 'Abdirahman Abdullahi',
                      initials: 'AA',
                      accountNo: '142135345',
                      currency: 'KES,EUR,USD',
                    ),
                    Gap(6),
                    AccountsTile(
                      onPressedAccountTile: onTilePressed,
                      accountName: 'Abdirahman Abdullahi',
                      initials: 'AA',
                      accountNo: '142135345',
                      currency: 'KES,EUR,USD',
                    ),
                    Gap(6),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
