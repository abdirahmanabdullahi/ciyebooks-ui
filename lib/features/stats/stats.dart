import 'package:ciyebooks/navigation_menu.dart';
import 'package:ciyebooks/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class Stats extends StatelessWidget {
  const Stats({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        // title: Text("Dashboard"),
        centerTitle: true,
        // leading: IconButton(
        //   onPressed: () =>Get.off(()=>NavigationMenu()),
        //   icon: Icon(
        //     color: AppColors.quinary,
        //     Icons.west_outlined,
        //   ),
        // ),
        backgroundColor: AppColors.prettyBlue,
      ),
      backgroundColor: AppColors.prettyBlue,
    );
  }
}
