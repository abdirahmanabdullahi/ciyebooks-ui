import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'app.dart';

Future<void> main() async {
  final WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();


  // Get local storage
  await GetStorage.init();

  // Await native splash until other items load.
  // FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);


//Initialize firebase and Auth repository
// await Firebase.initializeApp(options:DefaultFirebaseOptions.currentPlatform)

  // .then((FirebaseApp value)=>Get.put(AuthRepo(),),);


//Load all the material design/themes/localization/bindings
  runApp(const App());
}
