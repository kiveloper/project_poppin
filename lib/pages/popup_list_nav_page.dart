import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:project_poppin/component/store_list_nav_widget.dart';
import 'package:project_poppin/controller/store_controller.dart';
import 'package:project_poppin/global/share_preference.dart';
import 'package:project_poppin/pages/location_select_page.dart';
import 'package:project_poppin/pages/store_detail_nav_page.dart';
import 'package:project_poppin/theme/colors.dart';

class PopUpListNavPage extends StatefulWidget {
  const PopUpListNavPage({super.key});

  @override
  State<PopUpListNavPage> createState() => _PopUpListNavPageState();
}

class _PopUpListNavPageState extends State<PopUpListNavPage> {
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
              ? const StoreDetailNavPage()
              : Scaffold(
                  body: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.only(
                            top: MediaQuery.of(context).padding.top + 10),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                "팝업 리스트",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontWeight: FontWeight.w700, fontSize: 13, color: poppinColorGreen500
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      storeController.storeAllList.isEmpty
                          ? Center(child: Text("진행중인 팝업이 없습니다", style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),),)
                          : Expanded(
                              child: ListView.builder(
                                  itemCount: storeController.storeAllList.length,
                                  padding: EdgeInsets.only(left: 16, right: 16),
                                  itemBuilder: (context, index) {
                                    return StoreListNavWidget(
                                      storeData:
                                          storeController.storeAllList[index],
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
