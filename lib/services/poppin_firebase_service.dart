import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:project_poppin/data/local_data.dart';
import 'package:project_poppin/vo/md_vo.dart';
import 'package:project_poppin/vo/store_vo.dart';

import '../model/store_list_model.dart';

FirebaseFirestore fireStore = FirebaseFirestore.instanceFor(
    app: Firebase.app(), databaseId: "for-poping-dev");
CollectionReference store = fireStore.collection('popinData');
CollectionReference storeRecommend = fireStore.collection('MDData');

class PopPinFirebaseService {

  Future<StoreListModel> getStoreList() async {
    try {
      QuerySnapshot querySnapshot = await store.get();
      return StoreListModel.fromQuerySnapShot(querySnapshot);
    } catch (error) {
      throw Exception(error);
    }
  }

  Future<StoreListModel> getLocationStoreList(String local1, List<String> local2) async {
    try {
      if(local.keys.contains(local2.first)) {
        QuerySnapshot querySnapshot =
        await store.where("local1", isEqualTo: local1).get();
        return StoreListModel.fromQuerySnapShot(querySnapshot);
      } else {
        QuerySnapshot querySnapshot =
        await store.where("local1", isEqualTo: local1).where("local2", whereIn: local2).get();
        return StoreListModel.fromQuerySnapShot(querySnapshot);
      }
    } catch (error) {
      throw Exception(error);
    }
  }

  Future<MDVo> getRecommendStore() async {
    try {
      DocumentSnapshot documentSnapshot = await storeRecommend.doc("MDPick").get();
      return MDVo.fromDocumentSnapshot(documentSnapshot);
    } catch (error) {
      throw Exception(error);
    }
  }

  Future<StoreVo> getRecommendStoreVo(String docId) async {
    try {
      DocumentSnapshot documentSnapshot = await store.doc(docId).get();
      return StoreVo.fromDocumentSnapshot(documentSnapshot);
    } catch (error) {
      throw Exception(error);
    }
  }

}
