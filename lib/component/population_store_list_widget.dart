import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_poppin/controller/store_controller.dart';
import 'package:project_poppin/theme/colors.dart';
import 'package:project_poppin/vo/store_vo.dart';

import '../pages/store_detail_page.dart';
import '../utils/time_stamp_manager.dart';

class PopulationStoreListWidget extends StatefulWidget {
  final StoreVo storeData;
  final StoreController storeController;

  const PopulationStoreListWidget(
      {super.key, required this.storeData, required this.storeController});

  @override
  State<PopulationStoreListWidget> createState() =>
      _PopulationStoreListWidgetState();
}

class _PopulationStoreListWidgetState extends State<PopulationStoreListWidget> {

  List<String> addressList = [];

  @override
  void initState() {
    addressList = widget.storeData.address!.split(" ");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.storeController.setDetailStoreData(widget.storeData);

        Get.to(() => const StoreDetailPage(),
            transition: Transition.leftToRight);
      },
      child: Container(
        width: MediaQuery.sizeOf(context).width* 0.8,
        margin: const EdgeInsets.only(bottom: 20, left: 4, right: 4),
        padding: const EdgeInsets.only(left: 8, right: 8, top: 18, bottom: 18),
        decoration: BoxDecoration(boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.15),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 3), // changes position of shadow
          ),
        ], borderRadius: BorderRadius.circular(10), color: Colors.white),
        child: Row(
          children: [
            Container(
              margin: const EdgeInsets.only(right: 8),
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
                        style: const TextStyle(
                            fontWeight: FontWeight.w300,
                            color: poppinColorDarkGrey300,
                            fontSize: 10),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        "${widget.storeData.title}",
                        style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 12),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        "${timeStampToDate(widget.storeData.startDate!)}~${timeStampToDate(widget.storeData.endDate!)}",
                        style: const TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 12),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                  Flexible(
                      child: Text("${addressList[0]} ${addressList[1]}",
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              fontWeight: FontWeight.w300,
                              color: poppinColorDarkGrey300,
                              fontSize: 10)))
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
