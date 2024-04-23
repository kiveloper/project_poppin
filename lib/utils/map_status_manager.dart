
import 'package:flutter_naver_map/flutter_naver_map.dart';

class MapStatusManager {
  static final MapStatusManager instance = MapStatusManager._internal();
  factory MapStatusManager() => instance;

  MapStatusManager._internal();

  bool mapLoadFirst = true;
  NCameraPosition? nCameraPosition;

  void checkMapFirstLoad() {
    mapLoadFirst = false;
  }

  void currentCameraPosition(NCameraPosition? currentCameraPosition) async {
    nCameraPosition = currentCameraPosition;
  }

}
