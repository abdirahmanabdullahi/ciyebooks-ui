import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../../../common/custom_appbar.dart';
import '../../../utils/constants/colors.dart';
import '../../../utils/constants/sizes.dart';
import '../../common/widgets/continue_button.dart';
import '../../dashboard/home.dart';
import 'buy_confirm_screen.dart';

class BuyAmountScreen extends StatelessWidget {
  const BuyAmountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(
        showBackArrow: true,
        title: const Text("Buy currency"),
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
                ListTile(
                  titleAlignment: ListTileTitleAlignment.titleHeight,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  enabled: true,
                  selected: true,
                  selectedTileColor: Colors.white,
                  leading: Container(
                    width: 35,
                    height: 35,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        border:
                            Border.all(width: 1, color: AppColors.darkGrey)),
                    child: Center(
                      child: Text(
                        "USD",
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: Colors.blueAccent),
                      ),
                    ),
                  ),
                  title: const Text(
                    "US Dollar",
                    style: TextStyle(
                        // fontFamily: "Oswald",
                        color: AppColors.prettyDark,
                        fontSize: 25,
                        height: 1.2),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Divider(),
                      Gap(AppSizes.spaceBtwInputFields / 2),
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: "Amount:  ",
                              style: Theme.of(context).textTheme.labelMedium,
                            ),
                            TextSpan(
                                text: "1,328.00",
                                style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 12,
                                    color: AppColors.prettyDark)),
                          ],
                        ),
                      ),
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: "Rate:        ",
                              style: Theme.of(context).textTheme.labelMedium,
                            ),
                            TextSpan(
                                text: "128.50",
                                style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 12,
                                    color: AppColors.prettyDark)),
                          ],
                        ),
                      ),
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: "Total:        ",
                              style: Theme.of(context).textTheme.labelMedium,
                            ),
                            TextSpan(
                                text: "170,648.00",
                                style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 12,
                                    color: AppColors.prettyDark)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const Gap(AppSizes.spaceBtwItems),
                Form(
                  // key: _amountFormKey,
                  child: Column(
                    children: [
                      TextFormField(
                        decoration: InputDecoration(
                            label: Text(
                              "Rate",
                              style: Theme.of(context).textTheme.labelMedium,
                            ),
                            filled: true,
                            fillColor: AppColors.quinary),
                      ),
                      Gap(AppSizes.spaceBtwInputFields),
                      TextFormField(
                        decoration: InputDecoration(
                            label: Text(
                              "Amount",
                              style: Theme.of(context).textTheme.labelMedium,
                            ),
                            filled: true,
                            fillColor: AppColors.quinary),
                      ),
                      const Gap(AppSizes.spaceBtwInputFields),
                      TextFormField(
                        decoration: InputDecoration(
                            label: Text(
                              "Total",
                              style: Theme.of(context).textTheme.labelMedium,
                            ),
                            filled: true,
                            fillColor: AppColors.quinary),
                      ),
                      const Gap(AppSizes.spaceBtwInputFields),
                    ],
                  ),
                ),
                TextFormField(
                  maxLines: 3,
                  minLines: 3,
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
                () => BuyConfirmScreen(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
