
import 'package:get/get.dart';

class TabBarController extends GetxController {

  int currentIndex = 0;

  Future<void> setCurrentIndex(int index) async{
    currentIndex = index;
    update();
  }

}