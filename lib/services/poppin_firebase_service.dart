import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

import '../model/store_list_model.dart';

FirebaseFirestore fireStore = FirebaseFirestore.instanceFor(app: Firebase.app(), databaseId: "for-poping-dev");
CollectionReference store = fireStore.collection('popinData');
CollectionReference test = fireStore.collection('test');
CollectionReference test2 = fireStore.collection("pet_location_data");

class PopPinFirebaseService {

  Future<StoreListModel> getStoreList() async {
    try {
      QuerySnapshot querySnapshot =
          await store.get();
      return StoreListModel.fromQuerySnapShot(querySnapshot);
    } catch (error) {
      throw Exception(error);
    }
  }


}
