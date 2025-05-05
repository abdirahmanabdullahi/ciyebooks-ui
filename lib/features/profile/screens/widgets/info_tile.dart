
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../utils/constants/colors.dart';

class InfoTile extends StatelessWidget {
  final String title, subtitle;
  final IconData leading;
  const InfoTile({
    super.key,
    required this.title,
    required this.subtitle,
    required this.leading,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      tileColor: AppColors.quinary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      dense: true,
      leading:  Icon(leading, color: AppColors.prettyDark),
      title:  Text(title, style: TextStyle(color: AppColors.prettyDark)),
      subtitle:  Text(subtitle, style: TextStyle(color: AppColors.prettyDark, fontSize: 12)),
    );
  }
}
