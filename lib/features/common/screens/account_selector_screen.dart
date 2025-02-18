import 'package:ciyebooks/features/pay/pay_client/pay_client_controller/pay_client_controller.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import '../../../common/custom_appbar.dart';
import '../../../common/styles/custom_container.dart';
import '../../../navigation_menu.dart';
import '../../../utils/constants/colors.dart';
import '../../../utils/constants/sizes.dart';
import '../widgets/acounts_tile.dart';

class AccountSelectorScreen extends StatelessWidget {
  const AccountSelectorScreen({
    super.key,
    this.accountTitle,
    this.onTilePressed,
  });
  final String? accountTitle;
  final VoidCallback? onTilePressed;

  @override
  Widget build(BuildContext context) {
    // final controller = Get.put(PayClientController());
    return Scaffold(
      appBar: CustomAppbar(
        actions: [IconButton(onPressed: () => Get.offAll(() => NavigationMenu()), icon: const Icon(Icons.clear))],
        // showBackArrow: true,
        leadingWidget: IconButton(
          onPressed: () {},
          icon: const Icon(Icons.clear),
        ),
        title: Text('wewerwe',style: TextStyle(color: AppColors.prettyDark),),
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
                padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 12),
                child: TextFormField(
                  // controller: controller.accountName,
                  decoration: const InputDecoration().copyWith(
                    filled: true,
                    fillColor: AppColors.quinary,
                    focusedBorder: const OutlineInputBorder().copyWith(
                      borderRadius: BorderRadius.circular(AppSizes.inputFieldRadius),
                      borderSide: const BorderSide(width: 1, color: Colors.blueAccent),
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
            // CustomContainer(
            //   height: 650,
            //   width: double.infinity,
            //   padding: EdgeInsets.zero,
            //   child: SingleChildScrollView(
            //     physics: ClampingScrollPhysics(),
            //     child: Column(
            //       children: controller.accounts.map((account) {
            //         if (account.fullName.isNotEmpty && account.fullName.contains(controller.accountName.text.trim())) {
            //           return Text(account.fullName);
            //         }
            //         return Text('');
            //       }).toList(),
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
