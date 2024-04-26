import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_poppin/data/local_data.dart';
import 'package:project_poppin/model/store_list_model.dart';
import 'package:project_poppin/services/poppin_firebase_service.dart';
import 'package:project_poppin/vo/md_vo.dart';
import 'package:project_poppin/vo/store_vo.dart';

class StoreController extends GetxController {
  final PopPinFirebaseService popPinFirebaseService = PopPinFirebaseService();

  List<StoreVo> storeAllList = [];
  List<StoreVo> storeFilterLocationList = [];
  MDVo mdPickStore = MDVo();
  StoreVo recommendStoreVo = StoreVo();

  StoreVo detailStoreData = StoreVo();
  StoreVo detailStoreStartMapData = StoreVo();

  String storeLocationState = "서울";

  bool storeDetailState = false;
  bool storeLoadState = false;

  Future<void> getStoreListAll() async {
    try {
      StoreListModel storeListModel =
          await popPinFirebaseService.getStoreList();
      storeAllList.clear();
      storeAllList.addAll(storeListModel.storeList!);
      update();
    } catch (error) {
      throw Exception(error);
    }
  }

  Future<void> getStoreListLocationFilter(
      String local1, List<String> local2) async {
    try {
      StoreListModel storeListModel =
          await popPinFirebaseService.getLocationStoreList(local1, local2);
      storeFilterLocationList.clear();
      storeFilterLocationList.addAll(storeListModel.storeList!);
      update();
    } catch (error) {
      throw Exception(error);
    }
  }

  Future<void> getRecommendStoreData() async {
    try {
      MDVo storeData = await popPinFirebaseService.getRecommendStore();
      mdPickStore = storeData;
      await getRecommendStoreVoData(mdPickStore.docId!);
      update();
    } catch (error) {
      throw Exception(error);
    }
  }

  Future<void> getRecommendStoreVoData(String docId) async {
    try {
      StoreVo storeData =
          await popPinFirebaseService.getRecommendStoreVo(docId);
      recommendStoreVo = storeData;
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

  Future<void> setStoreDetailState(bool state) async {
    try {
      storeDetailState = state;
      update();
    } catch (error) {
      throw Exception(error);
    }
  }

  Future<void> setLocationState(String location) async {
    try {
      storeLocationState = location;
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

  Future<void> setDetailStartMapStoreData(StoreVo storeData) async {
    try {
      detailStoreStartMapData = storeData;
      update();
    } catch (error) {
      throw Exception(error);
    }
  }
}
