import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../../common/custom_appbar.dart';
import '../../common/styles/custom_container.dart';
import '../../navigation_menu.dart';
import '../../utils/constants/sizes.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(
        actions: [
          IconButton(
              onPressed: () => Get.offAll(() => const NavigationMenu()),
              icon: const Icon(Icons.clear))
        ],
        title: const Text("Profile"), backgroundColor: Colors.red,
        // showBackArrow: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.sm),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Personal"),
              const CustomContainer(
                height: 250,
                darkColor: Colors.red,
                width: double.infinity,
                padding: EdgeInsets.all(12),
                child: Column(
                  children: [],
                ),
              ),
              Gap(AppSizes.spaceBtwSections),
              const Text("Capiatal"),
              const CustomContainer(
                height: 250,
                darkColor: Colors.red,
                width: double.infinity,
                padding: EdgeInsets.all(12),
                child: Column(
                  children: [],
                ),
              ),
              Gap(AppSizes.spaceBtwSections),
              const Text("Preferences"),
              const CustomContainer(
                height: 250,
                darkColor: Colors.red,
                width: double.infinity,
                padding: EdgeInsets.all(12),
                child: Column(
                  children: [],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
