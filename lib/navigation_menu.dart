import 'package:ciyebooks/data/repositories/auth/auth_repo.dart';
import 'package:ciyebooks/features/accounts/screens/widgets/create_account_form.dart';
import 'package:ciyebooks/features/bank/deposit/screens/widgets/deposit_form.dart';
import 'package:ciyebooks/features/bank/withdraw/screens/widgets/withdraw_form.dart';
import 'package:ciyebooks/features/dashboard/all_transactions.dart';
import 'package:ciyebooks/features/forex/ui/widgets/forex_form.dart';
import 'package:ciyebooks/features/pay/screens/expense/expense_form.dart';
import 'package:ciyebooks/features/pay/screens/payments/payment_form.dart';
import 'package:ciyebooks/features/receive/screens/widgets/receipt_form.dart';
import 'package:ciyebooks/features/stats/screens/stats_screen.dart';
import 'package:ciyebooks/utils/constants/colors.dart';
import 'package:ciyebooks/utils/constants/image_strings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import 'features/dashboard/home.dart';
import 'features/profile/profile.dart';

class NavigationMenu extends StatelessWidget {
  const NavigationMenu({super.key});

  @override
  Widget build(BuildContext context) {
    // final controller = Get.put(NavigationController());
    final authController = Get.put(AuthRepo());
    return Scaffold(
        // Add the Drawer here
        drawer: Drawer(
          backgroundColor: AppColors.quarternary,
          child: ListView(
            physics: ClampingScrollPhysics(),
            padding: EdgeInsets.zero,
            children: [
              const DrawerHeader(
                child: Image(
                  image: AssetImage(AppImages.logoDark),
                  height: 120,
                ),
              ),
              ListTile(
                textColor: AppColors.prettyDark,
                tileColor: AppColors.quinary,
                dense: true,
                title: const Text('Pay a client'),
                onTap: () { Navigator.pop(context);
                  showPaymentForm(context);
                  // ...
                },
              ),
              Gap(6),
              ListTile(
                textColor: AppColors.prettyDark,
                tileColor: AppColors.quinary,
                dense: true,
                title: const Text('Pay expense'),
                onTap: () { Navigator.pop(context);
                  showExpenseForm(context);
                  // ...
                },
              ),
              Gap(6),
              ListTile(
                textColor: AppColors.prettyDark,
                tileColor: AppColors.quinary,
                dense: true,
                title: const Text('Receive funds'),
                onTap: () { Navigator.pop(context);
                  showReceiptForm(context);
                  // ...
                },
              ),
              Gap(6),
              ListTile(
                textColor: AppColors.prettyDark,
                tileColor: AppColors.quinary,
                dense: true,
                title: const Text('Deposit cash at bank'),
                onTap: () { Navigator.pop(context);
                  showBankDepositForm(context);
                  // ...
                },
              ),
              Gap(6),
              ListTile(
                textColor: AppColors.prettyDark,
                tileColor: AppColors.quinary,
                dense: true,
                title: const Text('Withdraw cash from bank'),
                onTap: () { Navigator.pop(context);
                  showWithdrawForm(context);
                  // ...
                },
              ),              Gap(6),

              ListTile(
                textColor: AppColors.prettyDark,
                tileColor: AppColors.quinary,
                dense: true,
                title: const Text('Buy/sell forex'),
                onTap: () { Navigator.pop(context);
                  showForexForm(context);
                  // ...
                },
              ),
              Gap(6),
              ListTile(
                textColor: AppColors.prettyDark,
                tileColor: AppColors.quinary,
                dense: true,
                title: const Text('Create client account'),
                onTap: () { Navigator.pop(context);
                  showCreateAccountDialog(context);
                  // ...
                },
              ),
              Gap(6),
              ListTile(
                textColor: AppColors.prettyDark,
                tileColor: AppColors.quinary,
                dense: true,
                title: const Text('Recent transactions'),
                onTap: () { Navigator.pop(context);
                  Navigator.push(
                    context,
                    CupertinoPageRoute(builder: (context) => const TransactionHistory()),
                  );
                  // ...
                },
              ),
              Gap(6),
              ListTile(
                textColor: AppColors.prettyDark,
                tileColor: AppColors.quinary,
                dense: true,
                title: const Text('View report'),
                onTap: () {                  Navigator.pop(context);

                Navigator.push(
                    context,
                    CupertinoPageRoute(builder: (context) => const StatsScreen()),
                  );
                  // ...
                },
              ),              Gap(6),

              ListTile(
                textColor: AppColors.prettyDark,
                tileColor: AppColors.quinary,
                dense: true,
                title: const Text('Profile'),
                onTap: () { Navigator.pop(context);
                  Navigator.push(
                    context,
                    CupertinoPageRoute(builder: (context) => const Profile()),
                  );
                  // ...
                },
              ),
              Gap(30),
              SizedBox(width: double.maxFinite,
                height: 70,
                child: FloatingActionButton(elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                  backgroundColor: AppColors.quarternary,
                  onPressed: () async => await authController.logoutUser(),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 30.0),
                    child: Row(
                      children: [
                        Icon(
                          Icons.logout_outlined,
                          color: AppColors.prettyDark,
                        ),
                        Gap(20),
                        Text(
                          'Logout',
                          style: TextStyle(color: AppColors.prettyDark, fontSize: 16, fontWeight: FontWeight.w600),
                        )
                      ],
                    ),
                  ),
                ),
              ),         Gap(20),     ],
          ),
        ),
        // bottomNavigationBar: Obx(
        //   () => NavigationBarTheme(
        //     data: NavigationBarThemeData(
        //       labelTextStyle: WidgetStatePropertyAll(
        //         TextStyle(
        //           fontSize: 10,
        //           fontWeight: FontWeight.w600,
        //           color: AppColors.prettyDark,
        //         ),
        //       ),
        //     ),
        //     child: BottomNavigationBar(
        //       useLegacyColorScheme: false,
        //
        //       // animationDuration: Duration.zero,
        //       // indicatorColor: Colors.transparent,
        //       // backgroundColor: AppColors.quinary,
        //       // height: 60,
        //       currentIndex: controller.selectedIndex.value,
        //       onTap: (index) => controller.selectedIndex.value = index,
        //       elevation: 3,
        //       items: [
        //         BottomNavigationBarItem(
        //           icon: Icon(
        //             Icons.home_outlined,
        //             color: AppColors.prettyDark,
        //           ),
        //           label: 'Home',
        //           // selectedIcon: Icon(
        //           //   Icons.home,
        //           //   color: AppColors.prettyDark,
        //           // ),
        //         ),
        //         BottomNavigationBarItem(
        //           icon: Icon(
        //             Icons.home_outlined,
        //             color: AppColors.prettyDark,
        //           ),
        //           label: 'Home',
        //           // selectedIcon: Icon(
        //           //   Icons.home,
        //           //   color: AppColors.prettyDark,
        //           // ),
        //         ),
        //         BottomNavigationBarItem(
        //           icon: Icon(
        //             Icons.home_outlined,
        //             color: AppColors.prettyDark,
        //           ),
        //           label: 'Home',
        //           // selectedIcon: Icon(
        //           //   Icons.home,
        //           //   color: AppColors.prettyDark,
        //           // ),
        //         ),
        //         BottomNavigationBarItem(
        //           icon: Icon(
        //             Icons.home_outlined,
        //             color: AppColors.prettyDark,
        //           ),
        //           label: 'Home',
        //           // selectedIcon: Icon(
        //           //   Icons.home,
        //           //   color: AppColors.prettyDark,
        //           // ),
        //         ),
        //         BottomNavigationBarItem(
        //           icon: Icon(
        //             Icons.home_outlined,
        //             color: AppColors.prettyDark,
        //           ),
        //           label: 'Home',
        //           // selectedIcon: Icon(
        //           //   Icons.home,
        //           //   color: AppColors.prettyDark,
        //           // ),
        //         ),
        //         // NavigationDestination(
        //         //   icon: Icon(
        //         //     Icons.description_outlined,
        //         //     color: AppColors.prettyDark,
        //         //   ),
        //         //   label: 'Notes',
        //         //   selectedIcon: Icon(
        //         //     Icons.description,
        //         //     color: AppColors.prettyDark,
        //         //   ),
        //         // ),
        //         // NavigationDestination(
        //         //   icon: Icon(
        //         //     Icons.fact_check_outlined,
        //         //     color: AppColors.prettyDark,
        //         //   ),
        //         //   label: 'Todos',
        //         //   selectedIcon: Icon(
        //         //     Icons.fact_check,
        //         //     color: AppColors.prettyDark,
        //         //   ),
        //         // ),
        //         // NavigationDestination(
        //         //   icon: Icon(
        //         //     Icons.calculate_outlined,
        //         //     color: AppColors.prettyDark,
        //         //   ),
        //         //   label: 'Calc',
        //         //   selectedIcon: Icon(
        //         //     Icons.calculate,
        //         //     color: AppColors.prettyDark,
        //         //   ),
        //         // ),
        //         // NavigationDestination(
        //         //   icon: Icon(
        //         //     Icons.leaderboard_outlined,
        //         //     color: AppColors.prettyDark,
        //         //   ),
        //         //   label: 'Stats',
        //         //   selectedIcon: Icon(
        //         //     Icons.leaderboard,
        //         //     color: AppColors.prettyDark,
        //         //   ),
        //         // ),
        //       ],
        //     ),
        //   ),
        // ),
        // floatingActionButton: FloatingActionButton(backgroundColor:AppColors.prettyDark,elevation:0,onPressed: (){}),            floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,

        body: Dashboard()
        // Obx(
        //   () => controller.screens[controller.selectedIndex.value],
        // ),
        );
  }
}

class NavigationController extends GetxController {
  final Rx<int> selectedIndex = 0.obs;
  final screens = [
    const Dashboard(),
    // Notes(),
    // CalculatorScreen(),
    // StatsPage(),
  ];
}
