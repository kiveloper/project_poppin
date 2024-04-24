
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_poppin/model/store_list_model.dart';
import 'package:project_poppin/services/poppin_firebase_service.dart';
import 'package:project_poppin/vo/store_vo.dart';

class StoreController extends GetxController {
  final PopPinFirebaseService popPinFirebaseService = PopPinFirebaseService();

  List<StoreVo> storeList = [];
  List<StoreVo> storeFilterLocationList = [];

  StoreVo detailStoreData = StoreVo();

  bool storeDetailState = false;
  bool storeLoadState = false;

  Future<void> getStoreListAll() async {
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

  Future<void> getStoreListLocationFilter(String location) async {
    try{
      StoreListModel storeListModel =
          await popPinFirebaseService.getLocationStoreList(location);
      storeFilterLocationList.clear();
      storeFilterLocationList.addAll(storeListModel.storeList!);
      update();
    }catch(error) {
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

  Future<void> setStoreDetailState(bool state) async {
    try {
      storeDetailState = state;
      update();
    } catch (error) {
      throw Exception(error);
    }
  }

  Future<void> setDetailStoreData(StoreVo storeData) async {
    try {
      detailStoreData = storeData;
      update();
    } catch (error) {
      throw Exception(error);
    }
  }

}