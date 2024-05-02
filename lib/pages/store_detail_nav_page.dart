import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:get/get.dart';
import 'package:project_poppin/controller/store_controller.dart';
import 'package:project_poppin/utils/map_status_manager.dart';
import 'package:project_poppin/utils/time_stamp_manager.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../theme/colors.dart';
import '../utils/base64_manager.dart';
import '../utils/user_share_manager.dart';

class StoreDetailNavPage extends StatefulWidget {
  const StoreDetailNavPage({super.key});

  @override
  State<StoreDetailNavPage> createState() => _StoreDetailNavPageState();
}

class _StoreDetailNavPageState extends State<StoreDetailNavPage> {
  MapStatusManager mapStatusManager = MapStatusManager();
  GlobalKey goTop = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<StoreController>(builder: (storeController) {
      return Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.only(
                  top: MediaQuery.of(context).padding.top + 10
                ),
                margin: EdgeInsets.only(left: 4),
                child: Row(
                  key: goTop,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    IconButton(
                        onPressed: () {
                          storeController.setStoreDetailState(false);
                        },
                        icon: Icon(Icons.arrow_back_ios)),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Column(
                  children: [
                    SizedBox(
                      width: MediaQuery.sizeOf(context).width,
                      height: MediaQuery.sizeOf(context).width*0.90,
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network(
                            storeController.detailStoreNavData.thumbnailImgUrl!,
                            width: MediaQuery.sizeOf(context).width,
                            height: MediaQuery.sizeOf(context).width*0.90,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              try {
                                return Image.memory(
                                    base64Decoder(storeController.detailStoreNavData.thumbnailImgUrl!),
                                    width: MediaQuery.sizeOf(context).width,
                                    height: MediaQuery.sizeOf(context).width*0.90,
                                    fit: BoxFit.cover);
                              } catch (e) {
                                return Image.asset(
                                  "assets/images/no_img.jpg",
                                  width: MediaQuery.sizeOf(context).width,
                                  height: MediaQuery.sizeOf(context).width*0.90,
                                  fit: BoxFit.cover,
                                );
                              }
                            },
                          )),
                    ),
                    SizedBox(
                      height: 28,
                    ),
                    Text(
                      "팝업정보",
                      style: TextStyle(color: poppinSubColor),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Container(
                      height: 2,
                      width: MediaQuery.sizeOf(context).width - 50,
                      color: poppinSubColor,
                    ),
                    SizedBox(
                      height: 28,
                    ),
                    Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                storeController.detailStoreNavData.title!,
                                style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.w700,
                                    overflow: TextOverflow.ellipsis),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.share,
                                color: poppinSubColor,
                              ),
                              onPressed: () async {
                                share(
                                  storeController.detailStoreNavData.title!,
                                  storeController.detailStoreNavData.description!,
                                  storeController
                                      .detailStoreNavData.relatedContentsUrl!,
                                );
                              },
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 12,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Expanded(
                                child: Text(
                                  "${storeController.detailStoreNavData.description!}",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500, fontSize: 15),
                                )),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.location_on_outlined,
                              color: poppinMainColor,
                            ),
                            SizedBox(
                              width: 4,
                            ),
                            Expanded(
                                child: Text(
                                    "${storeController.detailStoreNavData.address!}")),
                          ],
                        ),
                        SizedBox(
                          height: 12,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.calendar_month_outlined,
                              color: poppinMainColor,
                            ),
                            SizedBox(
                              width: 4,
                            ),
                            Expanded(
                                child: Text(
                                    "${timeStampToDate(storeController.detailStoreNavData.startDate!)}~${timeStampToDate(storeController.detailStoreNavData.endDate!)}")),
                          ],
                        ),
                        SizedBox(
                          height: 40,
                        ),
                        IconButton(
                            padding: EdgeInsets.zero,
                            onPressed: () async {
                              await launchUrlString(storeController
                                  .detailStoreNavData.relatedContentsUrl!);
                            },
                            splashRadius: 1,
                            highlightColor: Colors.black,
                            style: IconButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10))),
                            icon: Image.asset(
                              "assets/button/detail_link_button.png",
                            )),
                        SizedBox(
                          height: 80,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Expanded(
                                child: Text(
                                  "팝업 스토어 위치",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w400, fontSize: 16),
                                )),
                            IconButton(
                                onPressed: () {
                                  Scrollable.ensureVisible(goTop.currentContext!,
                                      duration: const Duration(milliseconds: 300),
                                      curve: Curves.easeInOut,
                                      alignment: 0);
                                },
                                icon: Icon(Icons.keyboard_arrow_up))
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        storeController.detailStoreNavData.geopoint != null
                            ? SizedBox(
                          width: double.infinity,
                          height: MediaQuery.sizeOf(context).height * 0.2,
                          child: NaverMap(
                            options: NaverMapViewOptions(
                              initialCameraPosition: NCameraPosition(
                                target: NLatLng(
                                    storeController.detailStoreNavData
                                        .geopoint!.latitude,
                                    storeController.detailStoreNavData
                                        .geopoint!.longitude),
                                zoom: 13,
                              ),
                              extent: const NLatLngBounds(
                                southWest: NLatLng(31.43, 122.37),
                                northEast: NLatLng(44.35, 132.0),
                              ),
                              logoAlign: NLogoAlign.rightBottom,
                              logoMargin: const EdgeInsets.all(10),
                              liteModeEnable: true,
                            ),
                            onMapReady: (controller) async {
                              mapStatusManager.setMarkerDetailPage(controller,
                                  storeController.detailStoreData);
                            },
                          ),
                        )
                            : SizedBox(),
                        SizedBox(
                          height: 4,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            SizedBox(
                              height: 30,
                              child: TextButton(
                                onPressed: () {
                                  Clipboard.setData(ClipboardData(
                                      text:
                                      "${storeController.detailStoreData.address}"));
                                },
                                child: Text("주소 복사",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w400, fontSize: 12)),
                                style: TextButton.styleFrom(
                                  minimumSize: Size.zero,
                                  padding: EdgeInsets.all(4),
                                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 40,
                        ),
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      );
    });
  }
}
