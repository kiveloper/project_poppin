import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:project_poppin/pages/location_select_page.dart';
import 'package:project_poppin/utils/map_status_manager.dart';

import '../controller/location_controller.dart';
import '../controller/store_controller.dart';
import '../theme/colors.dart';
import '../utils/permission_manager.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  LocationController locationController = Get.find();
  StoreController storeController = Get.find();
  MapStatusManager mapStatusManager = MapStatusManager();
  PermissionManager permissionManager = PermissionManager();
  bool categoryExtend = false;

  var lastPopTime;
  NaverMapController? naverMapController;

  @override
  void initState() {
    permissionManager.locationPermission();
    super.initState();
  }

  @override
  void dispose() {
    naverMapController!.dispose();
    super.dispose();
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
      child: Scaffold(
          body: Stack(
        children: [
          NaverMap(
            options: NaverMapViewOptions(
                initialCameraPosition: mapStatusManager.nCameraPosition ??
                    const NCameraPosition(
                      target: NLatLng(37.57037778, 126.9816417),
                      zoom: 13,
                    ),
                extent: const NLatLngBounds(
                  southWest: NLatLng(31.43, 122.37),
                  northEast: NLatLng(44.35, 132.0),
                ),
                logoAlign: NLogoAlign.leftBottom,
                logoMargin: const EdgeInsets.all(10),
                liteModeEnable: true),
            onMapReady: (controller) async {
              naverMapController = controller;

              if (mapStatusManager.mapLoadFirst) {
                myLocationAddMarker(permissionManager);
                mapStatusManager.checkMapFirstLoad();
              }

              await mapStatusManager.setMarkerList(
                  naverMapController!, storeController);
              mapStatusManager.visibleManager();
            },
            onCameraIdle: () async {
              var position = naverMapController?.nowCameraPosition;
              mapStatusManager.currentCameraPosition(position);
            },
            onMapTapped: (NPoint point, NLatLng latLng) {
              naverMapController!.clearOverlays(type: NOverlayType.infoWindow);
            },
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              margin:
                  EdgeInsets.only(top: MediaQuery.of(context).padding.top + 12),
              height: 28,
              child: ElevatedButton(
                onPressed: () {
                  Get.to(() => const LocationSelectPage(),
                      transition: Transition.leftToRight);
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: poppinColorGreen500,
                    foregroundColor: Colors.black),
                child: const Text(
                  "지역 설정",
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
            ),
          ),
          Positioned(
            right: 5,
            bottom: 5,
            child: Stack(
              children: [
                IconButton(
                    onPressed: () async {
                      myLocationAddMarker(permissionManager);
                    },
                    icon: Image.asset("assets/icons/map/gps_icon.png", width: 40,height: 40,fit: BoxFit.cover,)
                ),
                Positioned(
                  left: 5,
                  top: 5,
                  child: GetBuilder<LocationController>(builder: (locationController) {
                    return locationController.locationState
                        ? Container(
                            width: 46,
                            height: 46,
                            decoration: BoxDecoration(
                                color:
                                    CupertinoColors.systemGrey.withOpacity(0.5),
                                borderRadius: BorderRadius.circular(100)),
                            child: const CircularProgressIndicator(
                              strokeWidth: 2.0,
                              color: poppinMainColor,
                            ))
                        : const SizedBox();
                  }),
                ),
              ],
            ),
          ),
        ],
      )),
    );
  }

  void myLocationAddMarker(PermissionManager permissionManager) async {
    locationController.setLocationState(true);

    if (await permissionCheck()) {
      try {
        await locationController.getCurrentLocation();
      } catch (e) {
        locationController.setLocationState(false);
      }

      final myLatLng = NLatLng(
          locationController.locationData?.latitude ?? 37.57037778,
          locationController.locationData?.longitude ?? 126.9816417);

      final position = NCameraUpdate.withParams(target: myLatLng, zoom: 13);

      const iconImage = NOverlayImage.fromAssetImage(
          "assets/icons/map/icon_current_location(50).png");

      final myLocationMarker =
          NMarker(id: "myLocation", position: myLatLng, icon: iconImage);

      naverMapController?.updateCamera(position);
      naverMapController?.addOverlay(myLocationMarker);

      locationController.setLocationState(false);
    } else {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('위치 권한을 확인해주세요'),
        ),
      );
      locationController.setLocationState(false);
    }
  }

  Future<bool> permissionCheck() async {
    if ("${await Permission.location.status}" ==
            "PermissionStatus.permanentlyDenied" ||
        "${await Permission.location.status}" == "PermissionStatus.denied") {
      return false;
    } else {
      return true;
    }
  }
}
