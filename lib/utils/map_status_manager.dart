import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:get/get.dart';

import '../controller/store_controller.dart';
import '../pages/store_detail_page.dart';
import '../services/analytics_helper.dart';
import '../vo/store_vo.dart';

class MapStatusManager {
  static final MapStatusManager instance = MapStatusManager._internal();

  factory MapStatusManager() => instance;

  MapStatusManager._internal();

  bool mapLoadFirst = true;
  List<NMarker> storeMarkerList = [];
  Map<String, NOverlayImage> markerImageMap = {
    "팝업 스토어" : const NOverlayImage.fromAssetImage("assets/icons/marker/marker_store.png"),
    "팝업 전시" : const NOverlayImage.fromAssetImage("assets/icons/marker/marker_exhibit.png"),
    "체험형 팝업" : const NOverlayImage.fromAssetImage("assets/icons/marker/marker_exp.png"),
    "팝업 레스토랑/카페" : const NOverlayImage.fromAssetImage("assets/icons/marker/marker_cafe.png")
  };

  void checkMapFirstLoad() {
    mapLoadFirst = false;
  }

  Future<void> setMarkerList(NaverMapController naverMapController,
      StoreController storeController) async {
    String currentMarker = "";

    for (StoreVo store in storeController.storeAllList) {
      var storeDB = store;

      NLatLng myLatLng =
          NLatLng(storeDB.geopoint!.latitude, storeDB.geopoint!.longitude);

      NMarker myLocationMarker =
          NMarker(id: storeDB.title!, position: myLatLng, icon: markerImageMap[storeDB.category]);
      myLocationMarker.setSize(const Size(30, 40.8));

      NInfoWindow infoWindow =
          NInfoWindow.onMarker(id: storeDB.title!, text: storeDB.title!);

      myLocationMarker.setOnTapListener((nMarker) {

        infoWindow.setOnTapListener((overlay) {
          storeController.setDetailStoreData(store);
          if(GetPlatform.isAndroid) {
            Get.to(() => const StoreDetailPage(), transition: Transition.leftToRight);

          } else {
            Get.to(() => const StoreDetailPage());
          }
        });

        if(currentMarker == nMarker.info.id) {
          naverMapController.clearOverlays(type: NOverlayType.infoWindow);
          currentMarker = "";
        } else {
          naverMapController.clearOverlays(type: NOverlayType.infoWindow);
          myLocationMarker.openInfoWindow(infoWindow);
          currentMarker = nMarker.info.id;
        }

        // GA4 분석용
        AnalyticsHelper().logEvent(
          'onClick_map_marker',
          {
            'screen_class': "map_page",
            'platform' : Platform.isAndroid ? 'android' : 'ios'
          },
        );

      });

      storeMarkerList.add(myLocationMarker);
    }

    naverMapController.addOverlayAll(Set.from(storeMarkerList));
  }

  Future<void> setMarkerDetailPage(
      NaverMapController naverMapController, StoreVo store) async {

    NLatLng myLatLng =
        NLatLng(store.geopoint!.latitude, store.geopoint!.longitude);

    NMarker myLocationMarker =
        NMarker(id: store.title!, position: myLatLng, icon: markerImageMap[store.category]);

    myLocationMarker.setSize(const Size(30, 40.8));

    NInfoWindow infoWindow =
        NInfoWindow.onMarker(id: store.title!, text: store.title!);

    naverMapController.addOverlay(myLocationMarker);

    myLocationMarker.openInfoWindow(infoWindow);
  }
}
