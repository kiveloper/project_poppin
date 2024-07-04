import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:project_poppin/vo/store_vo.dart';

import '../controller/store_controller.dart';
import '../global/share_preference.dart';

class HttpsService {

  final baseUrl = Uri.parse(
      'https://asia-northeast3-project-poping.cloudfunctions.net/function-curation-test');

  Future<List<StoreVo>> getAllStoreMap() async {
    final storeList = <StoreVo>[];

    try {
      var response = await http.post(baseUrl,
          headers: {
            'Content-Type': 'application/json',
          },
          body: jsonEncode({
            "type" : "all_stores_map",
            "lastDocId": "",
            "ended_popups" : true
          })
      );

      if (response.statusCode == 200) {
        final decodeData = jsonDecode(response.body);

        for (var doc in decodeData) {
          storeList.add(StoreVo.fromCFMapSnapshot(doc));
        }

        return storeList;
      } else {
        print("error ${response.statusCode}");
        return storeList;
      }
    } catch (error) {
      print("error: $error");
      return storeList;
    }
  }

  Future<List<StoreVo>> getAllStore(bool endedPopUpState, String docId) async {
    final storeList = <StoreVo>[];

    try {
      var response = await http.post(baseUrl,
          headers: {
            'Content-Type': 'application/json',
          },
          body: jsonEncode({
            "type" : "all_stores",
            "lastDocId": docId,
            "ended_popups" : endedPopUpState
          })
      );

      if (response.statusCode == 200) {
        final decodeData = jsonDecode(response.body);

        for (var doc in decodeData) {
          storeList.add(StoreVo.fromCFMapSnapshot(doc));
        }

        return storeList;
      } else {
        print("error ${response.statusCode}");
        return storeList;
      }
    } catch (error) {
      print("error: $error");
      return storeList;
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
