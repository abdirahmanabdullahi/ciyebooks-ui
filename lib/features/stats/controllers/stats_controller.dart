import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../models/stats_model.dart';

class StatsController extends GetxController {
  static StatsController get instance => Get.find();
  final String today = DateFormat("dd MMM yyyy ").format(DateTime.now());

  Rx<DailyReportModel> todayReport = DailyReportModel.empty().obs;

  final uid = FirebaseAuth.instance.currentUser?.uid;

  @override
  void onInit() {
    /// Create the daily report if it does not Exist
    createDailyReport();
    super.onInit();
  }

  createDailyReport() async {
    final reportRef = FirebaseFirestore.instance.collection('Users').doc(uid).collection('DailyReports').doc(today);
    final snapshot = await reportRef.get();

    if (!snapshot.exists) {
      await reportRef.set(DailyReportModel.empty().toJson());
      todayReport.value = DailyReportModel.empty();
    } else {
      todayReport.value = DailyReportModel.fromJson(snapshot.data() as Map<String, dynamic>);
    }
  }
}
