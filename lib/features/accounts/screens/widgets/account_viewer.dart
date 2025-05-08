import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';

import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/sizes.dart';

showAccountDetails({required BuildContext context, required String accountName, required String accountNumber, required String email, required String phoneNumber, required List<Widget> balances}) {
  return showDialog(
    context: context,
    builder: (context) {
      final NumberFormat formatter = NumberFormat.decimalPatternDigits(
        locale: 'en_us',
        decimalDigits: 2,
      );
      return PopScope(
        canPop: false,
        child: AlertDialog(
          insetPadding: EdgeInsets.all(8),
          backgroundColor: AppColors.quinary,
          contentPadding: EdgeInsets.all(
            8,
          ),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(34)),
          content: SingleChildScrollView(physics: ClampingScrollPhysics(),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Gap(6),
                Container(margin: EdgeInsets.all(8),
                    width: double.maxFinite,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.quinary,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withAlpha(15),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        )
                      ],
                    ),
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 35,
                          backgroundColor: AppColors.prettyBlue,
                          child: Center(
                              child: Icon(
                            Icons.manage_accounts,
                            size: 45,
                            color: AppColors.quinary,
                          )),
                        ),
                        Gap(10),
                        Text(
                          accountName,
                          style: TextStyle(color: AppColors.prettyDark, fontWeight: FontWeight.w700, fontSize: 24),
                        ),
                        Gap(24)
                      ],
                    )),
                const SizedBox(height: 16),

                // Payment Details box
                Container(margin: EdgeInsets.all(8),
                  width: double.infinity,
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(15),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      )
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Gap(10),
                      Text(
                        "Account details",
                        style: TextStyle(letterSpacing: 2, fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.secondary
                            // fontWeight: FontWeight.bold,
                            ),
                      ),
                      SizedBox(height: 24),
                      // Divider(color: Colors.black, thickness: .11),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Account name",
                              style: TextStyle(
                                fontSize: 13,
                              )),
                          Text(accountName,
                              style: TextStyle(
                                fontSize: 13,
                              )),
                        ],
                      ),
                      Divider(color: Colors.black, thickness: .11),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Account number",
                              style: TextStyle(
                                fontSize: 13,
                              )),
                          Text(accountNumber,
                              style: TextStyle(
                                fontSize: 13,
                              )),
                        ],
                      ),
                      Divider(color: Colors.black, thickness: .11),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Phone number",
                              style: TextStyle(
                                fontSize: 13,
                              )),
                          Text(phoneNumber,
                              style: TextStyle(
                                fontSize: 13,
                              )),
                        ],
                      ),

                      Divider(color: Colors.black, thickness: .11),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Email',
                              style: TextStyle(
                                fontSize: 13,
                              )),
                          Text(email,
                              style: TextStyle(
                                fontSize: 13,
                              )),
                        ],
                      ),
                    ],
                  ),
                ),
                Gap(10),
                Container(margin: EdgeInsets.all(8),
                  width: double.infinity,
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(15),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      )
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Gap(10),
                      Text(
                        "Balances",
                        style: TextStyle(letterSpacing: 2, fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.secondary
                            // fontWeight: FontWeight.bold,
                            ),
                      ),
                      SizedBox(height: 24),
                      ...balances,
                    ],
                  ),
                ),
                Container(margin: EdgeInsets.symmetric(horizontal: 8,vertical: 16),
                  child: SizedBox(
                    // height: 45,
                    width: double.maxFinite,
                    child: FloatingActionButton(
                        // elevation: 0,
                        // style: ElevatedButton.styleFrom(
                        //   padding: EdgeInsets.symmetric(horizontal: 10),
                        //   disabledBackgroundColor: const Color(0xff35389fff),
                        backgroundColor: AppColors.prettyBlue,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        // ),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                  
                        // onPressed: controller.isLoading.value ? null : () => controller.createPayment(context),
                        child: Text(
                          'Done',
                          style: TextStyle(color: AppColors.quinary, fontSize: 14, fontWeight: FontWeight.w700),
                        )),
                  ),
                ),

                // Gap(6)
              ],
            ),
          ),
        ),
      );
    },
  );
}
