import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../services/firebase_remote_config_service.dart';
import 'main_page_tabbar.dart';

class CheckVersionPage extends StatefulWidget {
  const CheckVersionPage({super.key});

  @override
  State<CheckVersionPage> createState() => _CheckVersionPageState();
}

class _CheckVersionPageState extends State<CheckVersionPage> {

  @override
  void initState() {
    checkVersionAndEmergency();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SizedBox(),
    );
  }

  Future<void> checkVersionAndEmergency() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String version = packageInfo.version;

    if (FirebaseRemoteConfigService().emergency ?? false) {
      if (FirebaseRemoteConfigService().version != version) {
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
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
                content: const Text(
                  "어플리케이션 업데이트를 진행해주세요!",
                ),
                actions: <Widget>[
                  TextButton(
                      onPressed: () async {
                        exit(0);
                      },
                      child: const Text(
                        "확인",
                      )),
                ],
              );
            }));
      } else {
        Get.off(() => const MainPageTabBar());
      }
    } else {
      Get.off(() => const MainPageTabBar());
    }
  }

}

