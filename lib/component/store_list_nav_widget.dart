import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:project_poppin/controller/store_controller.dart';
import 'package:project_poppin/pages/popup_list_page.dart';
import 'package:project_poppin/pages/store_detail_nav_page.dart';
import 'package:project_poppin/theme/colors.dart';

import '../utils/time_stamp_manager.dart';
import '../vo/store_vo.dart';

class StoreListNavWidget extends StatefulWidget {
  final StoreVo storeData;
  final int index;

  const StoreListNavWidget(
      {super.key, required this.storeData, required this.index});

  @override
  State<StoreListNavWidget> createState() => _StoreListNavWidgetState();
}

class _StoreListNavWidgetState extends State<StoreListNavWidget> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<StoreController>(builder: (storeController) {
      return GestureDetector(
        onTap: () {
          storeController.setDetailNavStoreData(widget.storeData);

          storeController.setStoreDetailState(true);
        },
        child: Container(
          height: MediaQuery.sizeOf(context).height * 0.18,
          margin: EdgeInsets.only(bottom: 30),
          color: Colors.transparent,
          child: Row(
            children: [
              Container(
                margin: EdgeInsets.only(right: 8),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: AspectRatio(
                    aspectRatio: 1 / 1,
                    child: Image.network(
                      "${widget.storeData.thumbnailImgUrl}",
                      width: 140,
                      height: 140,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Image.asset(
                          "assets/images/no_img.jpg",
                          width: 140,
                          height: 140,
                          fit: BoxFit.cover,
                        );
                      },
                    ),
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
                        Text(
                          "${widget.storeData.category}",
                          style: TextStyle(
                              fontWeight: FontWeight.w400,
                              color: poppinColorDarkGrey400,
                              fontSize: 10),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          "${widget.storeData.title}",
                          style: TextStyle(fontWeight: FontWeight.w400,fontSize: 12),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          "${timeStampToDate(widget.storeData.startDate!)}~${timeStampToDate(widget.storeData.endDate!)}",
                          style: TextStyle(fontWeight: FontWeight.w400, fontSize: 12),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                    Flexible(
                        child: Text("${widget.storeData.address}",
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontWeight: FontWeight.w400,
                                color: poppinColorDarkGrey400,
                                fontSize: 10)))
                  ],
                ),
              )
            ],
          ),
        ),
      );
    });
  }
}
