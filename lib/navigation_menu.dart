import 'package:ciyebooks/data/repositories/auth/auth_repo.dart';
import 'package:ciyebooks/utils/constants/colors.dart';
import 'package:ciyebooks/utils/constants/image_strings.dart';
import 'package:ciyebooks/utils/constants/sizes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'features/calculator/calculator_screen.dart';
import 'features/common/widgets/acount_preview_tile.dart';
import 'features/dashboard/home.dart';
import 'features/notes/notes.dart';
import 'features/pay/pay_client/screens/pay_account_selector.dart';
import 'features/stats/stats.dart';
import 'features/todos/todos.dart';

class NavigationMenu extends StatelessWidget {
  const NavigationMenu({super.key});

  @override
  Widget build(BuildContext context) {
    // final dark = HelperFunctions.isDarkMode(context);
    final controller = Get.put(NavigationController());
    final authController = Get.put(AuthRepo());
    final no = controller.selectedIndex.value;
    return Scaffold(
      // Add the Drawer here
      drawer: Drawer(
        backgroundColor: AppColors.quarternary,
        child: ListView(
          physics: ClampingScrollPhysics(),
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              child: Column(
                children: [
                  Image(
                    image: AssetImage(AppImages.logoDark),
                    height: 100,
                  ),
                  Text(
                    'Ciye Books',
                    style: TextStyle(fontSize: 24, fontFamily: "Roboto"),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 3),
              child: Text('Main', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 9)),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6.0),
              child: ListTile(
                dense: true,
                tileColor: AppColors.quinary,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                leading: const Icon(
                  Icons.home_outlined,
                ),
                title: const Text('Home'),
                onTap: () {
                  // Navigate to Home
                  controller.selectedIndex.value = 0;
                  Get.back(); // Close the drawer
                },
              ),
            ),
            Gap(6),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6.0),
              child: ListTile(
                dense: true,
                tileColor: AppColors.quinary,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                leading: const Icon(Icons.description_outlined),
                title: const Text('Notes'),
                onTap: () {
                  // Navigate to Notes
                  controller.selectedIndex.value = 1;
                  Get.back(); // Close the drawer
                },
              ),
            ),
            Gap(6),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6.0),
              child: ListTile(
                dense: true,
                tileColor: AppColors.quinary,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                leading: const Icon(Icons.calculate_outlined),
                title: const Text('Todos'),
                onTap: () {
                  controller.selectedIndex.value = 2;
                  Get.back(); // C
                  Get.back(); // Close the drawer
                },
              ),
            ),
            Gap(6),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6.0),
              child: ListTile(
                dense: true,
                tileColor: AppColors.quinary,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                leading: const Icon(
                  Icons.settings,
                ),
                title: const Text(
                  'Calculator',
                ),
                onTap: () {
                  controller.selectedIndex.value = 3;
                  Get.back(); // C
                  Get.back(); // Close the drawer
                },
              ),
            ),
            Gap(6),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6.0),
              child: ListTile(
                tileColor: AppColors.quinary,
                dense: true,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                leading: const Icon(Icons.settings),
                title: const Text('Stats'),
                onTap: () {
                  controller.selectedIndex.value = 4;
                  Get.back(); // C
                },
              ),
            ),
            Divider(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 3),
              child: Text('Pay', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 9)),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6.0),
              child: ListTile(
                tileColor: AppColors.quinary,
                dense: true,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                leading: const Icon(Icons.settings),
                title: const Text('Pay client'),
                onTap: () {
                  Get.offAll(() => PayAccountSelector());
                  Get.back(); // C
                },
              ),
            ),
            Gap(6),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6.0),
              child: ListTile(
                tileColor: AppColors.quinary,
                dense: true,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                leading: const Icon(Icons.settings),
                title: const Text('Pay expense'),
                onTap: () {
                  Get.offAll(() => PayAccountSelector());
                  Get.back(); // C
                },
              ),
            ),
            Gap(6),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6.0),
              child: ListTile(
                tileColor: AppColors.quinary,
                dense: true,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                leading: const Icon(Icons.settings),
                title: const Text('Schedule a payment'),
                onTap: () {
                  Get.offAll(() => PayAccountSelector());
                  Get.back(); // C
                },
              ),
            ),
            Gap(6),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6.0),
              child: ListTile(
                tileColor: AppColors.quinary,
                dense: true,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                leading: const Icon(Icons.settings),
                title: const Text('Payment history'),
                onTap: () {
                  Get.offAll(() => PayAccountSelector());
                  Get.back(); // C
                },
              ),
            ),
            Divider(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 3),
              child: Text('Receive', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 9)),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6.0),
              child: ListTile(
                tileColor: AppColors.quinary,
                dense: true,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                leading: const Icon(Icons.settings),
                title: const Text('Receive funds from a client'),
                onTap: () {
                  Get.offAll(() => PayAccountSelector());
                  Get.back(); // C
                },
              ),
            ),
            Gap(6),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6.0),
              child: ListTile(
                tileColor: AppColors.quinary,
                dense: true,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                leading: const Icon(Icons.settings),
                title: const Text('Receipt history'),
                onTap: () {
                  Get.offAll(() => PayAccountSelector());
                  Get.back(); // C
                },
              ),
            ),
            Divider(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 3),
              child: Text('Bank', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 9)),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6.0),
              child: ListTile(
                tileColor: AppColors.quinary,
                dense: true,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                leading: const Icon(Icons.settings),
                title: const Text('Cash bank deposit'),
                onTap: () {
                  Get.offAll(() => PayAccountSelector());
                  Get.back(); // C
                },
              ),
            ),
            Gap(6),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6.0),
              child: ListTile(
                tileColor: AppColors.quinary,
                dense: true,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                leading: const Icon(Icons.settings),
                title: const Text('Withdraw cash'),
                onTap: () {
                  Get.offAll(() => PayAccountSelector());
                  Get.back(); // C
                },
              ),
            ),
            Gap(6),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6.0),
              child: ListTile(
                tileColor: AppColors.quinary,
                dense: true,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                leading: const Icon(Icons.settings),
                title: const Text('Deposit for client'),
                onTap: () {
                  Get.offAll(() => PayAccountSelector());
                  Get.back(); // C
                },
              ),
            ),
            Gap(6),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6.0),
              child: ListTile(
                tileColor: AppColors.quinary,
                dense: true,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                leading: const Icon(Icons.settings),
                title: const Text('Bank history'),
                onTap: () {
                  Get.offAll(() => PayAccountSelector());
                  Get.back(); // C
                },
              ),
            ),
            Divider(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 3),
              child: Text('Transfer', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 9)),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6.0),
              child: ListTile(
                tileColor: AppColors.quinary,
                dense: true,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                leading: const Icon(Icons.settings),
                title: const Text('Internal transfer'),
                onTap: () {
                  Get.offAll(() => PayAccountSelector());
                  Get.back(); // C
                },
              ),
            ),
            Gap(6),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6.0),
              child: ListTile(
                tileColor: AppColors.quinary,
                dense: true,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                leading: const Icon(Icons.settings),
                title: const Text('Bank transfer'),
                onTap: () {
                  Get.offAll(() => PayAccountSelector());
                  Get.back(); // C
                },
              ),
            ),
            Gap(6),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6.0),
              child: ListTile(
                tileColor: AppColors.quinary,
                dense: true,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                leading: const Icon(Icons.settings),
                title: const Text('Transfer history'),
                onTap: () {
                  Get.offAll(() => PayAccountSelector());
                  Get.back(); // C
                },
              ),
            ),
            Divider(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 3),
              child: Text('Forex', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 9)),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6.0),
              child: ListTile(
                tileColor: AppColors.quinary,
                dense: true,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                leading: const Icon(Icons.settings),
                title: const Text('Buy'),
                onTap: () {
                  Get.offAll(() => PayAccountSelector());
                  Get.back(); // C
                },
              ),
            ),
            Gap(6),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6.0),
              child: ListTile(
                tileColor: AppColors.quinary,
                dense: true,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                leading: const Icon(Icons.settings),
                title: const Text('Sell'),
                onTap: () {
                  Get.offAll(() => PayAccountSelector());
                  Get.back(); // C
                },
              ),
            ),
            Gap(6),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6.0),
              child: ListTile(
                tileColor: AppColors.quinary,
                dense: true,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                leading: const Icon(Icons.settings),
                title: const Text('New currency'),
                onTap: () {
                  Get.offAll(() => PayAccountSelector());
                  Get.back(); // C
                },
              ),
            ),
            Gap(6),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6.0),
              child: ListTile(
                tileColor: AppColors.quinary,
                dense: true,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                leading: const Icon(Icons.settings),
                title: const Text('Currency stock'),
                onTap: () {
                  Get.offAll(() => PayAccountSelector());
                  Get.back(); // C
                },
              ),
            ),
            Gap(6),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6.0),
              child: ListTile(
                tileColor: AppColors.quinary,
                dense: true,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                leading: const Icon(Icons.settings),
                title: const Text('Forex history'),
                onTap: () {
                  Get.offAll(() => PayAccountSelector());
                  Get.back(); // C
                },
              ),
            ),
            Divider(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 3),
              child: Text('Accounts', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 9)),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6.0),
              child: ListTile(
                tileColor: AppColors.quinary,
                dense: true,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                leading: const Icon(Icons.settings),
                title: const Text('Create new account'),
                onTap: () {
                  Get.offAll(() => PayAccountSelector());
                  Get.back(); // C
                },
              ),
            ),
            Gap(6),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6.0),
              child: ListTile(
                tileColor: AppColors.quinary,
                dense: true,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                leading: const Icon(Icons.settings),
                title: const Text('View accounts'),
                onTap: () {
                  Get.offAll(() => PayAccountSelector());
                  Get.back(); // C
                },
              ),
            ),
            Divider(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 3),
              child: Text('History', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 9)),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6.0),
              child: ListTile(
                tileColor: AppColors.quinary,
                dense: true,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                leading: const Icon(Icons.settings),
                title: const Text('Search transactions'),
                onTap: () {
                  Get.offAll(() => PayAccountSelector());
                  Get.back(); // C
                },
              ),
            ),
            Gap(40),
            SizedBox(
              height: 70,
              child: FloatingActionButton(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                  backgroundColor: AppColors.prettyDark,
                  onPressed: () => authController.logoutUser(),
                  child: Text(
                    "Logout",
                    style: Theme.of(context).textTheme.titleSmall!.apply(color: AppColors.quinary),
                  )),
            )
          ],
        ),
      ),
      bottomNavigationBar: Obx(
        () => NavigationBarTheme(
          data: NavigationBarThemeData(
            labelTextStyle: WidgetStatePropertyAll(
              TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: AppColors.prettyDark,
              ),
            ),
          ),
          child: BottomNavigationBar(
            useLegacyColorScheme: false,

            // animationDuration: Duration.zero,
            // indicatorColor: Colors.transparent,
            // backgroundColor: AppColors.quinary,
            // height: 60,
            currentIndex: controller.selectedIndex.value,
            onTap: (index) => controller.selectedIndex.value = index,
            elevation: 3,
            items: [
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.home_outlined,
                  color: AppColors.prettyDark,
                ),
                label: 'Home',
                // selectedIcon: Icon(
                //   Icons.home,
                //   color: AppColors.prettyDark,
                // ),
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.home_outlined,
                  color: AppColors.prettyDark,
                ),
                label: 'Home',
                // selectedIcon: Icon(
                //   Icons.home,
                //   color: AppColors.prettyDark,
                // ),
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.home_outlined,
                  color: AppColors.prettyDark,
                ),
                label: 'Home',
                // selectedIcon: Icon(
                //   Icons.home,
                //   color: AppColors.prettyDark,
                // ),
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.home_outlined,
                  color: AppColors.prettyDark,
                ),
                label: 'Home',
                // selectedIcon: Icon(
                //   Icons.home,
                //   color: AppColors.prettyDark,
                // ),
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.home_outlined,
                  color: AppColors.prettyDark,
                ),
                label: 'Home',
                // selectedIcon: Icon(
                //   Icons.home,
                //   color: AppColors.prettyDark,
                // ),
              ),
              // NavigationDestination(
              //   icon: Icon(
              //     Icons.description_outlined,
              //     color: AppColors.prettyDark,
              //   ),
              //   label: 'Notes',
              //   selectedIcon: Icon(
              //     Icons.description,
              //     color: AppColors.prettyDark,
              //   ),
              // ),
              // NavigationDestination(
              //   icon: Icon(
              //     Icons.fact_check_outlined,
              //     color: AppColors.prettyDark,
              //   ),
              //   label: 'Todos',
              //   selectedIcon: Icon(
              //     Icons.fact_check,
              //     color: AppColors.prettyDark,
              //   ),
              // ),
              // NavigationDestination(
              //   icon: Icon(
              //     Icons.calculate_outlined,
              //     color: AppColors.prettyDark,
              //   ),
              //   label: 'Calc',
              //   selectedIcon: Icon(
              //     Icons.calculate,
              //     color: AppColors.prettyDark,
              //   ),
              // ),
              // NavigationDestination(
              //   icon: Icon(
              //     Icons.leaderboard_outlined,
              //     color: AppColors.prettyDark,
              //   ),
              //   label: 'Stats',
              //   selectedIcon: Icon(
              //     Icons.leaderboard,
              //     color: AppColors.prettyDark,
              //   ),
              // ),
            ],
          ),
        ),
      ),
      // floatingActionButton: FloatingActionButton(backgroundColor:AppColors.prettyDark,elevation:0,onPressed: (){}),            floatingActionButtonLocation: FloatingActionButtonLocation.endContained,

      body: Obx(
        () => controller.screens[controller.selectedIndex.value],
      ),
    );
  }
}

