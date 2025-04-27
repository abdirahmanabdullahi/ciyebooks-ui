import 'package:flutter/material.dart';
import '../../utils/constants/sizes.dart';
import '../../utils/helpers/helper_functions.dart';

class CustomContainer extends StatelessWidget {
  const CustomContainer(
      {super.key,
      this.darkColor,
      this.lightColor,
      this.height,
      required this.width,
      required this.child,
      required this.padding,
      this.borderRadius = 0, this.border});
  final Color? darkColor, lightColor;
  final double? height;
  final double width;
  final Widget child;
  final EdgeInsets padding;
  final double? borderRadius;
  final BoxBorder? border;

  @override
  Widget build(BuildContext context) {
    final dark = HelperFunctions.isDarkMode(context);
    return Container(margin: EdgeInsets.only(top: 7),
      decoration: BoxDecoration(
       
        border: border,
        borderRadius: BorderRadius.circular(borderRadius!),
        color: dark ? lightColor : darkColor,
      ),
      height: height,
      width: width,
      padding: padding,
      child: child,
    );
  }
}
