import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_poppin/component/population_store_list_widget.dart';
import 'package:project_poppin/controller/store_controller.dart';
import 'package:project_poppin/services/https_service.dart';
import 'package:project_poppin/theme/colors.dart';
import 'package:shimmer/shimmer.dart';

import '../utils/base64_manager.dart';
import 'store_detail_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin {
  StoreController storeController = Get.find();
  var num = 0;
  dynamic lastPopTime;

  late Timer _timer;
  HttpsService httpsService = HttpsService();

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    _startTimer();
    super.initState();
  }

  @override
  void dispose() {
    _stopTimer();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
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
            exit(0);
          }
        },
        child: GetBuilder<StoreController>(builder: (storeController) {
          return Scaffold(
              body: SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                          left: 16,
                          top: MediaQuery.of(context).padding.top + 8),
                      child: Image.asset(
                        "assets/images/seepop_logo.png",
                        width: 111,
                        height: 62,
                      ),
                    ),
                  ],
                ),
                storeController.recommendList.isEmpty
                    ? Shimmer.fromColors(
                        baseColor: const Color.fromRGBO(240, 240, 240, 1),
                        highlightColor: poppinColorGrey400,
                        child: Container(
                          margin: const EdgeInsets.only(left: 16, right: 16),
                          padding: const EdgeInsets.only(bottom: 16),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: const Color.fromRGBO(240, 240, 240, 1)),
                          height: 440,
                          width: MediaQuery.sizeOf(context).width,
                        ),
                      )
                    : GestureDetector(
                        onTap: () {
                          storeController.setDetailStoreData(
                              storeController.recommendStoreData);
                          if (Platform.isAndroid) {
                            Get.to(() => const StoreDetailPage(),
                                transition: Transition.leftToRight);
                          } else if (Platform.isIOS) {
                            Get.to(() => const StoreDetailPage());
                          }
                        },
                        child: Container(
                          margin: const EdgeInsets.only(left: 16, right: 16),
                          padding: const EdgeInsets.only(bottom: 16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.15),
                                spreadRadius: 5,
                                blurRadius: 7,
                                offset: const Offset(
                                    0, 3), // changes position of shadow
                              ),
                            ],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            children: [
                              ClipRRect(
                                  borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(10),
                                      topRight: Radius.circular(10)),
                                  child: Image.network(
                                    storeController.recommendStoreData.thumbnailImgUrl ?? "",
                                    height:
                                        MediaQuery.sizeOf(context).width * 0.8,
                                    width: MediaQuery.sizeOf(context).width,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      try {
                                        var base64file = base64Decoder(
                                            storeController.recommendStoreData
                                                    .thumbnailImgUrl ?? "");
                                        return Image.memory(base64file,
                                            width: 140,
                                            height: 140,
                                            gaplessPlayback: true,
                                            fit: BoxFit.cover);
                                      } catch (e) {
                                        return Image.asset(
                                            "assets/images/no_img.png",
                                            width: 140,
                                            height: 140,
                                            fit: BoxFit.cover);
                                      }
                                    },
                                  )),
                              const SizedBox(
                                height: 16,
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Expanded(
                                      child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 12, right: 12),
                                    child: Text(
                                      storeController
                                              .recommendStoreData.title ??
                                          "",
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                          color: poppinColorDarkGrey500,
                                          fontSize: 20),
                                    ),
                                  )),
                                ],
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Expanded(
                                      child: Container(
                                    padding: const EdgeInsets.only(
                                        left: 12, right: 12),
                                    height: 44,
                                    child: Text(
                                      storeController
                                              .recommendStoreData.summary ??"",
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w400,
                                          color: poppinColorDarkGrey400,
                                          fontSize: 12,
                                          overflow: TextOverflow.ellipsis),
                                      softWrap: true,
                                      maxLines: 2,
                                    ),
                                  )),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                const SizedBox(
                  height: 28,
                ),
                storeController.recommendPopularList.isEmpty
                    ? Container(
                        padding: const EdgeInsets.only(left: 16, right: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "인기 팝업·전시",
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.w700),
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            Container(
                              margin: const EdgeInsets.only(bottom: 8),
                              width: MediaQuery.sizeOf(context).width,
                              height: MediaQuery.sizeOf(context).height * 0.25,
                              child: ListView.builder(
                                  padding: const EdgeInsets.only(top: 8),
                                  scrollDirection: Axis.horizontal,
                                  shrinkWrap: true,
                                  itemCount: 2,
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
                            ),
                          ],
                        ),
                      )
                    : Container(
                        padding: const EdgeInsets.only(left: 16, right: 16),
                        width: double.infinity,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "인기 팝업·전시",
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.w700),
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            SizedBox(
                              height: MediaQuery.sizeOf(context).height * 0.25,
                              child: ListView.builder(
                                  padding: const EdgeInsets.only(top: 4),
                                  scrollDirection: Axis.horizontal,
                                  itemCount: storeController
                                      .recommendPopularList.length,
                                  itemBuilder: (context, index) {
                                    return PopulationStoreListWidget(
                                        storeData: storeController
                                            .recommendPopularList[index],
                                        storeController: storeController);
                                  }),
                            ),
                          ],
                        ),
                      ),
                storeController.recommendSeongsuList.isEmpty
                    ? Container(
                  padding: const EdgeInsets.only(left: 16, right: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "성수 팝업·전시",
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        width: MediaQuery.sizeOf(context).width,
                        height: MediaQuery.sizeOf(context).height * 0.25,
                        child: ListView.builder(
                            padding: const EdgeInsets.only(top: 8),
                            scrollDirection: Axis.horizontal,
                            shrinkWrap: true,
                            itemCount: 2,
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
                      ),
                    ],
                  ),
                )
                    : Container(
                  padding: const EdgeInsets.only(left: 16, right: 16),
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "성수 팝업·전시",
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      SizedBox(
                        height: MediaQuery.sizeOf(context).height * 0.25,
                        child: ListView.builder(
                            padding: const EdgeInsets.only(top: 4),
                            scrollDirection: Axis.horizontal,
                            itemCount: storeController
                                .recommendSeongsuList.length,
                            itemBuilder: (context, index) {
                              return PopulationStoreListWidget(
                                  storeData: storeController
                                      .recommendSeongsuList[index],
                                  storeController: storeController);
                            }),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ));
        }));
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(milliseconds: 3000), (timer) {
      setState(() {
        if (num < storeController.recommendList.length - 1) {
          num++;
        } else {
          num = 0;
        }
        storeController
            .setRecommendStoreData(storeController.recommendList[num]);
      });
    });
  }

  void _stopTimer() {
    _timer.cancel();
  }
}
