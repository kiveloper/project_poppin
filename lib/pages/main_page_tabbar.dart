import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_poppin/controller/tab_bar_controller.dart';
import 'package:project_poppin/theme/colors.dart';
import '../controller/store_controller.dart';
import 'home_page.dart';
import 'map_page.dart';
import 'curation_page.dart';
import 'popup_list_nav_page.dart';

class MainPageTabBar extends StatefulWidget {
  const MainPageTabBar({super.key});

  @override
  State<MainPageTabBar> createState() => _MainPageTabBarState();
}

class _MainPageTabBarState extends State<MainPageTabBar>
    with SingleTickerProviderStateMixin {
  StoreController storeController = Get.find();
  TabBarController tabBarController = Get.find();

  late TabController tabController =
      TabController(length: 4, vsync: this, initialIndex: 0);
  
  @override
  void initState() {
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage? message) {
      if (message != null) {
        if (message.notification != null) {
          if(message.data["type"] == "curation") {
            tabBarController.setCurrentIndex(3);
            tabController.index = 3;
          }
        }
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<StoreController>(builder: (storeController) {
      return Scaffold(
          body: Stack(children: [
            TabBarView(
                controller: tabController,
                physics: const NeverScrollableScrollPhysics(),
                children: const [
                  HomePage(),
                  MapPage(),
                  PopUpListNavPage(),
                  CurationPage()
                ]),
          ]),
          bottomNavigationBar:
              GetBuilder<TabBarController>(builder: (tabBarController) {
            return Stack(
              children: [
                Container(
                  height: MediaQuery.sizeOf(context).height * 0.08,
                  decoration: const BoxDecoration(
                      border: Border(
                          top: BorderSide(width: 1, color: poppinColorDarkGrey50)),
                      color: Colors.white),
                  padding: Platform.isAndroid
                      ? EdgeInsets.only(top: 4, right: MediaQuery.sizeOf(context).width * 0.02)
                      : EdgeInsets.only(top: 4, right: MediaQuery.sizeOf(context).width * 0.04),
                  child: TabBar(
                    controller: tabController,
                    onTap: (index) async {
                      tabBarController.setCurrentIndex(index);
                    },
                    indicatorSize: TabBarIndicatorSize.label,
                    indicatorColor: Colors.transparent,
                    indicatorWeight: 1,
                    labelColor: poppinMainColor,
                    unselectedLabelColor: CupertinoColors.systemGrey,
                    labelStyle: const TextStyle(fontSize: 12,),
                    tabs: [
                      Padding(
                        padding: const EdgeInsets.only(left: 24),
                        child: Tab(
                          icon: tabBarController.currentIndex == 0
                              ? Image.asset(
                                  'assets/icons/nav/home_icon.png',
                                  width: 24,
                                  height: 24,
                                )
                              : Image.asset(
                                  'assets/icons/nav/none_select_home_icon.png',
                                  width: 24,
                                  height: 24,
                                ),
                          iconMargin: const EdgeInsets.only(bottom:4),
                          text: "홈",
                        ),
                      ),
                      Tab(
                        icon: tabBarController.currentIndex == 1
                            ? Image.asset(
                                'assets/icons/nav/map_icon.png',
                                width: 20,
                                height: 20,
                              )
                            : Image.asset(
                                'assets/icons/nav/none_select_map_icon.png',
                                width: 20,
                                height: 20,
                              ),
                        iconMargin: const EdgeInsets.only(bottom:4),
                        text: "지도",
                      ),
                      Tab(
                        icon: tabBarController.currentIndex == 2
                            ? Image.asset(
                                'assets/icons/nav/list_icon.png',
                                width: 24,
                                height: 24,
                              )
                            : Image.asset(
                                'assets/icons/nav/none_select_list_icon.png',
                                width: 24,
                                height: 24,
                              ),
                        iconMargin: const EdgeInsets.only(bottom:4),
                        text: "팝업 리스트",
                      ),
                      Tab(
                        icon: tabBarController.currentIndex == 3
                            ? Image.asset(
                                'assets/icons/nav/curation_icon.png',
                                width: 24,
                                height: 24,
                              )
                            : Image.asset(
                                'assets/icons/nav/none_select_curation_icon.png',
                                width: 24,
                                height: 24,
                              ),
                        iconMargin: const EdgeInsets.only(bottom:4),
                        text: "맞춤",
                      ),
                    ],
                  ),
                ),
              ],
            );
          }));
    });
  }
}