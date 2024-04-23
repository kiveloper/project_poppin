

import 'package:permission_handler/permission_handler.dart';

class PermissionManager {

  void locationPermission() async {
    var requestStatus = await Permission.location.request();
    var status = await Permission.location.status;

    if (requestStatus.isGranted && status.isLimited) {
      // isLimited - 제한적 동의 (ios 14< )

      //요청 동의됨
      if(await Permission.locationWhenInUse.serviceStatus.isEnabled) {
        // 요청 동의 + gps 켜짐
      } else {

      }
    }
    // else if(requestStatus.isPermanentlyDenied || status.isPermanentlyDenied) {
    //   // 권한 요청 거부, 해당 권한에 대한 요청에 대해 다시 묻지 않음 선택하여 설정화면에서 변경해야함. android
    //   openAppSettings();
    // } else if (status.isRestricted) {
    //   // 권한 요청 거부, 해당 권한에 대한 요청을 표시하지 않도록 선택하여 설정화면에서 변경해야함. ios
    //   openAppSettings();
    // } else if (status.isDenied) {
    //   // 권한 요청 거절
    // }
  }
}