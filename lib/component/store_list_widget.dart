import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_poppin/controller/store_controller.dart';
import 'package:project_poppin/pages/store_detail_page.dart';
import 'package:project_poppin/theme/colors.dart';

import '../utils/base64_manager.dart';
import '../vo/store_vo.dart';

class StoreListWidget extends StatefulWidget {
  final StoreController storeController;
  final StoreVo storeData;
  final int index;

  const StoreListWidget(
      {super.key,
      required this.storeData,
      required this.index,
      required this.storeController});

  @override
  State<StoreListWidget> createState() => _StoreListWidgetState();
}

class _StoreListWidgetState extends State<StoreListWidget> {

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.storeController.setDetailStoreData(widget.storeData);
        if (Platform.isAndroid) {
          Get.to(() => const StoreDetailPage(),
              transition: Transition.leftToRight);
        } else if (Platform.isIOS) {
          Get.to(() => const StoreDetailPage());
        }
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
                    child: CachedNetworkImage(
                      imageUrl: widget.storeData.thumbnailImgUrl!,
                      width: 140,
                      height: 140,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        color: poppinColorDarkGrey50,
                        child: const Center(
                          child: CircularProgressIndicator(),
                        ),
                      ),
                      errorWidget: (context, error, stackTrace) {
                        try {
                          var base64file = base64Decoder(widget.storeData.thumbnailImgUrl!);
                          return Image.memory(
                              base64file,
                              width: 140,
                              height: 140,
                              gaplessPlayback: true,
                              fit: BoxFit.cover);
                        } catch (e) {
                          return Image.asset(
                              "assets/images/no_img.png",
                              width: 140,
                              height: 140,
                              fit: BoxFit.cover);
                        }
                      },
                    )),
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
                            fontWeight: FontWeight.w500,
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
                        "${widget.storeData.startDate!}~${widget.storeData.endDate!}",
                        style: const TextStyle(fontWeight: FontWeight.w500),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                  Flexible(
                      child: Text("${widget.storeData.address!.split(" ")[0]} ${widget.storeData.address!.split(" ")[1]}",
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              fontWeight: FontWeight.w500,
                              color: poppinSubTitleColor,
                              fontSize: 12)))
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}