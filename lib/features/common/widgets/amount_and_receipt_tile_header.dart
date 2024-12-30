import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../utils/constants/colors.dart';

class AmountAndReceiptTileHeader extends StatelessWidget {
  const AmountAndReceiptTileHeader({
    super.key,
    required this.title,
    required this.icon,
  });
  final String title;
  final Icon icon;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 35,
          height: 35,
          decoration: BoxDecoration(
              color: AppColors.prettyDark,
              borderRadius: BorderRadius.circular(30),
              border: Border.all(width: 1, color: AppColors.darkGrey)),
          child: Center(
            child: icon,
          ),
        ),
        const Gap(12),
        Text(
          title,
          style: const TextStyle(
              // fontFamily: "Oswald",
              color: AppColors.prettyDark,
              fontSize: 25,
              height: 1.2),
        ),
      ],
    );
  }
}
