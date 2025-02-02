import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../common/custom_appbar.dart';
import '../../navigation_menu.dart';
import '../../utils/constants/colors.dart';
import '../../utils/constants/sizes.dart';
import 'account_preview.dart';

class AccountSearch extends StatelessWidget {
  const AccountSearch({super.key});

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
        title: const Text("Accounts"),
        // title: Text("Select receiving/paying account"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(6.0),
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Container(
              width: double.infinity,
              color: AppColors.quarternary,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 2, vertical: 12),
                child: SizedBox(height: 48,
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
            ),
            ListTile(
              isThreeLine: true,
              // contentPadding: EdgeInsets.all(10),
              titleAlignment: ListTileTitleAlignment.top,
              onTap: () => Get.to(() => AccountPreview()),
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
                  child: Text(
                    "AA",
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge!
                        .apply(color: Colors.blueAccent),
                  ),
                ),
              ),

              title: Text(
                "Abdirahman Abdullahi",
                style: Theme.of(context).textTheme.titleMedium,
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                            text: "Account no:   ",
                            style: Theme.of(context).textTheme.labelMedium),
                        TextSpan(
                            text: "234235235",
                            style: Theme.of(context).textTheme.labelMedium),
                      ],
                    ),
                  ),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                            text: "Currencies:   ",
                            style: Theme.of(context).textTheme.labelMedium),
                        TextSpan(
                            text: "KES, USD, EUR",
                            style: Theme.of(context).textTheme.labelMedium),
                      ],
                    ),
                  ),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                            text: "Status:           ",
                            style: Theme.of(context).textTheme.labelMedium),
                        TextSpan(
                            text: "USD Overdrawn",
                            style: Theme.of(context)
                                .textTheme
                                .labelMedium!
                                .apply(color: Colors.red)),
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
