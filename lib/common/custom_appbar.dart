import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../utils/constants/colors.dart';
import '../utils/device/device_utility.dart';
import '../utils/helpers/helper_functions.dart';

class CustomAppbar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppbar({
    super.key,
    this.title,
    this.showBackArrow = false,
    this.actions,
    this.leadingWidget,  this.implyLeading =false,
    // required this.onPressed,

    // this.leadingPressed,
  });

  final Widget? title;
  // final VoidCallback onPressed;

  final bool showBackArrow;
  final Widget? leadingWidget;
  final List<Widget>? actions;
  final bool implyLeading;

  // final VoidCallback? leadingPressed;

  @override
  Widget build(BuildContext context) {
    final dark = HelperFunctions.isDarkMode(context);
    return AppBar(
      scrolledUnderElevation: 0,
      backgroundColor: dark ? AppColors.dark : AppColors.quinary,
      leading: showBackArrow
          ? IconButton(
              onPressed: () => Get.back(), icon: const Icon(Icons.arrow_back_ios))
          : null,
      actions: actions,
      title: title,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(DeviceUtils.getAppBarHeight());
}
