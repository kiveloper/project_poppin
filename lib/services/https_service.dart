import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:project_poppin/vo/store_vo.dart';

class HttpsService {

  final baseUrl = Uri.parse(
      'https://asia-northeast3-project-poping.cloudfunctions.net/function-curation-test');

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
      return [];
    }
  }

  Future<List<StoreVo>> getCurationTest(String userId) async {
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

      for(var doc in decodeData["data"]){
        tempStoreData.add(StoreVo.fromCFMapSnapshot(doc));
      }

      return tempStoreData;
    } else {
      print('Request failed with status: ${response.statusCode}.');
      return [];
    }
  }

}
