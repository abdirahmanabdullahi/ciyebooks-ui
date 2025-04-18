import 'package:ciyebooks/features/accounts/screens/accounts.dart';
import 'package:ciyebooks/features/bank/bank_home.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';


import '../../bank/withdraw/screens/withdraw_form.dart';

import '../../forex/ui/forex_home.dart';
import '../../pay/screens/payment_home.dart';
import '../../receive/screens/receipts_history.dart';
import '../../search/transaction_history.dart';
import 'bottom_sheet_button.dart';
import 'top_button.dart';

class ButtonList extends StatelessWidget {
  const ButtonList({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: double.infinity,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          TopButton(
            heroTag: "Payment",
            icon: Icons.arrow_outward,
            label: 'Pay',
            // onPressed: (){
            //   Navigator.of(context).push(MaterialPageRoute(builder: (context)=>Testing()));
            // },
onPressed: ()=>Get.offAll(PaymentHistory()),          ),

          TopButton(
            heroTag: "Receive",
            icon: Icons.arrow_downward,
            label: 'Receive',
onPressed: ()=>Get.offAll(()=>ReceiptsHistory()),       ),
          TopButton(
            heroTag: "Bank",
            icon: Icons.account_balance_outlined,
            label: 'Bank',
              onPressed: ()=>Get.offAll(()=>BankHistory()),
          ),
          TopButton(
            heroTag: "Forex",
            icon: Icons.currency_exchange,
            label: 'Forex',
onPressed: ()=>Get.offAll(()=>ForexHome()),          ),
          TopButton(
            heroTag: "Accounts",
            icon: Icons.group_outlined,
            label: 'Accounts',
            onPressed: () => Get.offAll(()=>Accounts()),
          ),
          TopButton(
            heroTag: "History",
            icon: Icons.manage_search_outlined,
            label: 'History',
            onPressed: () => Get.to(() => const TransactionHistoryPage()),
          ),
          // TopButton(
          //     icon: Icons.search,
          //     label: "Search all",
          //     onPressed: () {},
          //     heroTag: "Search all")
        ],
      ),
    );
  }

}
