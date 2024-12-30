import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../../../common/custom_appbar.dart';
import '../../../navigation_menu.dart';
import '../../../utils/constants/colors.dart';
import '../../../utils/constants/sizes.dart';
import 'buy_amount_screen.dart';

class BuyAccountSelector extends StatelessWidget {
  const BuyAccountSelector({super.key});

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
        // leadingWidget: IconButton(
        //   onPressed: () {},
        //   icon: const Icon(Icons.clear),
        // ),
        title: Row(
          // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              onPressed: () {
                Get.defaultDialog(
                  backgroundColor: AppColors.quinary,
                  title: "Add new currency",
                  content: SizedBox(
                    width: 300,
                    child: DropdownButtonFormField(
                      menuMaxHeight: 100,
                      // elevation: 3,
                      decoration: InputDecoration(
                        fillColor: AppColors.quinary,
                        filled: true,
                        label: Text(
                          "Select currency",
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
                  confirm: MaterialButton(
                    onPressed: Get.back,
                    child: Text("OK"),
                  ),
                  cancel: MaterialButton(
                    onPressed: Get.back,
                    child: Text("Cancel"),
                  ),
                );
              },
              icon: Icon(Icons.add),
            ),
            Gap(85),
            Text("Buy currency"),
          ],
        ),
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
                enabled: true,
                selected: true,
                isThreeLine: false,
                contentPadding: EdgeInsets.fromLTRB(12, 4, 12, 0),
                titleAlignment: ListTileTitleAlignment.top,
                onTap: () => Get.to(() => BuyAmountScreen()),
                minVerticalPadding: 5,
                horizontalTitleGap: 15,
                dense: true,
                // isThreeLine: true,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),

                selectedTileColor: Colors.white,
                leading: Container(
                  width: 35,
                  height: 35,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(width: 1, color: AppColors.darkGrey)),
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
                trailing:
                    IconButton(onPressed: () {}, icon: Icon(Icons.more_horiz)),

                title: Text(
                  "US Dollar",
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
              )
            ],
          ),
        ),
      ),
    );
  }
}
