
import 'package:cloud_firestore/cloud_firestore.dart';

class StoreVo {
  String? title;
  String? address;
  String? description;
  String? docId;
  String? category;
  String? summary;
  Timestamp? endDate;
  Timestamp? startDate;
  GeoPoint? geopoint;
  List<dynamic>? hashtag;
  String? local1;
  String? local2;
  String? relatedContentsUrl;
  List<dynamic>? relatedImgUrl;
  String? thumbnailImgUrl;

  StoreVo({
    this.title,
    this.address,
    this.description,
    this.docId,
    this.summary,
    this.category,
    this.endDate,
    this.startDate,
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
    endDate = documentSnapshot['endDate'];
    startDate = documentSnapshot['startDate'];
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
    endDate = documentSnapshot['endDate'];
    startDate = documentSnapshot['startDate'];
    geopoint = documentSnapshot['geopoint'];
    hashtag = documentSnapshot['hashtag'];
    local1 = documentSnapshot['local1'];
    local2 = documentSnapshot['local2'];
    relatedContentsUrl = documentSnapshot['relatedContentsUrl'];
    relatedImgUrl = documentSnapshot['relatedImgUrl'];
    thumbnailImgUrl = documentSnapshot['thumbnailImgUrl'];
  }

}