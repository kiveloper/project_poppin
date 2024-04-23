
import 'package:cloud_firestore/cloud_firestore.dart';

import '../vo/store_vo.dart';

class StoreListModel {

  List<StoreVo>? storeList;

  StoreListModel({this.storeList});

  StoreListModel.fromQuerySnapShot(QuerySnapshot querySnapshot) {
    storeList = <StoreVo>[];
    for(DocumentSnapshot item in querySnapshot.docs) {
      storeList!.add(StoreVo.fromDocumentSnapshot(item));
    }
  }
}