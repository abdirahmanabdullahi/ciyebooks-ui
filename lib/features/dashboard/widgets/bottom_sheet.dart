import 'package:flutter/material.dart';

import '../../../common/styles/custom_container.dart';

class CustomBottomSheet extends StatelessWidget {
  const CustomBottomSheet({
    super.key,
    required this.child,
  });
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      height: 320,
      darkColor: Colors.white,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        vertical: 20,
        horizontal: 15,
      ),
      child: child,
    );
  }
}
