import 'package:flutter/material.dart';

import '../../../utils/constants/colors.dart';

class AccountsTile extends StatelessWidget {
  const AccountsTile({
    super.key,
    this.onPressedAccountTile,
    required this.accountName,
    required this.initials,
    required this.accountNo,
    required this.currency,
  });
  final String accountName, initials, accountNo, currency;
  final VoidCallback? onPressedAccountTile;

  @override
  Widget build(BuildContext context) {
    return ListTile(shape: RoundedRectangleBorder(
      side: BorderSide(color: Colors.black, width: .1),
      borderRadius: BorderRadius.circular(10),
    ),
      onTap: onPressedAccountTile,
      minVerticalPadding: 5,
      horizontalTitleGap: 10,
      dense: true,
      // isThreeLine: true,

      enabled: true,
      selected: true,
      selectedTileColor: Colors.white,
      leading: Container(
        width: 35,
        height: 35,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            border: Border.all(width: 1, color: AppColors.darkGrey)),
        child: Center(
          child: Text(
            initials,
            style: Theme.of(context)
                .textTheme
                .bodyLarge!
                .apply(color: Colors.blueAccent),
          ),
        ),
      ),

      title: Text(
        accountName,
        style: Theme.of(context).textTheme.titleMedium,
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            accountNo,
            style: Theme.of(context).textTheme.labelMedium,
          ),
          Text(
            currency,
            style: Theme.of(context).textTheme.labelMedium,
          )
        ],
      ),
    );
  }
}
