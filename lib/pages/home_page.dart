import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_poppin/component/population_store_list_widget.dart';
import 'package:project_poppin/controller/store_controller.dart';
import 'package:project_poppin/utils/base64_manager.dart';

import 'store_detail_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var lastPopTime;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (bool didPop) {
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
      },
      child: GetBuilder<StoreController>(builder: (storeController) {
        return Scaffold(
          body: SingleChildScrollView(
            child: Container(
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top+4,left: 16),
                    child: Row(children: [
                      Text("LOGO", style: TextStyle(fontSize: 18),)
                    ]),
                  ),
                  GestureDetector(
                    onTap: () {
                      storeController.setDetailStoreData(
                          storeController.storeAllList[0]
                      );
                      Get.to(() => StoreDetailPage(),
                          transition: Transition.leftToRight
                      );
                    },
                    child: Container(
                      margin: EdgeInsets.only(
                          top: 20,
                          left: 16,
                          right: 16),
                      padding: EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.15),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: Offset(0, 3), // changes position of shadow
                          ),
                        ],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        children: [
                          ClipRRect(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  topRight: Radius.circular(10)),
                              child: Image.network(
                                storeController
                                        .storeAllList[0].thumbnailImgUrl ??
                                    "",
                                height: MediaQuery.sizeOf(context).width * 0.8,
                                width: MediaQuery.sizeOf(context).width,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Image.asset(
                                    "assets/images/no_img.jpg",
                                    height:
                                        MediaQuery.sizeOf(context).width * 0.8,
                                    width: MediaQuery.sizeOf(context).width,
                                    fit: BoxFit.cover,
                                  );
                                },
                              )),
                          SizedBox(
                            height: 16,
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Expanded(
                                  child: Padding(
                                padding:
                                    const EdgeInsets.only(left: 12, right: 12),
                                child: Text(
                                  "${storeController.storeAllList[0].title ?? ""}",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 20),
                                ),
                              )),
                            ],
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Expanded(
                                  child: Padding(
                                padding:
                                    const EdgeInsets.only(left: 12, right: 12),
                                child: Text(
                                  "${storeController.storeAllList[0].summary ?? ""}",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w300,
                                      fontSize: 12),
                                ),
                              )),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 28,
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 16, right: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "인기 팝업·전시",
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w700),
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        Container(
                          margin: EdgeInsets.only(bottom: 8),
                          width: MediaQuery.sizeOf(context).width,
                          height: MediaQuery.sizeOf(context).height * 0.25,
                          child: ListView.builder(
                              padding: EdgeInsets.only(top: 8),
                              scrollDirection: Axis.horizontal,
                              shrinkWrap: true,
                              itemCount: 2,
                              itemBuilder: (context, index) {
                                return PopulationStoreListWidget(
                                    storeData: storeController.storeAllList[0], storeController: storeController,);
                              }),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      }),
    );
  }

}
