import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../common/custom_appbar.dart';
import '../../../navigation_menu.dart';
import '../../../utils/constants/colors.dart';
import '../../../utils/constants/sizes.dart';
import 'expense_amount.dart';

class ExpenseAccountSelector extends StatelessWidget {
  const ExpenseAccountSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(
        actions: [
          IconButton(
              onPressed: () => Get.offAll(NavigationMenu()),
              icon: const Icon(Icons.clear))
        ],
        leadingWidget: IconButton(
          onPressed: () {},
          icon: const Icon(Icons.clear),
        ),
        title: Text("Pay an expense"),
        // title: Text("Select receiving/paying account"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(6.0),
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
                        borderSide: const BorderSide(
                            width: 1, color: Colors.blueAccent),
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
              ListTile(
                onTap: () => Get.to(() => ExpenseAmount()),
                minVerticalPadding: 5,
                horizontalTitleGap: 10,
                dense: true,
                // isThreeLine: true,
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
                      border: Border.all(width: 1, color: AppColors.darkGrey)),
                  child: Center(
                      child: Icon(
                    Icons.directions_bus,
                    color: AppColors.prettyDark,
                  )),
                ),
                title: Text(
                  "Transport",
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                subtitle: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                          text: "Balance:   ",
                          style: Theme.of(context).textTheme.labelLarge),
                      TextSpan(
                          text: "123,3453:   ",
                          style: Theme.of(context).textTheme.bodyLarge),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
