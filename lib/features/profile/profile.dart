import 'package:ciyebooks/features/auth/screens/signup/signup.dart';
import 'package:ciyebooks/features/profile/controller/profile_controller.dart';
import 'package:ciyebooks/features/profile/screens/widgets/info_tile.dart';
import 'package:ciyebooks/utils/constants/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../../data/repositories/auth/auth_repo.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProfileController());
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(
              Icons.arrow_back_ios_rounded,
              color: AppColors.quinary,
            )),
        // automaticallyImplyLeading: false,
        backgroundColor: AppColors.prettyBlue,
        title: Text(
          'Profile',
          style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.quinary),
        ),
      ),
      backgroundColor: AppColors.quarternary,
      body: SafeArea(
        child: Obx(
          () => ListView(
            physics: ClampingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            children: [

              const Text(
                "User info",
                style: TextStyle(color: AppColors.prettyDark, fontSize: 16, fontWeight: FontWeight.w600),
              ),
              const Divider(
                color: AppColors.prettyDark,
                thickness: .1,
              ),

              const SizedBox(height: 8),
              InfoTile(
                leading: Icons.person_outline,
                title: '${controller.user.value.firstName} ${controller.user.value.lastName}',
                subtitle: "Account name",
              ),
              const SizedBox(height: 8),

              // Email
              InfoTile(
                title: controller.user.value.email,
                subtitle: "Email Address",
                leading: Icons.email_outlined,
              ),
              const SizedBox(height: 8),

              InfoTile(
                leading: Icons.phone_outlined,
                title: controller.user.value.phoneNumber,
                subtitle: "Phone Number",
              ),
              const SizedBox(height: 8),

              // Phone
              // ListTile(
              //   tileColor: AppColors.quinary,
              //   shape: RoundedRectangleBorder(
              //     borderRadius: BorderRadius.circular(12),
              //   ),
              //   dense: true,
              //     ),
              // const SizedBox(height: 8),
              // InfoTile(
              //   leading: Icons.card_giftcard,
              //   title: "NOQWEOU21390NJIQWE8",
              //   subtitle: "Referral code",
              // ),
              // const SizedBox(height: 8),

              InfoTile(
                leading: Icons.language,
                title: "English",
                subtitle: "Language",
              ),
              const SizedBox(height: 8),
              InfoTile(
                leading: Icons.flag_outlined,
                title: "Kenya",
                subtitle: "Country",
              ),

              const SizedBox(height: 8),
              InfoTile(
                leading: Icons.attach_money,
                title: "Kenya Shilling",
                subtitle: "Base currency",
              ),

              const SizedBox(height: 8),

              // Base Currency

              // const SizedBox(height: 20),

              // // Silent Mode
              // const Text(
              //   "Settings",
              //   style: TextStyle(color: AppColors.prettyDark, fontSize: 16, fontWeight: FontWeight.w600),
              // ),
              // const Divider(
              //   color: AppColors.prettyDark,
              //   thickness: .1,
              // ),
              // const SizedBox(height: 10),
              //
              // // Dark Mode Switch
              // Obx(
              //   () => ListTile(
              //     contentPadding: EdgeInsets.fromLTRB(16, 0, 8, 0),
              //     title: controller.isDarkMode.value?Text('Dark mode'):Text('Light mode'),
              //     trailing: CupertinoSwitch(value: controller.isDarkMode.value, onChanged: (val) => controller.isDarkMode.value =! controller.isDarkMode.value),
              //     tileColor: AppColors.quinary,
              //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              //     leading: controller.isDarkMode.value?Icon(Icons.dark_mode):Icon(Icons.light_mode_outlined),
              //   ),
              // ),
              // const SizedBox(height: 8),
              // Obx(
              //   () => ListTile(
              //     contentPadding: EdgeInsets.fromLTRB(16, 0, 8, 0),
              //     title: Text('Forex'),
              //     trailing: CupertinoSwitch(value: controller.forexEnabled.value, onChanged: (val) => controller.forexEnabled.value = !controller.forexEnabled.value),
              //     tileColor: AppColors.quinary,
              //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              //     leading: Icon(Icons.currency_exchange_outlined),
              //   ),
              // ),
              // const SizedBox(height: 8),

              Obx(
                () => ListTile(
                  contentPadding: EdgeInsets.fromLTRB(16, 0, 8, 0),
                  title: Text('Bank'),
                  trailing: CupertinoSwitch(value: controller.bankEnabled.value, onChanged: (value) => controller.bankEnabled.value = !controller.bankEnabled.value),
                  tileColor: AppColors.quinary,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  leading: Icon(Icons.account_balance),
                ),
              ),
              // Forex Theme
              const SizedBox(height: 8),

              const Divider(
                color: AppColors.prettyDark,
                thickness: .1,
              ),

              // const SizedBox(height: 18),
              // ListTile(onTap: ()=>Navigator.push(context, CupertinoPageRoute(builder: (context)=>Signup())),
              //   contentPadding: EdgeInsets.fromLTRB(16, 0, 8, 0),
              //   title: Text('Submit a user for review'),
              //   trailing: Icon(Icons.chevron_right),
              //   tileColor: AppColors.quinary,
              //   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              //   leading: Icon(Icons.person_add_alt),
              // ),
              const SizedBox(height: 70),

              // Sign Out
              GestureDetector(
                onTap: () async {
                  await FirebaseAuth.instance.signOut();
                  AuthRepo.instance.screenRedirect();
                },
                child: Padding(
                  padding: const EdgeInsets.only(left: 18.0),
                  child: Row(
                    children: [
                      Icon(
                        Icons.logout_outlined,
                        color: AppColors.prettyDark,
                      ),
                      Gap(20),
                      Text(
                        'Logout',
                        style: TextStyle(color: AppColors.prettyDark, fontSize: 16, fontWeight: FontWeight.w600),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
