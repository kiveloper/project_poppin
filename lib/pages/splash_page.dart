import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_poppin/controller/store_controller.dart';
import 'package:project_poppin/pages/main_page_tabbar.dart';

import '../services/firebase_remote_config_service.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {

  StoreController storeController = Get.find();

  @override
  void initState() {
    _fetchData();
    super.initState();
  }

  Future<void> _fetchData() async {
    await storeController.getPopUpData();
    checkVersionAndEmergency();
    storeController.setStoreLoadState(false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Image.asset("assets/images/poppin_logo.jpg", height: 150, width: 150,)
      ),
    );
  }

  Future<void> checkVersionAndEmergency() async {
    if(FirebaseRemoteConfigService().emergency??false) {
      showDialog(
          context: context,
          barrierDismissible: true,
          builder: ((context) {
            return AlertDialog(
              title: const Text(
                "긴급 업데이트",
              ),
              surfaceTintColor: Colors.white,
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius:BorderRadius.circular(8)),
              content: const Text("어플리케이션 업데이트를 진행해주세요!",),
              actions: <Widget>[
                Container(
                  child: TextButton(
                      onPressed: () async {
                        exit(0);
                      },
                      child: const Text(
                        "확인",
                      )),
                ),
              ],
            );
          }));
    } else {
      Get.off(()=> const MainPageTabBar());
    }
  }

}
