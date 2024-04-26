
import 'package:cloud_firestore/cloud_firestore.dart';

class MDVo {
  String? docId;

  MDVo({
    this.docId,
  });

  MDVo.fromDocumentSnapshot(DocumentSnapshot documentSnapshot) {
    docId = documentSnapshot['docId'];
  }
}