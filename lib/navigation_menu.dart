import 'package:ciyebooks/data/repositories/auth/auth_repo.dart';
import 'package:ciyebooks/utils/constants/colors.dart';
import 'package:ciyebooks/utils/constants/image_strings.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import 'features/calculator/calculator_screen.dart';
import 'features/dashboard/home.dart';
import 'features/notes/notes.dart';
import 'features/todos/todos.dart';

class NavigationMenu extends StatelessWidget {
  const NavigationMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(NavigationController());
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
                child: Column(

                  children: [
                    Image(
                      image: AssetImage(AppImages.logoDark),
                      height: 120,
                    ),
                  ],
                ),
              ),
              SizedBox(
                child: Column(mainAxisAlignment: MainAxisAlignment.spaceBetween,mainAxisSize: MainAxisSize.max,
                  children: [SizedBox(height: double.maxFinite,),
                    SizedBox(width: double.maxFinite,
                      height: 70,
                      child: FloatingActionButton(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                        backgroundColor: AppColors.prettyBlue,
                        onPressed: () => authController.logoutUser(),
                        child: Row(
                          children: [
                            Icon(
                              Icons.logout_outlined,
                              color: AppColors.quinary,
                            ),
                            Gap(20),
                            Text(
                              'Logout',
                              style: TextStyle(color: AppColors.quinary, fontSize: 16, fontWeight: FontWeight.w600),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
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
