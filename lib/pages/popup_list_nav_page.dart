import 'dart:async';
import 'dart:io';

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
  final ScrollController _scrollController = ScrollController();
  StoreController storeControllerManager = Get.find();
  GlobalKey upScrollPosition = GlobalKey();
  GlobalKey downScrollPosition = GlobalKey();
  double hashTagSize = 100;
  bool endedPopUpState = prefs.getBool("endedPopUpState")!;
  bool clickStop = false;
  bool hashTagExtendState = false;
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
                    padding: EdgeInsets.only(
                        top: MediaQuery.of(context).padding.top + 16),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "팝업 리스트",
                          maxLines: 1,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 13,
                              color: poppinColorGreen500),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 16, right: 16, top: 20),
                    decoration: BoxDecoration(
                        color: poppinColorGrey100,
                        borderRadius: BorderRadius.circular(8)),
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      children: [
                        Padding(
                          padding:
                              const EdgeInsets.only(left: 8, right: 8, top: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              storeController.hashTageSetting == ""
                                  ? const Text(
                                      "해시태그를 선택해주세요",
                                      style: TextStyle(
                                          fontSize: 13,
                                          color: poppinColorDarkGrey500,
                                          fontWeight: FontWeight.w600),
                                    )
                                  : Text(
                                      "# ${storeController.hashTageSetting}",
                                      style: const TextStyle(
                                          fontSize: 13,
                                          color: poppinColorDarkGrey500,
                                          fontWeight: FontWeight.w600),
                                    ),
                              RichText(
                                  text: TextSpan(
                                      text:
                                          "${storeController.storeAllTagList.length}",
                                      style: const TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w400,
                                          color: poppinColorGreen500),
                                      children: const <TextSpan>[
                                    TextSpan(
                                        text: ' 개의 해시태그가 있어요',
                                        style: TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.w400,
                                            color: poppinColorDarkGrey500))
                                  ]))
                            ],
                          ),
                        ),
                        const SizedBox(
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
                                    onPressed: storeController.tagButtonActivate
                                        ? () => _onPressed(storeController,
                                            index, endedPopUpState)
                                        : null,
                                    label: Text(
                                      "#${storeController.storeAllTagList[index]}",
                                      style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400,
                                          color: poppinColorDarkGrey500),
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
                                    padding: const EdgeInsets.only(
                                        left: 4, right: 4),
                                  );
                                }),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        Text(
                          hashTagExtendState ? "전체 해시태그 접기" : "전체 해시태그 보기",
                          style: const TextStyle(
                              fontSize: 14, color: poppinColorDarkGrey400),
                        ),
                        SizedBox(
                            child: IconButton(
                                onPressed: () {
                                  setState(() {
                                    if (hashTagSize == 100) {
                                      hashTagSize =
                                          MediaQuery.sizeOf(context).height *
                                              0.65;
                                      hashTagExtendState = true;
                                    } else {
                                      hashTagSize = 100;
                                      hashTagExtendState = false;
                                    }
                                  });
                                },
                                icon: hashTagExtendState
                                    ? const Icon(
                                        Icons.arrow_drop_up_rounded,
                                        size: 28,
                                      )
                                    : const Icon(
                                        Icons.arrow_drop_down_rounded,
                                        size: 28,
                                      )))
                      ],
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(right: 24, top: 8, bottom: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          onPressed: clickStop
                              ? null
                              : () async {
                            storeController.setStoreNavPageAllListClean();
                                  setState(() {
                                    endedPopUpState = !endedPopUpState;
                                    prefs.setBool(
                                        "endedPopUpState", endedPopUpState);
                                  });
                                  clickStop = true;
                                  Future.delayed(
                                      const Duration(milliseconds: 1000), () {
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
                          icon: Image.asset(
                            endedPopUpState
                                ? "assets/button/select_hashtag_button.png"
                                : "assets/button/no_select_hashtag_button.png",
                            width: 32,
                            height: 32,
                          ),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        const Text("종료된 팝업 제외")
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  storeController.storeNavPageAllList.isEmpty
                      ? storeController.tagListDataLoadStateEmpty
                          ? const SizedBox(
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
                          height: MediaQuery.sizeOf(context).height * 0.8,
                          child: ListView.builder(
                              controller: _scrollController,
                              physics: const ClampingScrollPhysics(),
                              itemCount:
                                  storeController.storeNavPageAllList.length + (storeController.loadDataState ?1 :0),
                              padding:
                                  const EdgeInsets.only(left: 16, right: 16, bottom: 8),
                              itemBuilder: (context, index) {
                                if (index == storeController.storeNavPageAllList.length) {
                                  return Center(
                                    child: CircularProgressIndicator(),
                                  );
                                }
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
      Scrollable.ensureVisible(upScrollPosition.currentContext!,
          duration: const Duration(milliseconds: 150), alignment: 0);
    }

    if (_scrollController.position.pixels == 0) {
      // 사용자가 아래로 스크롤하는 중
      Scrollable.ensureVisible(downScrollPosition.currentContext!,
          duration: const Duration(milliseconds: 150), alignment: 0);
    }

    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      // 여기에 바닥에 도달했을 때 실행할 코드를 작성
      setState(() {
        storeControllerManager.loadDataState = true;
      });
      storeControllerManager.getNavPageStoreAllList(endedPopUpState);
    }
  }

  void _onPressed(
      StoreController storeController, int index, bool endedPopUpState) {
    if (storeController.hashTageSetting ==
        storeController.storeAllTagList[index]) {
      storeController.setHashTagSetting("");
      storeController.setStoreNavPageAllListClean();
      storeController.getNavPageStoreAllList(endedPopUpState);
    } else {
      storeController.setHashTagSetting(storeController.storeAllTagList[index]);
      storeController.getHashTagStoreDateList(
          storeController.hashTageSetting, endedPopUpState);
    }

    setState(() {
      if (hashTagSize != 100) {
        hashTagSize = 100;
        hashTagExtendState = false;
      }
    });
  }
}
