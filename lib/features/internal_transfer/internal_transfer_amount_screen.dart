import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import '../../../common/custom_appbar.dart';
import '../../../utils/constants/colors.dart';
import '../../../utils/constants/sizes.dart';

import '../common/widgets/acount_preview_tile.dart';
import '../common/widgets/continue_button.dart';
import '../dashboard/home.dart';
import 'internal_transfer_confirm_screen.dart';

class InternalTransferAmountScreen extends StatelessWidget {
  const InternalTransferAmountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(
        showBackArrow: true,
        title: const Text("Internal transfer"),
        actions: [
          IconButton(
              onPressed: () => Get.offAll(() => const Dashboard()),
              icon: const Icon(Icons.close))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppSizes.defaultSpace / 2),
        child: Column(
          // mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const AccountPreviewTile(),
                const Gap(AppSizes.spaceBtwItems),
                Form(
                  // key: _amountFormKey,
                  child: Column(
                    children: [
                      SizedBox(
                        // width: 100,
                        child: DropdownButtonFormField(
                          menuMaxHeight: 100,
                          // elevation: 3,
                          decoration: InputDecoration(
                            fillColor: AppColors.quinary,
                            filled: true,
                            label: Text(
                              "Select currency to transfer",
                              style: Theme.of(context).textTheme.labelMedium,
                            ),
                          ),
                          icon: const Icon(Icons.keyboard_arrow_down),
                          items: const [
                            DropdownMenuItem(
                              value: "USD",
                              child: Text("US dollar"),
                            ),
                            DropdownMenuItem(
                              value: "KES",
                              child: Text("Shilling"),
                            ),
                          ],
                          onChanged: (value) {},
                        ),
                      ),
                      const Gap(AppSizes.spaceBtwInputFields / 2),
                      TextFormField(
                        decoration: InputDecoration(
                            label: Text(
                              "Amount",
                              style: Theme.of(context).textTheme.labelMedium,
                            ),
                            filled: true,
                            fillColor: AppColors.quinary),
                      ),
                      const Gap(AppSizes.spaceBtwInputFields / 2),
                      SizedBox(
                        // width: 100,
                        child: DropdownButtonFormField(
                          menuMaxHeight: 100,
                          // elevation: 3,
                          decoration: InputDecoration(
                            fillColor: AppColors.quinary,
                            filled: true,
                            label: Text(
                              "Select receiving account",
                              style: Theme.of(context).textTheme.labelMedium,
                            ),
                          ),
                          icon: const Icon(Icons.keyboard_arrow_down),
                          items: const [
                            DropdownMenuItem(
                              value: "USD",
                              child: Text("Abdirahman Abdullahi "),
                            ),
                            DropdownMenuItem(
                              value: "KES",
                              child: Text("Faarah Cise Mohamed"),
                            ),
                          ],
                          onChanged: (value) {},
                        ),
                      ),
                    ],
                  ),
                ),
                Gap(AppSizes.spaceBtwInputFields),
                TextFormField(
                  maxLines: 5,
                  minLines: 5,
                  decoration: InputDecoration(
                      label: Text(
                        "Add description",
                        style: Theme.of(context).textTheme.labelMedium,
                      ),
                      filled: true,
                      fillColor: AppColors.quinary),
                ),
              ],
            ),
            ContinueButton(
              label: "Continue",
              onPressed: () => Get.to(
                () => InternalTransferConfirmScreen(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
