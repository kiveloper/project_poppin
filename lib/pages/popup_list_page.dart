import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:project_poppin/component/store_list_widget.dart';
import 'package:project_poppin/controller/store_controller.dart';
import 'package:project_poppin/global/share_preference.dart';
import 'package:project_poppin/pages/location_select_page.dart';
import 'package:project_poppin/pages/store_detail_page.dart';

class PopUpListPage extends StatefulWidget {
  const PopUpListPage({super.key});

  @override
  State<PopUpListPage> createState() => _PopUpListPageState();
}

class _PopUpListPageState extends State<PopUpListPage> {
  var lastPopTime;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<StoreController>(builder: (storeController) {
      return PopScope(
          canPop: false,
          onPopInvoked: (bool didPop) {
            if (storeController.storeDetailState) {
              storeController
                  .setStoreDetailState(!storeController.storeDetailState);
            } else {
              final now = DateTime.now();
              if (lastPopTime == null ||
                  now.difference(lastPopTime) > const Duration(seconds: 2)) {
                lastPopTime = now;
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('뒤로 버튼을 한번 더 누르면 앱이 종료됩니다.'),
                  ),
                );
                return;
              } else {
                // 두 번 연속으로 뒤로가기 버튼을 누르면 앱 종료
                exit(0);
              }
            }
          },
          child: storeController.storeDetailState
              ? const StoreDetailPage()
              : Scaffold(
                  body: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.only(
                            top: MediaQuery.of(context).padding.top + 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: 32,
                              height: 32,
                            ),
                            Expanded(
                              child: Text(
                                "${prefs.getStringList('local2')??["서울"]} 팝업",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontWeight: FontWeight.w600, fontSize: 18
                                ),
                              ),
                            ),
                            IconButton(
                                onPressed: () {
                                  Get.to(() => LocationSelectPage(),
                                      transition:
                                          Transition.leftToRightWithFade);
                                },
                                icon: Icon(
                                  Icons.location_on,
                                  size: 32,
                                )),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      storeController.storeFilterLocationList.isEmpty
                          ? SizedBox()
                          : Expanded(
                              child: ListView.builder(
                                  itemCount: storeController.storeFilterLocationList.length,
                                  padding: EdgeInsets.only(left: 16, right: 16),
                                  itemBuilder: (context, index) {
                                    return StoreListWidget(
                                      storeData:
                                          storeController.storeFilterLocationList[index],
                                      index: index,
                                    );
                                  }))
                    ],
                  ),
                )
      );
    });
  }
}
