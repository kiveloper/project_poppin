import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:project_poppin/controller/store_controller.dart';
import 'package:project_poppin/theme/colors.dart';
import 'package:project_poppin/vo/store_vo.dart';

import '../pages/store_detail_page.dart';
import '../utils/time_stamp_manager.dart';

class PopulationStoreListWidget extends StatefulWidget {
  final StoreVo storeData;
  final StoreController storeController;

  const PopulationStoreListWidget({super.key, required this.storeData, required this.storeController});

  @override
  State<PopulationStoreListWidget> createState() =>
      _PopulationStoreListWidgetState();
}

class _PopulationStoreListWidgetState extends State<PopulationStoreListWidget> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        widget.storeController.setDetailStartMapStoreData(widget.storeData);

        Get.to(()=>const StoreDetailPage(), transition: Transition.leftToRight);
      },
      child: Container(
        height: MediaQuery.sizeOf(context).height * 0.18,
        margin: EdgeInsets.only(bottom: 30),
        padding: EdgeInsets.only(left: 12, right: 12,top: 18, bottom: 18),
        decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.15),
                spreadRadius: 5,
                blurRadius: 7,
                offset: Offset(0, 3), // changes position of shadow
              ),
            ],
            borderRadius: BorderRadius.circular(10),
            color: Colors.white
        ),
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
                            fontWeight: FontWeight.w300,
                            color: poppinSubTitleColor,
                            fontSize: 14),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        "${widget.storeData.title}",
                        style: TextStyle(fontWeight: FontWeight.w500),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        "${timeStampToDate(widget.storeData.startDate!)}~${timeStampToDate(widget.storeData.endDate!)}",
                        style: TextStyle(fontWeight: FontWeight.w500),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                  Flexible(
                      child: Text("${widget.storeData.address}",
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontWeight: FontWeight.w300,
                              color: poppinSubTitleColor,
                              fontSize: 14)))
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
