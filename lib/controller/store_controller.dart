import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_poppin/model/store_list_model.dart';
import 'package:project_poppin/services/poppin_firebase_service.dart';
import 'package:project_poppin/vo/store_vo.dart';

class StoreController extends GetxController {
  final PopPinFirebaseService popPinFirebaseService = PopPinFirebaseService();

  List<StoreVo> storeAllList = [];
  List<StoreVo> storeFilterLocationList = [];
  List<StoreVo> recommendList = [];

  StoreVo recommendStoreData = StoreVo();
  StoreVo detailStoreData = StoreVo();

  double storeOffset = 0.0;

  String storeLocationState = "서울";

  bool storeDetailState = false;
  bool storeLoadState = false;
  bool storeFilterState = false;

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

  Future<void> getRecommendList() async{
    try{
      StoreListModel storeListModel = await popPinFirebaseService.getRecommendData();
      recommendList.clear();
      recommendList.addAll(storeListModel.storeList!);
      setRecommendStoreData(recommendList[0]);
      update();
    }catch(error){
      throw Exception(error);
    }
  }

  Future<void> setRecommendStoreData(StoreVo data) async{
    try{
      recommendStoreData = data;
      update();
    } catch(error) {
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

  Future<void> setStoreListOffset(double offset) async {
    try {
      storeOffset = offset;
      update();
    } catch (error) {
      throw Exception(error);
    }
  }
}
