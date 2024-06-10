import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_poppin/controller/store_controller.dart';
import 'package:project_poppin/pages/store_detail_page.dart';
import 'package:project_poppin/theme/colors.dart';

import '../utils/base64_manager.dart';
import '../utils/time_stamp_manager.dart';
import '../vo/store_vo.dart';

class StoreListWidget extends StatefulWidget {
  final StoreVo storeData;
  final int index;

  const StoreListWidget(
      {super.key, required this.storeData, required this.index});

  @override
  State<StoreListWidget> createState() => _StoreListWidgetState();
}

class _StoreListWidgetState extends State<StoreListWidget> {
  List<String> adressList = [];

  @override
  void initState() {
    adressList = widget.storeData.address!.split(" ");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<StoreController>(builder: (storeController) {
      return GestureDetector(
        onTap: () {
          storeController.setDetailStoreData(widget.storeData);

          Get.to(() => const StoreDetailPage());
        },
        child: Container(
          height: MediaQuery.sizeOf(context).height * 0.18,
          margin: const EdgeInsets.only(bottom: 30),
          color: Colors.transparent,
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
                        try {
                          return Image.memory(
                              base64Decoder(widget.storeData.thumbnailImgUrl!),
                              width: 140,
                              height: 140,
                              fit: BoxFit.cover);
                        } catch (e) {
                          return Image.asset(
                            "assets/images/no_img.jpg",
                            width: 140,
                            height: 140,
                            fit: BoxFit.cover,
                          );
                        }
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
                              color: poppinSubTitleColor,
                              fontSize: 12),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          "${widget.storeData.title}",
                          style: const TextStyle(fontWeight: FontWeight.w500),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          "${timeStampToDate(widget.storeData.startDate!)}~${timeStampToDate(widget.storeData.endDate!)}",
                          style: const TextStyle(fontWeight: FontWeight.w500),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                    Flexible(
                        child: Text("${adressList[0]} ${adressList[1]}",
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                fontWeight: FontWeight.w300,
                                color: poppinSubTitleColor,
                                fontSize: 12)))
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
