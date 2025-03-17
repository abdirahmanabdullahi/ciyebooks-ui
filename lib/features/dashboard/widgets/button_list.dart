import 'package:ciyebooks/features/accounts/controller/accounts_controller.dart';
import 'package:ciyebooks/features/accounts/screens/accounts.dart';
import 'package:ciyebooks/features/bank/deposit/deposit_form.dart';
import 'package:ciyebooks/features/bank/deposit_for_client/screens/deposit_for_client_form.dart';
import 'package:ciyebooks/features/bank/withdraw/screens/withdraw_history.dart';
import 'package:ciyebooks/features/forex/ui/forex_form.dart';
import 'package:ciyebooks/features/pay/pay_expense/screens/pay_expense_form.dart';
import 'package:ciyebooks/features/transafers/internal_transfer/screens/internal_transfer_form.dart';
import 'package:ciyebooks/navigation_menu.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../../../utils/constants/colors.dart';

import '../../bank/deposit/screens/deposit_history_screen.dart';
import '../../bank/withdraw/screens/withdraw_form.dart';
import '../../common/screens/account_selector_screen.dart';

import '../../forex/ui/forex_history.dart';
import '../../pay/pay_client/screens/pay_client_form.dart';
import '../../pay/pay_client/screens/payment_history.dart';
import '../../pay/pay_expense/screens/expense_history.dart';
import '../../receive/screens/receipts_history.dart';
import '../../receive/screens/receive_from_client_form.dart';
import '../../search/transaction_history.dart';
import '../../transafers/bank_transfer/screens/bank_transfer_form.dart';
import '../../transafers/internal_transfer/screens/transfer_history.dart';
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
                            BottomSheetButton(
                                heroTag: "Pay an expense",
                                label: "Pay an expense",
                                icon: Icons.shopping_bag,
                                onPressed: () {
                                  Get.back();
                                  Get.to(() => PayExpenseForm());
                                }),
                            Divider(
                              height: 0,
                            ),
                            BottomSheetButton(
                              heroTag: "Payment history",
                              label: "Payment history",
                              icon: Icons.list_alt,
                              onPressed: () {
                                Get.back();
                                Get.to(() => const PaymentHistory());
                              },
                            ),
                            Divider(
                              height: 0,
                            ),
                            BottomSheetButton(
                              heroTag: "Expense History",
                              label: "Expense history",
                              icon: Icons.north_east,
                              onPressed: () {
                                Get.back();
                                Get.to(() => ExpenseHistory());
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
                                    () => const ReceiveFromClientForm(),
                                  );
                                }),
                            Divider(
                              height: 0,
                            ),
                            BottomSheetButton(
                              heroTag: "Receipt history",
                              label: "Receipt history",
                              icon: Icons.list_alt,
                              onPressed: () => Get.offAll(() => ReceiptsHistory()),
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
                                Get.to(() => DepositForm());
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
                                Get.to(() => WithdrawForm());
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
                                Get.to(() => DepositForClientForm());
                              },
                            ),
                            Divider(
                              height: 0,
                            ),
                            BottomSheetButton(
                              heroTag: "Bank history",
                              label: "Bank history",
                              icon: Icons.list_alt,
                              onPressed: () => Get.to(() => WithdrawHistory()),
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
                              onPressed: () => Get.to(() => InternalTransferForm()),
                            ),
                            Divider(
                              height: 0,
                            ),
                            BottomSheetButton(
                              heroTag: "Bank transfer",
                              label: "Bank transfer",
                              icon: Icons.shopping_bag,
                              onPressed: () => Get.offAll(() => BankTransferForm()),
                            ),
                            Divider(
                              height: 0,
                            ),
                            BottomSheetButton(
                              heroTag: "Transfer history",
                              label: "Transfer history",
                              icon: Icons.list_alt,
                              onPressed: () => Get.offAll(() => TransferHistory()),
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
            heroTag: "Forex",
            icon: Icons.currency_exchange,
            label: 'Forex',
            onPressed: () {
              showModalBottomSheet<dynamic>(
                isScrollControlled: true,
                context: context,
                builder: (BuildContext bc) {
                  return Wrap(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.fromLTRB(8.0, 8, 8, 60),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Buy and sell foreign currencies",
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            Gap(20),
                            Divider(
                              height: 0,
                            ),
                            BottomSheetButton(
                              heroTag: "Buy",
                              label: "Buy",
                              icon: Icons.north_east,
                              onPressed: () {
                                Get.back();
                                Get.to(() => ForexForm());
                              },
                            ),
                            Divider(
                              height: 0,
                            ),
                            BottomSheetButton(
                              heroTag: "sell",
                              label: "sell",
                              icon: Icons.shopping_bag,
                              onPressed: () {
                                Get.back();
                                Get.to(() => ForexForm());
                              },
                            ),
                            Divider(
                              height: 0,
                            ),
                            BottomSheetButton(
                              heroTag: "New currency",
                              label: "New currency",
                              icon: Icons.list_alt,
                              onPressed: () {},
                            ),
                            Divider(
                              height: 0,
                            ),
                            BottomSheetButton(
                              heroTag: "Currency stock",
                              label: "Currency stock",
                              icon: Icons.list_alt,
                              onPressed: () {
                                Get.back();
                                // Get.to(() => CurrencyStock());
                              },
                            ),
                            Divider(
                              height: 0,
                            ),
                            BottomSheetButton(
                              heroTag: "Forex history",
                              label: "Forex history",
                              icon: Icons.list_alt,
                              onPressed: () {
                                Get.back();
                                Get.to(() => ForexHistory());
                              },
                            ),
                            Divider(
                              height: 0,
                            ),
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
            heroTag: "Accounts",
            icon: Icons.group_outlined,
            label: 'Accounts',
            onPressed: () => Get.offAll(()=>Accounts()),
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
