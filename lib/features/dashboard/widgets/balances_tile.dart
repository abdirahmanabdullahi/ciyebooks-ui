import 'package:flutter/material.dart';

import '../../../utils/constants/colors.dart';

class BalanceTile extends StatelessWidget {
  const BalanceTile({
    super.key,
    required this.leading,
    required this.title,
    required this.subtitle, required this.valueColor,

  });
  final String leading, title, subtitle;
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      shape: RoundedRectangleBorder(
      side: BorderSide(color: Colors.grey, width: .3),
      borderRadius: BorderRadius.circular(20),
    ),
      trailing: Padding(
        padding: const EdgeInsets.only(right: (8.0)),
        child: IconButton(constraints: BoxConstraints(maxWidth: 12),
            onPressed: () {},
            icon: const Icon(
              Icons.info_outline,
              color: Colors.grey,
            )),
      ),
      // minTileHeight: 60,
      contentPadding: const EdgeInsets.symmetric(horizontal: 10,),
      // isThreeLine: true,
      dense: true,
      tileColor: AppColors.quinary,
      leading: CircleAvatar(
        radius: 18,
        backgroundColor: AppColors.prettyDark,
        child: Text(
          leading,
          style: const TextStyle(
              // fontFamily: "Oswald",
              fontWeight: FontWeight.w700,
              color: AppColors.quinary,
              fontSize: 10),
        ),
      ),
      title: Text(
        title,
        style: TextStyle(fontSize: 22,fontWeight: FontWeight.w500,fontFamily: 'Oswald')
      ),
      subtitle: Text(
        subtitle,
        style:TextStyle(color: Colors.grey.shade400,fontWeight: FontWeight.w700,fontSize: 12)
      ),
    );
  }
}
