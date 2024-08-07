import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project_poppin/data/local_data.dart';

import '../model/store_list_model.dart';

FirebaseFirestore fireStore = FirebaseFirestore.instance;
CollectionReference store = fireStore.collection('popinData');
CollectionReference storeRecommend = fireStore.collection('MDData');

class PopPinFirebaseService {
  QuerySnapshot? queryFirstSnapshot;
  QueryDocumentSnapshot? lastDoc;
  int storeLength = 0;

  Future<StoreListModel> getStoreList() async {
    try {
      QuerySnapshot querySnapshot = await store.get();
      return StoreListModel.fromQuerySnapShot(querySnapshot);
    } catch (error) {
      throw Exception(error);
    }
  }

  Future<StoreListModel> getLocationStoreList(
    String local1,
    List<String> local2,
    bool firstSetUp,
  ) async {
    try {
      // 지역필터 '서울 전체', '부산 전체' 일 경우
      if (local.keys.contains(local2.first)) {
        if (firstSetUp) {
          final querySnapShot = await store
              .orderBy('endDate')
              .where('endDate', isGreaterThanOrEqualTo: Timestamp.now())
              .where("local1", isEqualTo: local1)
              .limit(5)
              .get();

          queryFirstSnapshot = querySnapShot;

          return StoreListModel.fromQuerySnapShot(querySnapShot);
        } else {

          lastDoc =
              queryFirstSnapshot!.docs[queryFirstSnapshot!.docs.length - 1];

          final next = await store
              .orderBy('endDate')
              .where('endDate', isGreaterThanOrEqualTo: Timestamp.now())
              .where("local1", isEqualTo: local1)
              .startAfterDocument(lastDoc!)
              .limit(5)
              .get();

          queryFirstSnapshot = next;

          return StoreListModel.fromQuerySnapShot(next);
        }
      } else {
        // 지역필터 '송파/잠실/신청' local2가 존재 할 때
        if (firstSetUp) {
          final querySnapShot = await store
              .orderBy('endDate')
              .where('endDate', isGreaterThanOrEqualTo: Timestamp.now())
              .where("local1", isEqualTo: local1)
              .where("local2", whereIn: local2)
              .limit(5)
              .get();

          queryFirstSnapshot = querySnapShot;

          return StoreListModel.fromQuerySnapShot(querySnapShot);
        } else {

          lastDoc =
              queryFirstSnapshot!.docs[queryFirstSnapshot!.docs.length - 1];

          final next = await store
              .orderBy('endDate')
              .where('endDate', isGreaterThanOrEqualTo: Timestamp.now())
              .where("local1", isEqualTo: local1)
              .where("local2", whereIn: local2)
              .startAfterDocument(lastDoc!)
              .limit(5)
              .get();

          queryFirstSnapshot = next;

          return StoreListModel.fromQuerySnapShot(next);
        }
      }
    } catch (error) {
      throw Exception(error);
    }
  }

  Future<StoreListModel> getRecommendData() async {
    try {
      DocumentSnapshot documentSnapshot =
          await storeRecommend.doc("MDPick").get();
      return StoreListModel.fromRecommendQuerySnapShot(documentSnapshot);
    } catch (error) {
      throw Exception(error);
    }
  }

  Future<StoreListModel> getRecommendPopularData() async {
    try {
      DocumentSnapshot documentSnapshot =
          await storeRecommend.doc("popularData").get();
      return StoreListModel.fromRecommendQuerySnapShot(documentSnapshot);
    } catch (error) {
      throw Exception(error);
    }
  }

  Future<StoreListModel> getRecommendSeongsuData() async {
    try {
      DocumentSnapshot documentSnapshot =
      await storeRecommend.doc("SeongsuData").get();
      return StoreListModel.fromRecommendQuerySnapShot(documentSnapshot);
    } catch (error) {
      throw Exception(error);
    }
  }

  Future<Map<String, dynamic>> getBannerData() async{
    try{
      DocumentSnapshot doc =  await storeRecommend.doc('Banner').get();
      return doc.data() as Map<String, dynamic>;
    } catch(error) {
      throw Exception(error);
    }
  }
}