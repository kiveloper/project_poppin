import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:project_poppin/vo/store_vo.dart';

import '../controller/store_controller.dart';
import '../global/share_preference.dart';

class HttpsService {

  final baseUrl = Uri.parse(
      'https://asia-northeast3-project-poping.cloudfunctions.net/function-curation-test');

  Future<RxList<StoreVo>> getAllStore(bool endedPopUpState) async {
    final storeList = RxList<StoreVo>(); // RxList<StoreVo> 초기화

    try {
      var response = await http.post(baseUrl,
          headers: {
            'Content-Type': 'application/json',
          },
          body: jsonEncode({
            'type': 'all_stores',
            'ended_popups': endedPopUpState,
          })
      );

      if (response.statusCode == 200) {
        final decodeData = jsonDecode(response.body);

        for (var doc in decodeData) {
          storeList.add(StoreVo.fromCFMapSnapshot(doc)); // RxList에 데이터 추가
        }

        return storeList;
      } else {
        print("error ${response.statusCode}");
        return storeList; // RxList 반환 (비어 있을 수 있음)
      }
    } catch (error) {
      print("error: $error");
      return storeList; // RxList 반환 (비어 있을 수 있음)
    }
  }

  Future<List<String>> getAllTags() async {
    var response = await http.post(baseUrl,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'type': 'all_tags'}));
    if (response.statusCode == 200) {
      var responseBody = response.body;
      List<String> tags = List<String>.from(jsonDecode(responseBody));
      return tags;
    } else {
      print("error ${response.statusCode}");
      return [];
    }
  }

  Future<List<StoreVo>> getHashTagStore(String filter, bool endedPopups) async {
    var response = await http.post(baseUrl,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'type': 'tag_filter',
          'tag': filter,
          'ended_popups': endedPopups
        })
    );

    if (response.statusCode == 200) {
      final decodeData = jsonDecode(response.body);
      final tempStoreData = <StoreVo>[];

      for(var doc in decodeData){
        tempStoreData.add(StoreVo.fromCFMapSnapshot(doc));
      }

      return tempStoreData;
    } else {
      print("error ${response.statusCode}");
      return [];
    }
  }

  Future<List<StoreVo>> getCurationData(String userId,StoreController storeController) async {
    var response = await http.post(baseUrl,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'type': 'curation_test',
          'userId': userId
        })
    );

    if (response.statusCode == 200) {
      final decodeData = jsonDecode(response.body);
      final tempStoreData = <StoreVo>[];

      storeController.setUserInstaId(decodeData["instaId"]??"");

      for(var doc in decodeData["data"]){
        tempStoreData.add(StoreVo.fromCFMapSnapshot(doc));
      }

      prefs.setString("userId", userId);
      storeController.setCurationDataFirstLoadState(false);
      storeController.setCurationCodeCheck(false);

      return tempStoreData;
    } else {
      print("error ${response.statusCode}");
      storeController.setCurationCodeCheck(true);
      return [];
    }
  }

}
