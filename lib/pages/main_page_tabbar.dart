import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_poppin/controller/tab_bar_controller.dart';
import 'package:project_poppin/theme/colors.dart';
import '../controller/store_controller.dart';
import 'home_page.dart';
import 'map_page.dart';
import 'my_page.dart';
import 'popup_list_nav_page.dart';

class MainPageTabBar extends StatefulWidget {
  const MainPageTabBar({super.key});

  @override
  State<MainPageTabBar> createState() => _MainPageTabBarState();
}

class _MainPageTabBarState extends State<MainPageTabBar>
    with SingleTickerProviderStateMixin {
  StoreController storeController = Get.find();
  late TabController tabController =
      TabController(length: 4, vsync: this, initialIndex: 0);

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
                  MyPage()
                ]),
            storeController.storeLoadState
                ? Container(
                    width: double.infinity,
                    height: double.infinity,
                    decoration: BoxDecoration(
                      color: CupertinoColors.systemGrey.withOpacity(0.5),
                    ),
                    child: const Center(
                        child: SizedBox(
                            width: 50,
                            height: 50,
                            child: CircularProgressIndicator())),
                  )
                : const SizedBox(),
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
                  padding: const EdgeInsets.only(top: 4),
                  child: TabBar(
                    controller: tabController,
                    onTap: (index) async {
                      tabBarController.setCurrentIndex(index);
                    },
                    //tab 하단 indicator size -> .label = label의 길이
                    //tab 하단 indicator size -> .tab = tab의 길이
                    indicatorSize: TabBarIndicatorSize.label,
                    //tab 하단 indicator color
                    indicatorColor: Colors.transparent,
                    //tab 하단 indicator weight
                    indicatorWeight: 1,
                    //label color
                    labelColor: poppinMainColor,
                    //unselected label color
                    unselectedLabelColor: CupertinoColors.systemGrey,
                    labelStyle: const TextStyle(
                      fontSize: 12,
                    ),
                    tabs: [
                      Tab(
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
                        iconMargin: EdgeInsets.only(bottom:4),
                        text: "홈",
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
                        iconMargin: EdgeInsets.only(bottom:4),
                        text: "팝업 리스트",
                      ),
                      Tab(
                        icon: tabBarController.currentIndex == 3
                            ? Image.asset(
                                'assets/icons/nav/mypage_icon.png',
                                width: 24,
                                height: 24,
                              )
                            : Image.asset(
                                'assets/icons/nav/none_select_mypage_icon.png',
                                width: 24,
                                height: 24,
                              ),
                        iconMargin: EdgeInsets.only(bottom:4),
                        text: "마이",
                      ),
                    ],
                  ),
                ),
                storeController.storeLoadState
                    ? Container(
                        width: double.infinity,
                        height: MediaQuery.sizeOf(context).height * 0.08,
                        decoration: BoxDecoration(
                          color: CupertinoColors.systemGrey.withOpacity(0.5),
                        ),
                      )
                    : const SizedBox(),
              ],
            );
          }));
    });
  }
}
