
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../../common/styles/custom_container.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../common/widgets/amount_and_receipt_tile_header.dart';

class PaymentReceipt extends StatelessWidget {
  const PaymentReceipt({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      darkColor: AppColors.quinary,
      width: double.infinity,
      padding: EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AmountAndReceiptTileHeader(
              title: "Cash payment receipt",
              icon: Icon(
                Icons.north_east,
                color: AppColors.quinary,
              )),
          Gap(AppSizes.sm),
          Divider(
            indent: 49,
          ),
          Gap(AppSizes.md),
          ListTile(
            dense: true,
            minTileHeight: 30,
            leading: const Icon(Icons.person_outline),
            title: const Text("Abdirahman Abdullahi Abdi"),
            subtitle: Text("Paying account"),
          ),
          ListTile(
            dense: true,
            minTileHeight: 30,
            leading: const Icon(Icons.person),
            title: const Text("Mohamed Warsame Abdi"),
            subtitle: Text("Receiver"),
          ),
          ListTile(
            isThreeLine: true,
            dense: true,
            minTileHeight: 30,
            leading: const Icon(Icons.payments_outlined),
            title: const Text("US Dollar"),
            subtitle: Text("Currency paid"),
          ),
          ListTile(
            dense: true,
            minTileHeight: 30,
            leading: const Icon(Icons.pin_outlined),
            title: const Text("2,345,566"),
            subtitle: Text("Amount"),
          ),
          const ListTile(
            isThreeLine: true,
            dense: true,
            minTileHeight: 30,
            leading: Icon(Icons.description_outlined),
            title: Text("Waxalasiyay gaariga xamuulka Abdiyare"),
            subtitle: Text("Description"),
          ),
          const ListTile(
            isThreeLine: true,
            dense: true,
            minTileHeight: 30,
            leading: Icon(Icons.schedule),
            title: Text("2/3/2024  1:42 pm"),
            subtitle: Text("Date and time"),
          ),
          Gap(AppSizes.sm),
          Divider(
            indent: 17,
          ),
          Gap(AppSizes.sm),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                        text: "Status:  ",
                        style: Theme.of(context).textTheme.titleSmall),
                    TextSpan(
                        text: "Payment complete",
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge!
                            .apply(color: Colors.green))
                  ],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
