import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../accounts/model/model.dart';
import '../models/stats_model.dart';

class StatsController extends GetxController {
  static StatsController get instance => Get.find();
  final String today = DateFormat("dd MMM yyyy ").format(DateTime.now());

  Rx<DailyReportModel> todayReport = DailyReportModel.empty().obs;
  RxList<AccountModel> accounts = <AccountModel>[].obs;


  @override
  void onInit() {
    super.onInit();
    FirebaseFirestore.instance.collection('Users').doc(uid).collection('accounts').where('overDrawn',isGreaterThanOrEqualTo: true).snapshots().listen((querySnapshot) {
      accounts.value = querySnapshot.docs.map((doc) {
        return AccountModel.fromJson(doc.data());
      }).toList();
    });
  }

  final uid = FirebaseAuth.instance.currentUser?.uid;

  createDailyReport() async {
    final reportRef = FirebaseFirestore.instance.collection('Users').doc(uid).collection('DailyReports').doc(today);
    final snapshot = await reportRef.get();

    if (!snapshot.exists) {
      print('Doc no exist');
      await reportRef.set(DailyReportModel.empty().toJson());
      todayReport.value = DailyReportModel.empty();
    } else {
      print('Doc yes exist');
      print(todayReport.value.dailyProfit.toString());

      todayReport.value = DailyReportModel.fromJson(snapshot.data() as Map<String, dynamic>);
    }
  }
}
