
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../../common/custom_appbar.dart';
import '../../navigation_menu.dart';
import '../../utils/constants/colors.dart';
import '../../utils/constants/sizes.dart';
import '../common/widgets/continue_button.dart';
import 'account_confirm.dart';

class CreateAccounts extends StatelessWidget {
  const CreateAccounts({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(
        showBackArrow: true,
        title: Text("Create personal account"),
        actions: [
          IconButton(
            onPressed: () => Get.offAll(() => NavigationMenu()),
            icon: Icon(Icons.clear),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Form(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Profile",
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Gap(6),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        decoration: InputDecoration(
                            label: Text(
                              "First name",
                              style: Theme.of(context).textTheme.labelMedium,
                            ),
                            filled: true,
                            fillColor: AppColors.quinary),
                      ),
                    ),
                    Gap(6),
                    Expanded(
                      child: TextFormField(
                        decoration: InputDecoration(
                            label: Text(
                              "Last name",
                              style: Theme.of(context).textTheme.labelMedium,
                            ),
                            filled: true,
                            fillColor: AppColors.quinary),
                      ),
                    ),
                  ],
                ),
                Gap(6),
                TextFormField(
                  decoration: InputDecoration(
                      label: Text(
                        "Phone no ",
                        style: Theme.of(context).textTheme.labelMedium,
                      ),
                      filled: true,
                      fillColor: AppColors.quinary),
                ),
                Gap(6),
                TextFormField(
                  decoration: InputDecoration(
                      label: Text(
                        "Email",
                        style: Theme.of(context).textTheme.labelMedium,
                      ),
                      filled: true,
                      fillColor: AppColors.quinary),
                ),
                Gap(AppSizes.spaceBtwSections),
                Text(
                  "Currency balances",
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Gap(6),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        decoration: InputDecoration(
                            label: Text(
                              "USD balance",
                              style: Theme.of(context).textTheme.labelMedium,
                            ),
                            filled: true,
                            fillColor: AppColors.quinary),
                      ),
                    ),
                    Gap(6),
                    Expanded(
                      child: TextFormField(
                        decoration: InputDecoration(
                            label: Text(
                              "KES balance",
                              style: Theme.of(context).textTheme.labelMedium,
                            ),
                            filled: true,
                            fillColor: AppColors.quinary),
                      ),
                    ),
                  ],
                ),
              ],
            )),
            ContinueButton(
              label: "Continue",
              onPressed: () => Get.to(
                () => AccountConfirm(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
