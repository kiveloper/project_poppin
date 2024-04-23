
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

class LocationController extends GetxController {

  Position? locationData;
  bool locationState = false;

  Future<void> getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

    locationData = position;
  }

  Future<void> setLocationState(bool state) async{
    locationState = state;
    update();
  }

}