import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:project_poppin/controller/store_controller.dart';
import 'package:project_poppin/global/share_preference.dart';
import 'package:project_poppin/theme/colors.dart';
import 'package:shimmer/shimmer.dart';

import '../component/store_list_widget.dart';

class PopUpListNavPage extends StatefulWidget {
  const PopUpListNavPage({super.key});

  @override
  State<PopUpListNavPage> createState() => _PopUpListNavPageState();
}

class _PopUpListNavPageState extends State<PopUpListNavPage>
    with AutomaticKeepAliveClientMixin {
  ScrollController _scrollController = ScrollController();
  GlobalKey upScrollPosition = GlobalKey();
  GlobalKey downScrollPosition = GlobalKey();
  double hashTagSize = 170;
  bool endedPopUpState = prefs.getBool("endedPopUpState")!;
  bool clickStop = false;
  dynamic lastPopTime;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    _scrollController.addListener(scrollListener);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
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
                exit(0);
              }
            }
          },
          child: Scaffold(
            body: SingleChildScrollView(
              child: Column(
                key: downScrollPosition,
                children: [
                  Container(
                    margin: EdgeInsets.only(
                        left: 16,
                        right: 16,
                        top: MediaQuery.of(context).padding.top + 8),
                    decoration: BoxDecoration(
                        color: poppinColorGrey100,
                        borderRadius: BorderRadius.circular(8)),
                    padding: EdgeInsets.all(8),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text("${storeController.hashTageSetting}"),
                          ],
                        ),
                        SizedBox(
                          height: 12,
                        ),
                        SizedBox(
                          height: hashTagSize,
                          child: Scrollbar(
                            child: SingleChildScrollView(
                              child: Wrap(
                                spacing: 8.0, // Chip 간의 간격
                                runSpacing: 2.0, // 줄 간의 간격
                                children: List.generate(
                                    storeController.storeAllTagList.length,
                                    (index) {
                                  return ActionChip(
                                    onPressed: () {
                                      if (storeController.hashTageSetting ==
                                          storeController
                                              .storeAllTagList[index]) {
                                        storeController.setHashTagSetting("");
                                        storeController.getNavPageStoreAllList(
                                            endedPopUpState);
                                      } else {
                                        storeController.setHashTagSetting(
                                            storeController
                                                .storeAllTagList[index]);
                                        storeController.getHashTagStoreDateList(
                                            storeController.hashTageSetting,
                                            endedPopUpState);
                                      }
                                    },
                                    label: Text(
                                      "#${storeController.storeAllTagList[index]}",
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400),
                                    ),
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                        side: BorderSide(
                                            color: storeController
                                                        .hashTageSetting ==
                                                    storeController
                                                        .storeAllTagList[index]
                                                ? poppinColorGreen500
                                                : poppinColorGrey300)),
                                    padding: EdgeInsets.only(left: 4, right: 4),
                                  );
                                }),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 12,
                        ),
                        Text(
                          "전체 해시태그 보기",
                          style: TextStyle(
                              fontSize: 14, color: poppinColorDarkGrey400),
                        ),
                        SizedBox(
                          child: IconButton(
                              onPressed: () {
                                setState(() {
                                  if(hashTagSize == 170) {
                                    hashTagSize = MediaQuery.sizeOf(context).height;
                                  } else {
                                    hashTagSize = 170;
                                  }
                                });
                              },
                              icon: Icon(
                                Icons.arrow_drop_down,
                                size: 28,
                              )),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 24),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          onPressed: clickStop
                              ? null
                              : () async {
                                  setState(() {
                                    endedPopUpState = !endedPopUpState;
                                    prefs.setBool(
                                        "endedPopUpState", endedPopUpState);
                                  });
                                  clickStop = true;
                                  Future.delayed(Duration(milliseconds: 200),
                                      () {
                                    clickStop = false;
                                  });

                                  if (storeController.hashTageSetting == "") {
                                    storeController.getNavPageStoreAllList(
                                        endedPopUpState);
                                  } else {
                                    storeController.getHashTagStoreDateList(
                                        storeController.hashTageSetting,
                                        endedPopUpState);
                                  }
                                },
                          icon: Icon(
                            Icons.check_circle_sharp,
                            size: 32,
                          ),
                          color: endedPopUpState
                              ? poppinColorGreen500
                              : poppinColorGrey600,
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Text("종료된 팝업 제외")
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  storeController.storeNavPageAllList.isEmpty
                      ? storeController.tagListDataLoadStateEmpty
                          ? SizedBox(
                              child: Text(
                                "리스트가 없습니다",
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16,
                                    color: poppinColorDarkGrey500),
                              ),
                            )
                          : SizedBox(
                              height: MediaQuery.sizeOf(context).height * 0.8,
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
                      : SizedBox(
                          key: upScrollPosition,
                          height: MediaQuery.sizeOf(context).height*0.8,
                          child: ListView.builder(
                              controller: _scrollController,
                              itemCount:
                                  storeController.storeNavPageAllList.length,
                              padding:
                                  const EdgeInsets.only(left: 16, right: 16),
                              itemBuilder: (context, index) {
                                return StoreListWidget(
                                  storeData: storeController
                                      .storeNavPageAllList[index],
                                  index: index,
                                  storeController: storeController,
                                );
                              }),
                        )
                ],
              ),
            ),
          ));
    });
  }

  void scrollListener() {
    if (_scrollController.position.userScrollDirection ==
        ScrollDirection.reverse) {
      // 사용자가 위로 스크롤하는 중
      Scrollable.ensureVisible(
        upScrollPosition.currentContext!,
        duration: Duration(milliseconds: 300),
        alignment: 0
      );
    } else if (_scrollController.position.pixels == 0) {
      // 사용자가 아래로 스크롤하는 중
      Scrollable.ensureVisible(
          downScrollPosition.currentContext!,
          duration: Duration(milliseconds: 300),
          alignment: 0
      );
    }
  }
}
