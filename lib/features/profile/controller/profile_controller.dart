import 'package:ciyebooks/features/auth/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
class ProfileController extends GetxController {
  static ProfileController get instance => Get.find();

  Rx<UserModel> user = UserModel.empty().obs;
  final bankEnabled = true.obs;
  final isDarkMode = true.obs;
  final forexEnabled = true.obs;


  @override
  void onInit() {
    getUserData();
    super.onInit();


  }
  Future<void>getUserData()async{

    final uid = FirebaseAuth.instance.currentUser?.uid;
    final userDate = await FirebaseFirestore.instance.collection('users').doc(uid).get();
    if(userDate.exists){
      user.value = UserModel.fromJson(userDate.data() as Map<String,dynamic>);

    }
  }
}