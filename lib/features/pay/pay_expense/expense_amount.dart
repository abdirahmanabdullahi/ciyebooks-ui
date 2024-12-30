
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../../../common/custom_appbar.dart';
import '../../../navigation_menu.dart';
import '../../../utils/constants/colors.dart';
import '../../../utils/constants/sizes.dart';
import '../../common/widgets/continue_button.dart';
import 'confirm_expense.dart';

class ExpenseAmount extends StatelessWidget {
  const ExpenseAmount({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(
        showBackArrow: true,
        title: Text("Pay expense"),
        actions: [
          IconButton(
              onPressed: () => Get.offAll(() => NavigationMenu()),
              icon: Icon(Icons.clear))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8),
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
                        child: Icon(
                      Icons.directions_bus,
                      color: AppColors.prettyDark,
                    )),
                  ),
                  title: const Text(
                    "Transport ",
                    style: TextStyle(
                        // fontFamily: "Oswald",
                        color: AppColors.prettyDark,
                        fontSize: 25,
                        height: 1.2),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Divider(),
                      RichText(
                        text: TextSpan(
                          children: <TextSpan>[
                            TextSpan(
                              text: "Currency:    ",
                              style: Theme.of(context).textTheme.labelMedium,
                            ),
                            TextSpan(
                              text: "KES",
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
                              text: "Balance:    ",
                              style: Theme.of(context).textTheme.labelMedium,
                            ),
                            TextSpan(
                              text: "123,345",
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
                Gap(AppSizes.spaceBtwItems),
                Form(
                  // key: _amountFormKey,
                  child: Column(
                    children: [
                      TextFormField(
                        decoration: InputDecoration(
                            label: Text(
                              "Amount paid",
                              style: Theme.of(context).textTheme.labelMedium,
                            ),
                            filled: true,
                            fillColor: AppColors.quinary),
                      ),
                    ],
                  ),
                ),
                Gap(AppSizes.spaceBtwInputFields / 2),
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
            ContinueButton(onPressed: () => Get.to(() => ConfirmExpense())),
          ],
        ),
      ),
    );
  }
}
