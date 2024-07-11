
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:project_poppin/controller/location_controller.dart';
import 'package:project_poppin/controller/store_controller.dart';
import 'package:project_poppin/controller/tab_bar_controller.dart';
import 'package:project_poppin/pages/check_version_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'firebase_options.dart';
import 'global/share_preference.dart';
import 'services/firebase_remote_config_service.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown
  ]);

  await dotenv.load(fileName: ".env");
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  FirebaseRemoteConfigService().initRemoteConfig();

  prefs = await SharedPreferences.getInstance();

  if(prefs.getBool("endedPopUpState") == null) {
    prefs.setBool("endedPopUpState", true);
  }

  Get.put(StoreController());
  Get.put(LocationController());
  Get.put(TabBarController());

  NaverMapSdk.instance.initialize(clientId: dotenv.env['naverMapClientId']);

  FirebaseMessaging.instance.requestPermission(
      badge: true,
      alert: true,
      sound: true
  );

  loadData();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xffFAF9F9),
        useMaterial3: true,
        fontFamily: 'noto'
      ),
      home: const CheckVersionPage(),
    );
  }
}

void loadData() async {
  StoreController storeController = Get.find();

  storeController.getRecommendPopularList();
  storeController.getRecommendSeoungSuList();
  storeController.getRecommendList();
  storeController.getStoreAllList();
  storeController.getNavPageStoreAllList(prefs.getBool("endedPopUpState")!);
  storeController.getStoreAllTags();
  storeController.getBannerData();
}