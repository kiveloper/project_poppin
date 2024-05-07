import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:get/get.dart';
import 'package:project_poppin/pages/store_detail_page.dart';

import '../controller/store_controller.dart';
import '../vo/store_vo.dart';

class MapStatusManager {
  static final MapStatusManager instance = MapStatusManager._internal();

  factory MapStatusManager() => instance;

  MapStatusManager._internal();

  bool mapLoadFirst = true;
  NCameraPosition? nCameraPosition;
  List<NAddableOverlay> storeMarkerList = [];

  void checkMapFirstLoad() {
    mapLoadFirst = false;
  }

  void currentCameraPosition(NCameraPosition? currentCameraPosition) async {
    nCameraPosition = currentCameraPosition;
  }

  Future<void> setMarkerList(NaverMapController naverMapController,
      StoreController storeController) async {
    List<NAddableOverlay> overlay = [];

    storeMarkerList.clear();

    NOverlayImage image = const NOverlayImage.fromAssetImage(
        "assets/icons/marker/store_marker(100).png");

    for (StoreVo store in storeController.storeAllList) {
      NLatLng myLatLng =
          NLatLng(store.geopoint!.latitude, store.geopoint!.longitude);

      NMarker myLocationMarker =
          NMarker(id: store.title!, position: myLatLng, icon: image);

      NInfoWindow infoWindow =
          NInfoWindow.onMarker(id: store.title!, text: store.title!);

      myLocationMarker.setSize(const Size(18, 27));

      myLocationMarker.setOnTapListener((nMarker) {
        infoWindow.setOnTapListener((overlay) {
          storeController.setDetailStoreData(store);
          Get.to(() => const StoreDetailPage());
        });

        naverMapController.clearOverlays(type: NOverlayType.infoWindow);
        myLocationMarker.openInfoWindow(infoWindow);
      });

      overlay.add(myLocationMarker);
      myLocationMarker.setIsVisible(false);
    }

    Set<NAddableOverlay> setOverlay = Set.from(overlay);
    storeMarkerList = overlay;

    naverMapController.addOverlayAll(setOverlay);
  }

  void visibleManager() {
    for (var marker in storeMarkerList) {
      marker.setIsVisible(true);
    }
  }

  Future<void> setMarkerDetailPage(NaverMapController naverMapController,
      StoreVo store) async {
    NOverlayImage image = const NOverlayImage.fromAssetImage(
        "assets/icons/marker/store_marker(100).png");

    NLatLng myLatLng =
        NLatLng(store.geopoint!.latitude, store.geopoint!.longitude);

    NMarker myLocationMarker =
        NMarker(id: store.title!, position: myLatLng, icon: image);
    myLocationMarker.setSize(const Size(18, 27));

    NInfoWindow infoWindow =
        NInfoWindow.onMarker(id: store.title!, text: store.title!);

    myLocationMarker.openInfoWindow(infoWindow);

    naverMapController.addOverlay(myLocationMarker);
  }
}
