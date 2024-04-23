import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../vo/store_vo.dart';

class StoreListWidget extends StatefulWidget {
  final StoreVo storeData;

  const StoreListWidget({super.key, required this.storeData});

  @override
  State<StoreListWidget> createState() => _StoreListWidgetState();
}

class _StoreListWidgetState extends State<StoreListWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.sizeOf(context).height*0.18,
      padding: EdgeInsets.only(right: 16, left: 16,),
      margin: EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Container(
            margin: EdgeInsets.only(right: 8),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                "${widget.storeData.thumbnailImgUrl}",
                width: 140,
                height: 140,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Image.asset(
                    "assets/images/poppin_logo.jpg",
                    width: 140,
                    height: 140,
                    fit: BoxFit.cover,
                  );
                },
              ),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("${widget.storeData.title}"),
                    Text("${timeStampToDate(widget.storeData.startDate!)}~${timeStampToDate(widget.storeData.endDate!)}"),
                  ],
                ),
                Flexible(child: Text("${widget.storeData.address}", overflow:TextOverflow.ellipsis,))
              ],
            ),
          )
        ],
      ),
    );
  }
}

String timeStampToDate(Timestamp timestamp) {
  final dateTime = timestamp.toDate();
  final formattedDate = "${dateTime.year}.${dateTime.month}.${dateTime.day}";
  return formattedDate;
}
