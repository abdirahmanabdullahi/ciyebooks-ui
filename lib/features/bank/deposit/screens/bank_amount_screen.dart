
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../../../../common/custom_appbar.dart';
import '../../../../navigation_menu.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../common/widgets/continue_button.dart';
import 'bank_deposit_confirm_screen.dart';

class BankAmountScreen extends StatelessWidget {
  const BankAmountScreen({super.key});

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
        title: const Text("Account preview"),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(12.0, 24, 12, 0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
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
                        "AA",
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge!
                            .apply(color: Colors.blueAccent),
                      ),
                    ),
                  ),
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Equity",
                        style: TextStyle(
                            // fontFamily: "Oswald",
                            color: AppColors.prettyDark,
                            fontSize: 25,
                            height: 1.2),
                      ),
                    ],
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Divider(),
                      RichText(
                        text: TextSpan(
                          children: <TextSpan>[
                            TextSpan(
                              text: "Account no:    ",
                              style: Theme.of(context).textTheme.labelMedium,
                            ),
                            TextSpan(
                              text: "23436467867",
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium!
                                  .apply(color: AppColors.darkGrey),
                            ),
                          ],
                        ),
                      ),
                      RichText(
                        text: TextSpan(
                          children: <TextSpan>[
                            TextSpan(
                              text: "Account name :       ",
                              style: Theme.of(context).textTheme.labelMedium,
                            ),
                            TextSpan(
                              text: "Abdifatah",
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium!
                                  .apply(color: AppColors.darkGrey),
                            ),
                          ],
                        ),
                      ),
                      RichText(
                        text: TextSpan(
                          children: <TextSpan>[
                            TextSpan(
                              text: "Account currency:  ",
                              style: Theme.of(context).textTheme.labelMedium,
                            ),
                            TextSpan(
                              text: "USD",
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium!
                                  .apply(color: AppColors.darkGrey),
                            ),
                          ],
                        ),
                      ),
                      RichText(
                        text: TextSpan(
                          children: <TextSpan>[
                            TextSpan(
                              text: "Balance:   ",
                              style: Theme.of(context).textTheme.labelMedium,
                            ),
                            TextSpan(
                              text: "45,567",
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium!
                                  .apply(color: AppColors.darkGrey),
                            ),
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
                      const Gap(AppSizes.spaceBtwInputFields / 2),
                      TextFormField(
                        decoration: InputDecoration(
                            label: Text(
                              "Amount deposited",
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
                            "Deposited by owner",
                            style: Theme.of(context).textTheme.titleSmall,
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                Gap(AppSizes.spaceBtwInputFields),
                TextFormField(
                  decoration: InputDecoration(
                      label: Text(
                        "Deposited by",
                        style: Theme.of(context).textTheme.labelMedium,
                      ),
                      filled: true,
                      fillColor: AppColors.quinary),
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
                onPressed: () => Get.to(() => BankDepositConfirmScreen()))
          ],
        ),
      ),
    );
  }
}
