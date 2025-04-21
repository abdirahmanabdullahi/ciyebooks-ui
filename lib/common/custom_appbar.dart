import 'package:flutter/material.dart';

import '../utils/device/device_utility.dart';

class CustomAppbar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppbar({
    super.key,
    this.title,
    this.showBackArrow = false,
    this.actions,
    this.leadingWidget,  this.implyLeading =false, required this.backgroundColor,
    // required this.onPressed,

    // this.leadingPressed,
  });

  final Widget? title;
  // final VoidCallback onPressed;
final Color backgroundColor;
  final bool showBackArrow;
  final Widget? leadingWidget;
  final List<Widget>? actions;
  final bool implyLeading;

  // final VoidCallback? leadingPressed;

  @override
  Widget build(BuildContext context) {
    return Column(spacing: 0,mainAxisSize: MainAxisSize.min,
      children: [
        AppBar(
          centerTitle: true,
          scrolledUnderElevation: 0,
          backgroundColor: backgroundColor,
          leading: leadingWidget,
          actions: actions,
          title: title,
        ),

      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(DeviceUtils.getAppBarHeight());
}

