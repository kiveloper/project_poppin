import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_poppin/theme/colors.dart';
import '../controller/store_controller.dart';
import 'home_page.dart';
import 'map_page.dart';
import 'my_page.dart';
import 'popup_list_page.dart';

class MainPageTabBar extends StatefulWidget {
  const MainPageTabBar({super.key});

  @override
  State<MainPageTabBar> createState() => _MainPageTabBarState();
}

class _MainPageTabBarState extends State<MainPageTabBar>
    with SingleTickerProviderStateMixin {
  StoreController storeController = Get.find();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(useMaterial3: true, fontFamily: 'noto'),
      home: DefaultTabController(
          length: 4,
          animationDuration: Duration.zero,
          child: GetBuilder<StoreController>(builder: (storeController) {
            return Scaffold(
                body: Stack(children: [
                  const TabBarView(
                      physics: NeverScrollableScrollPhysics(),
                      children: [
                        HomePage(),
                        MapPage(),
                        PopUpListPage(),
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
                bottomNavigationBar: Stack(
                  children: [
                    Container(
                      color: Colors.white,
                      height: MediaQuery.sizeOf(context).height * 0.08,
                      child: const TabBar(
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
                        unselectedLabelColor: Colors.black,
                        labelStyle: TextStyle(
                          fontSize: 12,
                        ),
                        tabs: [
                          Tab(
                            icon: Icon(Icons.home),
                            text: "홈",
                          ),
                          Tab(
                            icon: Icon(Icons.map),
                            text: '지도',
                          ),
                          Tab(
                            icon: Icon(Icons.list),
                            text: '팝업리스트',
                          ),
                          Tab(
                            icon: Icon(Icons.person),
                            text: '마이',
                          ),
                        ],
                      ),
                    ),
                    storeController.storeLoadState
                        ? Container(
                            width: double.infinity,
                            height: MediaQuery.sizeOf(context).height * 0.08,
                            decoration: BoxDecoration(
                              color:
                                  CupertinoColors.systemGrey.withOpacity(0.5),
                            ),
                          )
                        : const SizedBox(),
                  ],
                ));
          })),
    );
  }
}
