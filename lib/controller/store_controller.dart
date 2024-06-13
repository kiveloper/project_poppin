import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_poppin/model/store_list_model.dart';
import 'package:project_poppin/services/https_service.dart';
import 'package:project_poppin/services/poppin_firebase_service.dart';
import 'package:project_poppin/vo/store_vo.dart';

class StoreController extends GetxController {
  final PopPinFirebaseService popPinFirebaseService = PopPinFirebaseService();
  final HttpsService httpsService = HttpsService();

  List<StoreVo> storeAllList = [];
  RxList<StoreVo> storeNavPageAllList = RxList<StoreVo>([]);
  List<String> storeAllTagList = [];
  List<StoreVo> storeFilterLocationList = [];
  List<StoreVo> recommendList = [];
  List<StoreVo> storeCurationList = [];

  StoreVo recommendStoreData = StoreVo();
  StoreVo detailStoreData = StoreVo();

  double storeOffset = 0.0;

  String storeLocationState = "서울";
  String userInstaId = "";

  bool storeDetailState = false;
  bool storeLoadState = false;
  bool curationServiceLoaded = true;

  Future<void> getStoreAllList() async {
    try {
      storeAllList = await httpsService.getAllStore(true);
      update();
    } catch (error) {
      throw Exception(error);
    }
  }

  Future<void> getNavPageStoreAllList(bool endedPopUpState) async {
    try {
      storeNavPageAllList.clear();
      storeNavPageAllList = await httpsService.getAllStore(endedPopUpState);
      update();
    } catch (error) {
      throw Exception(error);
    }
  }

  // Future<void> getHashTagStoreDateList(String hashTag, bool endedPopUpState) async {
  //   try {
  //     storeNavPageAllList.clear();
  //     storeNavPageAllList = await httpsService.getHashTagStore(hashTag, endedPopUpState);
  //   } catch (error) {
  //     throw Exception(error);
  //   }
  // }

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

  Future<void> getStoreAllTags() async {
    try {
      storeAllTagList = await httpsService.getAllTags();
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

  Future<void> getCurationStoreData(String userId, StoreController storeController) async{
    try{
      storeCurationList = await httpsService.getCurationData(userId, storeController);
      update();
    } catch(e) {
      throw Exception(e);
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

  Future<void> setUserInstaId(String userId) async {
    try {
      userInstaId = userId;
      update();
    } catch (error) {
      throw Exception(error);
    }
  }

  Future<void> setCurationDataFirstLoadState(bool state) async {
    try {
      curationServiceLoaded = state;
      update();
    } catch (error) {
      throw Exception(error);
    }
  }


}

// class StoreController extends GetxController {
//   final PopPinFirebaseService popPinFirebaseService = PopPinFirebaseService();
//   final HttpsService httpsService = HttpsService();
//
//
//   List<StoreVo> storeAllList = [];
//   List<StoreVo> storeNavPageAllList = [];
//   List<String> storeAllTagList = [];
//   List<StoreVo> storeFilterLocationList = [];
//   List<StoreVo> recommendList = [];
//   List<StoreVo> storeCurationList = [];
//
//   StoreVo recommendStoreData = StoreVo();
//   StoreVo detailStoreData = StoreVo();
//
//   double storeOffset = 0.0;
//
//   String storeLocationState = "서울";
//   String userInstaId = "";
//
//   bool storeDetailState = false;
//   bool storeLoadState = false;
//   bool curationServiceLoaded = true;
//
//   Future<void> getStoreAllList() async {
//     try {
//       storeAllList = await httpsService.getAllStore(true);
//       update();
//     } catch (error) {
//       throw Exception(error);
//     }
//   }
//
//   Future<void> getNavPageStoreAllList(bool endedPopUpState) async {
//     try {
//       storeNavPageAllList.clear();
//       storeNavPageAllList = await httpsService.getAllStore(endedPopUpState);
//     } catch (error) {
//       throw Exception(error);
//     }
//   }
//
//   Future<void> getHashTagStoreDateList(String hashTag, bool endedPopUpState) async {
//     try {
//       storeNavPageAllList.clear();
//       storeNavPageAllList = await httpsService.getHashTagStore(hashTag, endedPopUpState);
//     } catch (error) {
//       throw Exception(error);
//     }
//   }
//
//
//   Future<void> getStoreListLocationFilter(
//       String local1, List<String> local2) async {
//     try {
//       StoreListModel storeListModel =
//           await popPinFirebaseService.getLocationStoreList(local1, local2);
//       storeFilterLocationList.clear();
//       storeFilterLocationList.addAll(storeListModel.storeList!);
//       update();
//     } catch (error) {
//       throw Exception(error);
//     }
//   }
//
//   Future<void> getStoreAllTags() async {
//     try {
//       storeAllTagList = await httpsService.getAllTags();
//       update();
//     } catch (error) {
//       throw Exception(error);
//     }
//   }
//
//   Future<void> getRecommendList() async{
//     try{
//       StoreListModel storeListModel = await popPinFirebaseService.getRecommendData();
//       recommendList.clear();
//       recommendList.addAll(storeListModel.storeList!);
//       setRecommendStoreData(recommendList[0]);
//       update();
//     }catch(error){
//       throw Exception(error);
//     }
//   }
//
//   Future<void> getCurationStoreData(String userId, StoreController storeController) async{
//     try{
//       storeCurationList = await httpsService.getCurationData(userId, storeController);
//       update();
//     } catch(e) {
//       throw Exception(e);
//     }
//   }
//
//   Future<void> setRecommendStoreData(StoreVo data) async{
//     try{
//       recommendStoreData = data;
//       update();
//     } catch(error) {
//       throw Exception(error);
//     }
//   }
//
//   Future<void> setStoreLoadState(bool state) async {
//     try {
//       WidgetsBinding.instance.addPostFrameCallback((_) {
//         storeLoadState = state;
//         update();
//       });
//     } catch (error) {
//       throw Exception(error);
//     }
//   }
//
//   Future<void> setStoreDetailState(bool state) async {
//     try {
//       storeDetailState = state;
//       update();
//     } catch (error) {
//       throw Exception(error);
//     }
//   }
//
//   Future<void> setLocationState(String location) async {
//     try {
//       storeLocationState = location;
//       update();
//     } catch (error) {
//       throw Exception(error);
//     }
//   }
//
//   Future<void> setDetailStoreData(StoreVo storeData) async {
//     try {
//       detailStoreData = storeData;
//       update();
//     } catch (error) {
//       throw Exception(error);
//     }
//   }
//
//   Future<void> setStoreListOffset(double offset) async {
//     try {
//       storeOffset = offset;
//       update();
//     } catch (error) {
//       throw Exception(error);
//     }
//   }
//
//   Future<void> setUserInstaId(String userId) async {
//     try {
//       userInstaId = userId;
//       update();
//     } catch (error) {
//       throw Exception(error);
//     }
//   }
//
//   Future<void> setCurationDataFirstLoadState(bool state) async {
//     try {
//       curationServiceLoaded = state;
//       update();
//     } catch (error) {
//       throw Exception(error);
//     }
//   }
//
//
// }
