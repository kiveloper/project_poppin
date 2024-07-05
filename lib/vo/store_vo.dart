
import 'package:cloud_firestore/cloud_firestore.dart';

class StoreVo {
  String? docId;
  String? title;
  String? address;
  String? description;
  String? category;
  String? summary;
  String? startDate;
  String? endDate;
  GeoPoint? geopoint;
  List<dynamic>? hashtag;
  String? local1;
  String? local2;
  String? relatedContentsUrl;
  List<dynamic>? relatedImgUrl;
  String? thumbnailImgUrl;

  StoreVo({
    this.docId,
    this.title,
    this.address,
    this.description,
    this.summary,
    this.category,
    this.startDate,
    this.endDate,
    this.geopoint,
    this.hashtag,
    this.local1,
    this.local2,
    this.relatedContentsUrl,
    this.relatedImgUrl,
    this.thumbnailImgUrl
  });

  StoreVo.fromDocumentSnapshot(DocumentSnapshot documentSnapshot) {
    docId = documentSnapshot.id;
    title = documentSnapshot['title'];
    address = documentSnapshot['address'];
    description = documentSnapshot['description'];
    summary = documentSnapshot['summary'];
    category = documentSnapshot['category'];
    startDate = timeStampToDate(documentSnapshot['startDate']);
    endDate = timeStampToDate(documentSnapshot['endDate']);
    geopoint = documentSnapshot['geopoint'];
    hashtag = documentSnapshot['hashtag'];
    local1 = documentSnapshot['local1'];
    local2 = documentSnapshot['local2'];
    relatedContentsUrl = documentSnapshot['relatedContentsUrl'];
    relatedImgUrl = documentSnapshot['relatedImgUrl'];
    thumbnailImgUrl = documentSnapshot['thumbnailImgUrl'];
  }

  StoreVo.fromMapSnapshot(Map<String, dynamic> documentSnapshot) {
    docId = "0";
    title = documentSnapshot['title'];
    address = documentSnapshot['address'];
    description = documentSnapshot['description'];
    summary = documentSnapshot['summary'];
    category = documentSnapshot['category'];
    startDate = timeStampToDate(documentSnapshot['startDate']);
    endDate = timeStampToDate(documentSnapshot['endDate']);
    geopoint = documentSnapshot['geopoint'];
    hashtag = documentSnapshot['hashtag'];
    local1 = documentSnapshot['local1'];
    local2 = documentSnapshot['local2'];
    relatedContentsUrl = documentSnapshot['relatedContentsUrl'];
    relatedImgUrl = documentSnapshot['relatedImgUrl'];
    thumbnailImgUrl = documentSnapshot['thumbnailImgUrl'];
  }

  StoreVo.fromCFMapSnapshot(Map<String, dynamic> documentSnapshot) {
    docId = documentSnapshot['documentId'];
    title = documentSnapshot['title'];
    address = documentSnapshot['address'];
    description = documentSnapshot['description'];
    summary = documentSnapshot['summary'];
    category = documentSnapshot['category'];
    startDate = documentSnapshot['startDate'];
    endDate = documentSnapshot['endDate'];
    geopoint = changeGeoCode(documentSnapshot['geopoint']);
    hashtag = documentSnapshot['hashtag'];
    local1 = documentSnapshot['local1'];
    local2 = documentSnapshot['local2'];
    relatedContentsUrl = documentSnapshot['relatedContentsUrl'];
    relatedImgUrl = documentSnapshot['relatedImgUrl'];
    thumbnailImgUrl = documentSnapshot['thumbnailImgUrl'];
  }

  String timeStampToDate(Timestamp timestamp) {
    final dateTime = timestamp.toDate();
    final formattedDate = "${dateTime.year}.${dateTime.month}.${dateTime.day}";
    return formattedDate;
  }

  GeoPoint changeGeoCode(List<dynamic> geoList) {
    var tempGeo = GeoPoint(double.parse(geoList[0]), double.parse(geoList[1]));
    return tempGeo;
  }

}