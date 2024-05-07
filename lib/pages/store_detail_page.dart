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

class StoreDetailPage extends StatefulWidget {
  const StoreDetailPage({super.key});

  @override
  State<StoreDetailPage> createState() => _StoreDetailPageState();
}

class _StoreDetailPageState extends State<StoreDetailPage> {
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
                    top: MediaQuery.of(context).padding.top + 10),
                margin: const EdgeInsets.only(left: 4),
                child: Row(
                  key: goTop,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(Icons.arrow_back_ios)),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Column(
                  children: [
                    SizedBox(
                      width: MediaQuery.sizeOf(context).width,
                      height: MediaQuery.sizeOf(context).width * 0.90,
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network(
                            storeController.detailStoreData.thumbnailImgUrl!,
                            width: MediaQuery.sizeOf(context).width,
                            height: MediaQuery.sizeOf(context).width*0.90,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              try {
                                return Image.memory(
                                    base64Decoder(storeController.detailStoreData.thumbnailImgUrl!),
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
                    const SizedBox(
                      height: 28,
                    ),
                    const Text(
                      "팝업정보",
                      style: TextStyle(
                          color: poppinColorGreen500,
                          fontWeight: FontWeight.w600,
                          fontSize: 14),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Container(
                      height: 2,
                      color: poppinColorGreen500,
                    ),
                    const SizedBox(
                      height: 28,
                    ),
                    Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                storeController.detailStoreData.title!,
                                style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.w600,
                                    color: poppinColorDarkGrey600,
                                    overflow: TextOverflow.ellipsis),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.share_outlined,
                                color: poppinColorGreen500,
                              ),
                              onPressed: () async {
                                share(
                                  storeController.detailStoreData.title!,
                                  storeController.detailStoreData.description!,
                                  storeController
                                      .detailStoreData.relatedContentsUrl!,
                                );
                              },
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Expanded(
                                child: Text(
                              storeController.detailStoreData.description!,
                              style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 15,
                                  color: poppinColorDarkGrey500),
                            )),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(
                              Icons.location_on_outlined,
                              size: 17,
                              color: poppinColorGreen400,
                            ),
                            const SizedBox(
                              width: 4,
                            ),
                            Expanded(
                                child: Text(
                              storeController.detailStoreData.address!,
                              style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 12,
                                  color: poppinColorDarkGrey600),
                            )),
                          ],
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const Icon(
                              Icons.calendar_month_outlined,
                              color: poppinColorGreen400,
                              size: 17,
                            ),
                            const SizedBox(
                              width: 4,
                            ),
                            Expanded(
                                child: Text(
                              "${timeStampToDate(storeController.detailStoreData.startDate!)}~${timeStampToDate(storeController.detailStoreData.endDate!)}",
                              style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 12,
                                  color: poppinColorDarkGrey600),
                            )),
                          ],
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                              onPressed: () async {
                                await launchUrlString(storeController
                                    .detailStoreData.relatedContentsUrl!);
                              },
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: poppinColorGreen500,
                                  foregroundColor: poppinColorGreen600,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8))),
                              child: const Padding(
                                padding:
                                    EdgeInsets.only(top: 16, bottom: 16),
                                child: Text(
                                  "상세 정보 보러가기",
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.white),
                                ),
                              )),
                        ),
                        const SizedBox(
                          height: 80,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            const Expanded(
                                child: Text(
                              "팝업 스토어 위치",
                              style: TextStyle(
                                  fontWeight: FontWeight.w400, fontSize: 16),
                            )),
                            IconButton(
                                onPressed: () {
                                  Scrollable.ensureVisible(
                                      goTop.currentContext!,
                                      duration:
                                          const Duration(milliseconds: 300),
                                      curve: Curves.easeInOut,
                                      alignment: 0);
                                },
                                icon: const Icon(Icons.keyboard_arrow_up))
                          ],
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        storeController.detailStoreData.geopoint != null
                            ? SizedBox(
                                width: double.infinity,
                                height:
                                    MediaQuery.sizeOf(context).height * 0.28,
                                child: NaverMap(
                                  options: NaverMapViewOptions(
                                      initialCameraPosition: NCameraPosition(
                                        target: NLatLng(
                                            storeController.detailStoreData
                                                .geopoint!.latitude,
                                            storeController.detailStoreData
                                                .geopoint!.longitude),
                                        zoom: 13,
                                      ),
                                      extent: const NLatLngBounds(
                                        southWest: NLatLng(31.43, 122.37),
                                        northEast: NLatLng(44.35, 132.0),
                                      ),
                                      logoAlign: NLogoAlign.rightBottom,
                                      logoMargin: const EdgeInsets.all(10),
                                      liteModeEnable: true),
                                  onMapReady: (controller) async {
                                    mapStatusManager.setMarkerDetailPage(
                                        controller,
                                        storeController.detailStoreData);
                                  },
                                ),
                              )
                            : const SizedBox(
                                child: Text("null임"),
                              ),
                        const SizedBox(
                          height: 4,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            SizedBox(
                              child: TextButton(
                                onPressed: () {
                                  Clipboard.setData(ClipboardData(
                                      text:
                                          "${storeController.detailStoreData.address}"));
                                },
                                style: TextButton.styleFrom(
                                  minimumSize: Size.zero,
                                  padding: const EdgeInsets.all(4),
                                  tapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                ),
                                child: const Text("주소 복사",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 12,
                                        color: Colors.black)),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
