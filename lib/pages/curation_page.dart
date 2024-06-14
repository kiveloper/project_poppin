import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_poppin/component/store_list_widget.dart';
import 'package:project_poppin/controller/store_controller.dart';
import 'package:project_poppin/global/share_preference.dart';
import 'package:shimmer/shimmer.dart';

import '../theme/colors.dart';

class CurationPage extends StatefulWidget {
  const CurationPage({super.key});

  @override
  State<CurationPage> createState() => _CurationPageState();
}

class _CurationPageState extends State<CurationPage> {
  StoreController storeControllerMain = Get.find();
  dynamic lastPopTime;
  String userId = "";

  @override
  @override
  void initState() {
    if (prefs.getString("userId") != null &&
        storeControllerMain.curationServiceLoaded) {
      storeControllerMain.getCurationStoreData(
          prefs.getString("userId")!, storeControllerMain);
    }
    super.initState();
  }

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
          body: storeController.storeCurationList.isEmpty
              ? SingleChildScrollView(
                  child: prefs.getString("userId") == null
                      // userCuration data 가 계속 비어있는 상태일때
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                                height:
                                    MediaQuery.sizeOf(context).height * 0.20),
                            Image.asset("assets/images/poppin_logo.png"),
                            SizedBox(
                              height: 16,
                            ),
                            Text(
                              "큐레이션 결과를 보시려면\n"
                              "전달받으신 키를 입력해 주세요",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: poppinColorDarkGrey500,
                                  fontSize: 20),
                            ),
                            SizedBox(
                              height: 50,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 28, right: 28),
                              child: TextField(
                                onChanged: (text) {
                                  userId = text;
                                },
                                decoration: InputDecoration(
                                  hintText: '유저 코드를 입력하세요',
                                  contentPadding: EdgeInsets.symmetric(
                                      vertical: 8, horizontal: 12),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(32),
                                    borderSide:
                                        BorderSide(color: poppinColorGreen500),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(32),
                                    borderSide:
                                        BorderSide(color: poppinColorGreen500),
                                  ),
                                ),
                              ),
                            ),
                            storeController.curationCodeCheckInCorrect
                                ? Container(
                                    width: double.infinity,
                                    margin: EdgeInsets.only(left: 32, top: 4),
                                    child: Text(
                                      "정확한 코드를 입력해주세요",
                                      style: TextStyle(
                                          color: Colors.redAccent,
                                          fontSize: 12),
                                      textAlign: TextAlign.start,
                                    ))
                                : SizedBox(),
                            SizedBox(
                              height: 28,
                            ),
                            ElevatedButton(
                                onPressed: () {
                                  storeController.getCurationStoreData(
                                      userId, storeController);
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      poppinColorGreen500, // green500 색상으로 변경
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 12, right: 12),
                                  child: Text(
                                    "확인",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ))
                          ],
                        )
                      // userCuration data를 불러오는 중일때
                      : Column(
                          children: [
                            Container(
                              padding: EdgeInsets.only(
                                  top: MediaQuery.of(context).padding.top + 16),
                              child: Row(
                                children: [
                                  Shimmer.fromColors(
                                    baseColor:
                                        const Color.fromRGBO(240, 240, 240, 1),
                                    highlightColor: poppinColorGrey400,
                                    child: SizedBox(
                                      height: 24,
                                      width: MediaQuery.sizeOf(context).width *
                                          0.05,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 40,
                            ),
                            SizedBox(
                              width: MediaQuery.sizeOf(context).width,
                              height: MediaQuery.sizeOf(context).height * 0.9,
                              child: ListView.builder(
                                  itemCount: 8,
                                  padding: const EdgeInsets.only(
                                      left: 16, right: 16),
                                  itemBuilder: (context, index) {
                                    return Shimmer.fromColors(
                                      baseColor: const Color.fromRGBO(
                                          240, 240, 240, 1),
                                      highlightColor: poppinColorGrey400,
                                      child: Container(
                                        margin: const EdgeInsets.only(
                                            bottom: 20, left: 4, right: 4),
                                        padding: const EdgeInsets.only(
                                            left: 8,
                                            right: 8,
                                            top: 18,
                                            bottom: 18),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            color: const Color.fromRGBO(
                                                240, 240, 240, 1)),
                                        height: 158,
                                        width:
                                            MediaQuery.sizeOf(context).width *
                                                0.8,
                                      ),
                                    );
                                  }),
                            )
                          ],
                        ),
                )
              : Column(
                  children: [
                    Container(
                      padding: EdgeInsets.only(
                          top: MediaQuery.of(context).padding.top + 16),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              storeController.userInstaId ?? "",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 13,
                                  color: poppinColorGreen500),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    Expanded(
                      child: ListView.builder(
                          itemCount: storeController.storeCurationList.length,
                          padding: const EdgeInsets.only(left: 16, right: 16),
                          itemBuilder: (context, index) {
                            return StoreListWidget(
                              storeData:
                                  storeController.storeCurationList[index],
                              storeController: storeController,
                              index: index,
                            );
                          }),
                    )
                  ],
                ),
        );
      }),
    );
  }
}
