import 'package:ciyebooks/navigation_menu.dart';
import 'package:ciyebooks/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class Stats extends StatelessWidget {
  const Stats({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Stats'),
        automaticallyImplyLeading: true,
        // title: Text("Dashboard"),
        centerTitle: true,
        // leading: IconButton(
        //   onPressed: () =>Get.off(()=>NavigationMenu()),
        //   icon: Icon(
        //     color: AppColors.quinary,
        //     Icons.west_outlined,
        //   ),
        // ),
        backgroundColor: AppColors.prettyBlue,
      ),
      body: SafeArea(
          child: SingleChildScrollView(
        physics: ClampingScrollPhysics(),
        child: Column(
          children: [
            ///Payments
            Container(
              width: double.maxFinite,
              margin: EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: AppColors.quinary,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(30),
                    blurRadius: 4,
                    offset: Offset(-3, 3),
                  )
                ],
                borderRadius: BorderRadius.circular(14),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(12.0, 12, 0, 0),
                    child: Text("Payments", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12, color: AppColors.prettyDark)),
                  ),
                  Gap(8),
                  Padding(padding: const EdgeInsets.fromLTRB(16.0, 0, 16, 16), child: Column(children: [])),
                ],
              ),
            ),
            ///Client deposits
            Container(
              width: double.maxFinite,
              margin: EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: AppColors.quinary,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(30),
                    blurRadius: 4,
                    offset: Offset(-3, 3),
                  )
                ],
                borderRadius: BorderRadius.circular(14),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(12.0, 12, 0, 0),
                    child: Text("Received from clients", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12, color: AppColors.prettyDark)),
                  ),
                  Gap(8),
                  Padding(padding: const EdgeInsets.fromLTRB(16.0, 0, 16, 16), child: Column(children: [])),
                ],
              ),
            ),
            ///Bank deposits
            Container(
              width: double.maxFinite,
              margin: EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: AppColors.quinary,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(30),
                    blurRadius: 4,
                    offset: Offset(-3, 3),
                  )
                ],
                borderRadius: BorderRadius.circular(14),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(12.0, 12, 0, 0),
                    child: Text(" Deposits", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12, color: AppColors.prettyDark)),
                  ),
                  Gap(8),
                  Padding(padding: const EdgeInsets.fromLTRB(16.0, 0, 16, 16), child: Column(children: [])),
                ],
              ),
            ),
            /// Bank withdrawals
            Container(
              width: double.maxFinite,
              margin: EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: AppColors.quinary,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(30),
                    blurRadius: 4,
                    offset: Offset(-3, 3),
                  )
                ],
                borderRadius: BorderRadius.circular(14),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(12.0, 12, 0, 0),
                    child: Text("Withdrawals", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12, color: AppColors.prettyDark)),
                  ),
                  Gap(8),
                  Padding(padding: const EdgeInsets.fromLTRB(16.0, 0, 16, 16), child: Column(children: [])),
                ],
              ),
            ),
            /// Expenses
            Container(
              width: double.maxFinite,
              margin: EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: AppColors.quinary,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(30),
                    blurRadius: 4,
                    offset: Offset(-3, 3),
                  )
                ],
                borderRadius: BorderRadius.circular(14),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(12.0, 12, 0, 0),
                    child: Text("Expenses", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12, color: AppColors.prettyDark)),
                  ),
                  Gap(8),
                  Padding(padding: const EdgeInsets.fromLTRB(16.0, 0, 16, 16), child: Column(children: [])),
                ],
              ),
            ),
            ///Currencies payable
            Container(
              width: double.maxFinite,
              margin: EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: AppColors.quinary,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(30),
                    blurRadius: 4,
                    offset: Offset(-3, 3),
                  )
                ],
                borderRadius: BorderRadius.circular(14),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(12.0, 12, 0, 0),
                    child: Text("Payables", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12, color: AppColors.prettyDark)),
                  ),
                  Gap(8),
                  Padding(padding: const EdgeInsets.fromLTRB(16.0, 0, 16, 16), child: Column(children: [])),
                ],
              ),
            ),

        /// Accounts receivable
            Container(
              width: double.maxFinite,
              margin: EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: AppColors.quinary,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(30),
                    blurRadius: 4,
                    offset: Offset(-3, 3),
                  )
                ],
                borderRadius: BorderRadius.circular(14),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(12.0, 12, 0, 0),
                    child: Text("Accounts receivable", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12, color: AppColors.prettyDark)),
                  ),
                  Gap(8),
                  Padding(padding: const EdgeInsets.fromLTRB(16.0, 0, 16, 16), child: Column(children: [])),
                ],
              ),
            ),/// Accounts receivable
            Container(
              width: double.maxFinite,
              margin: EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: AppColors.quinary,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(30),
                    blurRadius: 4,
                    offset: Offset(-3, 3),
                  )
                ],
                borderRadius: BorderRadius.circular(14),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(12.0, 12, 0, 0),
                    child: Text("Income", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12, color: AppColors.prettyDark)),
                  ),
                  Gap(8),
                  Padding(padding: const EdgeInsets.fromLTRB(16.0, 0, 16, 16), child: Column(children: [])),
                ],
              ),
            ),
          ],
        ),
      )),
      backgroundColor: AppColors.prettyBlue,
    );
  }
}
