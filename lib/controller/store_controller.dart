
import 'package:get/get.dart';
import 'package:project_poppin/model/store_list_model.dart';
import 'package:project_poppin/services/https_service.dart';
import 'package:project_poppin/services/poppin_firebase_service.dart';
import 'package:project_poppin/vo/store_vo.dart';

class StoreController extends GetxController {
  final PopPinFirebaseService popPinFirebaseService = PopPinFirebaseService();
  final HttpsService httpsService = HttpsService();

  List<StoreVo> storeAllList = [];
  List<StoreVo> storeNavPageAllList = [];
  List<String> storeAllTagList = [];
  List<StoreVo> storeFilterLocationList = [];
  List<StoreVo> lastData = [];
  List<StoreVo> recommendList = [];
  List<StoreVo> recommendPopularList = [];
  List<StoreVo> recommendSeongsuList = [];
  List<StoreVo> storeCurationList = [];

  StoreVo recommendStoreData = StoreVo();
  StoreVo detailStoreData = StoreVo();

  double storeOffset = 0.0;

  String storeAllListInfiniteDocId = "";
  String storeLocationState = "서울";
  String hashTageSetting = "";
  String userInstaId = "";

  Map<String, dynamic> bannerData = {
    'imageUrl':'https://storage.googleapis.com/for-store-image/banner/Banner.png',
    'linkTo': 'https://www.instagram.com/p/C8wH0ZUxhMn/?img_index=1'
  };

  bool tagListDataLoadStateEmpty = false;
  bool tagButtonActivate = true;
  bool loadNavDataState = false;
  bool loadDataState = false;
  bool localListDataLoadStateEmpty = false;
  bool storeDetailState = false;
  bool curationServiceLoaded = true;
  bool curationCodeCheckInCorrect = false;

  Future<void> getStoreAllList() async {
    try {
      storeAllList = await httpsService.getAllStoreMap();
      update();
    } catch (error) {
      throw Exception(error);
    }
  }

  Future<void> getNavPageStoreAllList(bool endedPopUpState) async {
    try {
      loadNavDataStateCheck(true);
      tagListDataLoadStateEmpty = false;
      tagButtonActivate = false;
      var tempList = await httpsService.getAllStore(
          endedPopUpState, storeAllListInfiniteDocId);

      if(tempList.isNotEmpty){
        if(storeAllListInfiniteDocId != tempList.last.docId) {
          storeNavPageAllList.addAll(tempList);
        }

        setStoreAllListInfiniteDocId(tempList.last.docId ?? "");
      }

      if (storeNavPageAllList.isEmpty) {
        tagListDataLoadStateEmpty = true;
      }
      tagButtonActivate = true;
      loadNavDataStateCheck(false);
      update();
    } catch (error) {
      tagButtonActivate = true;
      loadNavDataState = false;
      throw Exception(error);
    }
  }

  Future<void> loadNavDataStateCheck(bool state) async {
    loadNavDataState = state;
    update();
  }

  Future<void> getHashTagStoreDateList(
      String hashTag, bool endedPopUpState) async {
    try {
      tagListDataLoadStateEmpty = false;
      tagButtonActivate = false;
      var tempList =
          await httpsService.getHashTagStore(hashTag, endedPopUpState);
      storeNavPageAllList.addAll(tempList);
      if (storeNavPageAllList.isEmpty) {
        tagListDataLoadStateEmpty = true;
      }
      tagButtonActivate = true;
      loadNavDataState = false;
      update();
    } catch (error) {
      throw Exception(error);
    }
  }

  Future<void> getStoreListLocationFilter(
      String local1, List<String> local2, bool firstSetUp) async {
    try {
      loadDataStateCheck(true);
      localListDataLoadStateEmpty = false;

      StoreListModel storeListModel = await popPinFirebaseService
          .getLocationStoreList(local1, local2, firstSetUp);

      if (lastData != storeListModel.storeList) {
        for(var data in lastData) {
          print(data.title);
        }
        for(var data in storeListModel.storeList!) {
          print(data.title);
        }
        lastData = storeListModel.storeList ?? [];
        storeFilterLocationList.addAll(storeListModel.storeList!);
        
      }

      if (storeFilterLocationList.isEmpty) {
        localListDataLoadStateEmpty = true;
      }

      loadDataStateCheck(false);
      update();
    } catch (error) {
      loadDataState = false;
      throw Exception(error);
    }
  }

  Future<void> loadDataStateCheck(bool state) async {
    loadDataState = state;
    update();
  }

  Future<void> getStoreAllTags() async {
    try {
      storeAllTagList = await httpsService.getAllTags();
      update();
    } catch (error) {
      throw Exception(error);
    }
  }

  Future<void> getRecommendList() async {
    try {
      StoreListModel storeListModel =
          await popPinFirebaseService.getRecommendData();
      recommendList.clear();
      recommendList.addAll(storeListModel.storeList!);
      setRecommendStoreData(recommendList[0]);
      update();
    } catch (error) {
      throw Exception(error);
    }
  }

  Future<void> getRecommendPopularList() async {
    try {
      StoreListModel storeListModel =
          await popPinFirebaseService.getRecommendPopularData();
      recommendPopularList.clear();
      recommendPopularList.addAll(storeListModel.storeList!);
      update();
    } catch (error) {
      throw Exception(error);
    }
  }

  Future<void> getRecommendSeoungSuList() async {
    try {
      StoreListModel storeListModel =
      await popPinFirebaseService.getRecommendSeongsuData();
      recommendSeongsuList.clear();
      recommendSeongsuList.addAll(storeListModel.storeList!);
      update();
    } catch (error) {
      throw Exception(error);
    }
  }

  Future<void> getCurationStoreData(
      String userId, StoreController storeController) async {
    try {
      storeCurationList =
          await httpsService.getCurationData(userId, storeController);
      update();
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> getBannerData() async{
    try{
      Map<String, dynamic> bannerDT = await popPinFirebaseService.getBannerData();
      bannerData = bannerDT;
    }catch(e) {
      throw Exception(e);
    }
  }


  Future<void> setStoreNavPageAllListClean() async {
    try {
      storeNavPageAllList.clear();
      update();
    } catch (e) {
      throw e;
    }
  }

  Future<void> setRecommendStoreData(StoreVo data) async {
    try {
      recommendStoreData = data;
      update();
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

  Future<void> setHashTagSetting(String hashTag) async {
    try {
      hashTageSetting = hashTag;
      update();
    } catch (error) {
      throw Exception(error);
    }
  }

  Future<void> setCurationCodeCheck(bool check) async {
    try {
      curationCodeCheckInCorrect = check;
      update();
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> setStoreAllListInfiniteDocId(String docId) async {
    try {
      storeAllListInfiniteDocId = docId;
    } catch (e) {
      throw Exception(e);
    }
  }
}