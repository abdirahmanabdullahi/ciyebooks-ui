import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../../../common/custom_appbar.dart';
import '../../../utils/constants/colors.dart';
import '../../../utils/constants/sizes.dart';
import '../../dashboard/home.dart';
import '../widgets/acount_preview_tile.dart';
import '../widgets/continue_button.dart';

final _amountFormKey = GlobalKey<FormState>();

class AmountScreen extends StatelessWidget {
  const AmountScreen({
    super.key,
    required this.currencySelectorFieldLabel,
    required this.ownerCheckBoxLabel,
    required this.onPressed,
    required this.amountDepositedOrPaid,
  });
  final String currencySelectorFieldLabel,
      ownerCheckBoxLabel,
      amountDepositedOrPaid;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(
        showBackArrow: true,
        title: const Text("Select currency and amount"),
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
                  key: _amountFormKey,
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
                              currencySelectorFieldLabel,
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
                              amountDepositedOrPaid,
                              style: Theme.of(context).textTheme.labelMedium,
                            ),
                            filled: true,
                            fillColor: AppColors.quinary),
                      ),
                      Gap(AppSizes.spaceBtwInputFields),
                      Row(
                        children: [
                          SizedBox(
                            height: 25,
                            width: 25,
                            child:
                                Checkbox(value: false, onChanged: (value) {}),
                          ),
                          Gap(6),
                          Text(
                            ownerCheckBoxLabel,
                            style: Theme.of(context).textTheme.titleSmall,
                          )
                        ],
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
            ContinueButton(onPressed: onPressed)
          ],
        ),
      ),
    );
  }
}
