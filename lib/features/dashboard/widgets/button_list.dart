import 'package:ciyebooks/features/pay/pay_expense/screens/pay_expense_form.dart';
import 'package:ciyebooks/navigation_menu.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../../../utils/constants/colors.dart';
import '../../accounts/account_search.dart';
import '../../accounts/create_accounts.dart';
import '../../bank/deposit/screens/bank_deposit_account_selector.dart';
import '../../bank/deposit_for_client/client_deposit_account_selector.dart';
import '../../bank/withdraw/screens/withdraw_account_selector.dart';
import '../../common/screens/account_selector_screen.dart';
import '../../forex/buy/buy_account_selector.dart';
import '../../forex/forex_history.dart';
import '../../forex/sell/sell_account_selector.dart';
import '../../pay/pay_client/screens/pay_client_form.dart';
import '../../receive/screens/receive_account_selector.dart';
import '../../search/transaction_history.dart';
import '../../forex/currency_stock.dart';
import '../../internal_transfer/internal_transfer_account_selector.dart';
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
            onPressed: () {
              showModalBottomSheet<dynamic>(
                isScrollControlled: true,
                context: context,
                builder: (BuildContext bc) {
                  return Wrap(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Make a payment",
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            Gap(20),
                            Divider(
                              height: 0,
                            ),
                            BottomSheetButton(
                              heroTag: "Pay a client",
                              label: "Pay a client",
                              icon: Icons.north_east,
                              onPressed: () {
                                Get.back();
                                Get.to(() => PayClientForm());
                              },
                            ),
                            Divider(
                              height: 0,
                            ),
                            BottomSheetButton(heroTag: "Pay an expense", label: "Pay an expense", icon: Icons.shopping_bag, onPressed: () => Get.to(() => PayExpenseForm())),
                            Divider(
                              height: 0,
                            ),
                            BottomSheetButton(
                              heroTag: "Payment history",
                              label: "Payment history",
                              icon: Icons.list_alt,
                              onPressed: () {
                                Get.back();
                                // Get.to(() => const PaymentHistory());
                              },
                            ),
                            Divider(
                              height: 0,
                            ),
                            BottomSheetButton(
                              heroTag: "Schedule a payment",
                              label: "Schedule a payment",
                              icon: Icons.north_east,
                              onPressed: () {
                                Get.back();
                                // Get.to(() => PayAccountSelectorScreen());
                              },
                            ),
                            Divider(
                              height: 0,
                            ),
                            Gap(60),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              );
            },
          ),

          TopButton(
            heroTag: "Receive",
            icon: Icons.arrow_downward,
            label: 'Receive',
            onPressed: () {
              showModalBottomSheet<dynamic>(
                isScrollControlled: true,
                context: context,
                builder: (BuildContext bc) {
                  return Wrap(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Receive funds",
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            Gap(20),
                            Divider(
                              height: 0,
                            ),
                            BottomSheetButton(
                                heroTag: "Receive funds from a client",
                                label: "Receive funds from a client",
                                icon: Icons.arrow_downward,
                                onPressed: () {
                                  Get.back();
                                  Get.to(
                                    () => const ReceiveAccountSelector(),
                                  );
                                }),
                            Divider(
                              height: 0,
                            ),
                            BottomSheetButton(
                              heroTag: "Receipt history",
                              label: "Receipt history",
                              icon: Icons.list_alt,
                              onPressed: () {},
                            ),
                            Divider(
                              height: 0,
                            ),
                            Gap(60)
                          ],
                        ),
                      ),
                    ],
                  );
                },
              );
            },
          ),
          TopButton(
            heroTag: "Bank",
            icon: Icons.account_balance_outlined,
            label: 'Bank',
            onPressed: () {
              showModalBottomSheet<dynamic>(
                isScrollControlled: true,
                context: context,
                builder: (BuildContext bc) {
                  return Wrap(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Bank",
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            Gap(20),
                            Divider(
                              height: 0,
                            ),
                            BottomSheetButton(
                              heroTag: "Deposit cash at bank",
                              label: "Deposit cash at bank",
                              icon: Icons.arrow_downward,
                              onPressed: () {
                                Get.back();
                                Get.to(() => BankDepositAccountSelector());
                              },
                            ),
                            Divider(
                              height: 0,
                            ),
                            BottomSheetButton(
                              heroTag: "Withdraw cash from bank",
                              label: "Withdraw cash from bank",
                              icon: Icons.list_alt,
                              onPressed: () {
                                Get.back();
                                Get.to(() => WithdrawAccountSelector());
                              },
                            ),
                            Divider(
                              height: 0,
                            ),
                            BottomSheetButton(
                              heroTag: "Deposit for client",
                              label: "Deposit for client",
                              icon: Icons.list_alt,
                              onPressed: () {
                                Get.back();
                                Get.to(() => ClientDepositAccountSelector());
                              },
                            ),
                            Divider(
                              height: 0,
                            ),
                            BottomSheetButton(
                              heroTag: "Bank history",
                              label: "Bank history",
                              icon: Icons.list_alt,
                              onPressed: () {},
                            ),
                            Divider(
                              height: 0,
                            ),
                            Gap(60),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              );
            },
          ),
          TopButton(
            heroTag: "Transfer",
            icon: Icons.swap_horiz,
            label: 'Transfer',
            onPressed: () {
              showModalBottomSheet<dynamic>(
                isScrollControlled: true,
                context: context,
                builder: (BuildContext bc) {
                  return Wrap(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Make a transfer",
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            Gap(20),
                            Divider(
                              height: 0,
                            ),
                            BottomSheetButton(
                              heroTag: "Internal transfer",
                              label: "Internal transfer",
                              icon: Icons.north_east,
                              onPressed: () => Get.to(() => InternalTransferAccountSelector()),
                            ),
                            Divider(
                              height: 0,
                            ),
                            BottomSheetButton(
                              heroTag: "Bank transfer",
                              label: "Bank transfer",
                              icon: Icons.shopping_bag,
                              onPressed: () {},
                            ),
                            Divider(
                              height: 0,
                            ),
                            BottomSheetButton(
                              heroTag: "Transfer history",
                              label: "Transfer history",
                              icon: Icons.list_alt,
                              onPressed: () {},
                            ),
                            Divider(
                              height: 0,
                            ),
                            Gap(60),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              );
            },
          ),
          // TopButton(
          //   heroTag: "Forex",
          //   icon: Icons.currency_exchange,
          //   label: 'Forex',
          //   onPressed: () {
          //     showModalBottomSheet<dynamic>(
          //       isScrollControlled: true,
          //       context: context,
          //       builder: (BuildContext bc) {
          //         return Wrap(
          //           children: <Widget>[
          //             Padding(
          //               padding: const EdgeInsets.fromLTRB(8.0, 8, 8, 60),
          //               child: Column(
          //                 crossAxisAlignment: CrossAxisAlignment.start,
          //                 children: [
          //                   Text(
          //                     "Buy and sell foreign currencies",
          //                     style: Theme.of(context).textTheme.titleMedium,
          //                   ),
          //                   Gap(20),
          //                   Divider(
          //                     height: 0,
          //                   ),
          //                   BottomSheetButton(
          //                     heroTag: "Buy",
          //                     label: "Buy",
          //                     icon: Icons.north_east,
          //                     onPressed: () {
          //                       Get.back();
          //                       Get.to(() => BuyAccountSelector());
          //                     },
          //                   ),
          //                   Divider(
          //                     height: 0,
          //                   ),
          //                   BottomSheetButton(
          //                     heroTag: "sell",
          //                     label: "sell",
          //                     icon: Icons.shopping_bag,
          //                     onPressed: () {
          //                       Get.back();
          //                       Get.to(() => SellAccountSelector());
          //                     },
          //                   ),
          //                   Divider(
          //                     height: 0,
          //                   ),
          //                   BottomSheetButton(
          //                     heroTag: "New currency",
          //                     label: "New currency",
          //                     icon: Icons.list_alt,
          //                     onPressed: () {},
          //                   ),
          //                   Divider(
          //                     height: 0,
          //                   ),
          //                   BottomSheetButton(
          //                     heroTag: "Currency stock",
          //                     label: "Currency stock",
          //                     icon: Icons.list_alt,
          //                     onPressed: () {
          //                       Get.back();
          //                       Get.to(() => CurrencyStock());
          //                     },
          //                   ),
          //                   Divider(
          //                     height: 0,
          //                   ),
          //                   BottomSheetButton(
          //                     heroTag: "Forex history",
          //                     label: "Forex history",
          //                     icon: Icons.list_alt,
          //                     onPressed: () {
          //                       Get.back();
          //                       Get.to(() => ForexHistory());
          //                     },
          //                   ),Divider(height: 0,),
          //                 ],
          //               ),
          //             ),
          //           ],
          //         );
          //       },
          //     );
          //   },
          // ),
          TopButton(
            heroTag: "Accounts",
            icon: Icons.group_outlined,
            label: 'Accounts',
            onPressed: () {
              showModalBottomSheet<dynamic>(
                backgroundColor: AppColors.quinary,
                isScrollControlled: true,
                context: context,
                builder: (BuildContext bc) {
                  return Wrap(
                    children: <Widget>[
                      // Padding(
                      //   padding: const EdgeInsets.fromLTRB(8.0, 8, 8, 60),
                      //   child: Column(
                      //     crossAxisAlignment: CrossAxisAlignment.start,
                      //     children: [
                      //       Text(
                      //         "Manage accounts",
                      //         style: Theme.of(context).textTheme.titleMedium,
                      //       ),
                      //       Gap(20),
                      //       Divider(
                      //         height: 0,
                      //       ),
                      //       BottomSheetButton(
                      //         heroTag: "Create accounts",
                      //         label: "Create accounts",
                      //         icon: Icons.north_east,
                      //         onPressed: () {
                      //           Get.back();
                      //           Get.to(() => CreateAccounts());
                      //         },
                      //       ),
                      //       Divider(height: 0,),
                      //       BottomSheetButton(
                      //         heroTag: "View accounts",
                      //         label: "View accounts",
                      //         icon: Icons.shopping_bag,
                      //         onPressed: () {
                      //           Get.back();
                      //           Get.to(() => AccountSearch());
                      //         },
                      //       ),
                      //       Divider(
                      //         height: 0,
                      //       ),
                      //     ],
                      //   ),
                      // ),
                    ],
                  );
                },
              );
            },
          ),
          TopButton(
            heroTag: "Search",
            icon: Icons.manage_search_outlined,
            label: 'Search',
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
