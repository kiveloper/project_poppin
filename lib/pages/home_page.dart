import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:project_poppin/controller/store_controller.dart';
import 'package:project_poppin/theme/colors.dart';
import 'package:project_poppin/vo/store_vo.dart';

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
            child: Column(
              children: [
                const Row(children: []),
                Stack(
                  children: [
                    Container(
                      height: MediaQuery.sizeOf(context).width,
                      padding: EdgeInsets.only(
                          top: MediaQuery.of(context).padding.top + 10),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: poppinSubColor,
                      ),
                    ),
                    Center(
                      child: GestureDetector(
                        onTap: () {
                          storeController.setDetailStartMapStoreData(storeController.recommendStoreVo);

                          Get.to(()=>StoreDetailPage(), transition: Transition.leftToRight);
                        },
                        child: Container(
                          margin: EdgeInsets.only(
                              top: MediaQuery.of(context).padding.top + 8,
                            left: 16,
                            right: 16
                          ),
                          decoration: BoxDecoration(
                              color: poppinMainColor,
                              borderRadius: BorderRadius.circular(10)),
                          child: Column(
                            children: [
                              ClipRRect(
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(10),
                                      topRight: Radius.circular(10)),
                                  child: Image.network(
                                    storeController.recommendStoreVo.thumbnailImgUrl??"",
                                    height:
                                        MediaQuery.sizeOf(context).width * 0.8,
                                    width: MediaQuery.sizeOf(context).width,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Image.asset(
                                        "assets/images/no_img.jpg",
                                        height: MediaQuery.sizeOf(context).width *
                                            0.8,
                                        width: MediaQuery.sizeOf(context).width,
                                        fit: BoxFit.cover,
                                      );
                                    },
                                  )),
                              SizedBox(
                                height: 20,
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Expanded(
                                      child: Padding(
                                    padding: const EdgeInsets.only(left: 12,right: 12),
                                    child: Text(
                                      "${storeController.recommendStoreVo.title??""}",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 20,
                                          color: Colors.white),
                                    ),
                                  )),
                                ],
                              ),
                              SizedBox(
                                height: 12,
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Expanded(
                                      child: Padding(
                                    padding: const EdgeInsets.only(left: 12, right: 12),
                                    child: Text(
                                      "${storeController.recommendStoreVo.summary??""}",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 12,
                                          color: Colors.white),
                                    ),
                                  )),
                                ],
                              ),
                              SizedBox(
                                height: 20,
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      }),
    );
  }
}