class NavigationController extends GetxController {
  final Rx<int> selectedIndex = 0.obs;
  final screens = [
    const Dashboard(),
    Notes(),
    Todo(),
    CalculatorScreen(),
    StatsPage(),
  ];
}

class Testing extends StatelessWidget {
  const Testing({super.key});

  @override
  Widget build(BuildContext context) {
    final NumberFormat formatter = NumberFormat.decimalPatternDigits();
    final ButtonLabelsList = ['9',8,7,6,5,4,3,2,1,0,];

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const AccountPreviewTile(),
            Gap(6),
            Padding(
              padding: const EdgeInsets.all(3.0),
              child: DropdownButtonFormField(
                menuMaxHeight: 100,
                // elevation: 3,
                decoration: InputDecoration(
                  fillColor: AppColors.quinary,
                  filled: true,
                  label: Text(
                    'Select currency',
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
            TextFormField(
              textAlign: TextAlign.center,
              showCursor: false,
              style: TextStyle(fontSize: 40, fontWeight: FontWeight.w600, color: CupertinoColors.activeGreen),
              inputFormatters: [LengthLimitingTextInputFormatter(10), FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$'))],
              decoration: InputDecoration(
                fillColor: AppColors.quinary,
                border: const OutlineInputBorder().copyWith(
                  borderSide: const BorderSide(
                    color: AppColors.quarternary,
                    width: 0,
                  ),
                ),
                enabledBorder: const OutlineInputBorder().copyWith(
                  borderRadius: BorderRadius.circular(AppSizes.inputFieldRadius),
                  borderSide: const BorderSide(
                    color: AppColors.quarternary,
                    width: 0,
                  ),
                ),
                focusedBorder: const OutlineInputBorder().copyWith(
                  borderSide: const BorderSide(
                    color: AppColors.quarternary,
                    width: 0,
                  ),
                ),
              ),
            ),
            Wrap(
              children: [],
            )
          ],
        ),
      ),
    );
  }
}
