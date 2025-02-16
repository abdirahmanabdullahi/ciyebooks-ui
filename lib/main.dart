import 'package:ciyebooks/data/repositories/auth/auth_repo.dart';
import 'package:ciyebooks/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'app.dart';

Future<void> main() async {debugPaintBaselinesEnabled:true;
  final WidgetsBinding widgetsBinding =
      WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform)
      .then((FirebaseApp value) => Get.put(AuthRepo));
  /// Get local storage
  await GetStorage.init();

  /// Await native splash until other items load.
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

///Initialize firebase and Auth repository
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform)
      .then(
    (FirebaseApp value) => Get.put(
      AuthRepo(),
    ),
  );

///Load all the material design/themes/localization/bindings
  runApp(const App());
}
