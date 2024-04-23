
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_poppin/model/store_list_model.dart';
import 'package:project_poppin/services/poppin_firebase_service.dart';
import 'package:project_poppin/vo/store_vo.dart';

class StoreController extends GetxController {
  final PopPinFirebaseService popPinFirebaseService = PopPinFirebaseService();

  List<StoreVo> storeList = [];
  bool storeLoadState = false;

  Future<void> getPopUpData() async {
    try {
      StoreListModel storeListModel =
          await popPinFirebaseService.getStoreList();
      storeList.clear();
      storeList.addAll(storeListModel.storeList!);
      update();
    } catch (error) {
      throw Exception(error);
    }
  }

  Future<void> setStoreLoadState(bool state) async {
    try {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        storeLoadState = state;
        update();
      });
    } catch (error) {
      throw Exception(error);
    }
  }
}