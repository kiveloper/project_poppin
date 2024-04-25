import 'package:cloud_firestore/cloud_firestore.dart';

String timeStampToDate(Timestamp timestamp) {
  final dateTime = timestamp.toDate();
  final formattedDate = "${dateTime.year}.${dateTime.month}.${dateTime.day}";
  return formattedDate;
}