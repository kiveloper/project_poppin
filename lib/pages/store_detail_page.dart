import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_poppin/controller/store_controller.dart';

import '../theme/colors.dart';
import '../utils/user_share_manager.dart';

class StoreDetailPage extends StatefulWidget {
  const StoreDetailPage({super.key});

  @override
  State<StoreDetailPage> createState() => _StoreDetailPageState();
}

class _StoreDetailPageState extends State<StoreDetailPage> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<StoreController>(
      builder: (storeController) {
        return Scaffold(
          body: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(
                  top: MediaQuery.of(context).padding.top + 10,
                  left: 28,
                  right: 28),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      IconButton(
                          onPressed: () {
                            storeController.setStoreDetailState(false);
                          },
                          icon: Icon(Icons.arrow_back_ios)),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        storeController
                            .detailStoreData.thumbnailImgUrl!,
                        height: MediaQuery.sizeOf(context).width - 70,
                        width: MediaQuery.sizeOf(context).width - 70,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Image.asset(
                            "assets/images/no_img.jpg",
                            height:
                            MediaQuery.sizeOf(context).width - 70,
                            width:
                            MediaQuery.sizeOf(context).width - 70,
                            fit: BoxFit.cover,
                          );
                        },
                      )),
                  SizedBox(
                    height: 28,
                  ),
                  Text(
                    "팝업정보",
                    style: TextStyle(color: poppinSubColor),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Container(
                    height: 2,
                    width: MediaQuery.sizeOf(context).width - 50,
                    color: poppinSubColor,
                  ),
                  SizedBox(
                    height: 28,
                  ),
                  Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              storeController.detailStoreData.title!,
                              style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w700,
                                  overflow: TextOverflow.ellipsis
                              ),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.share, color: poppinSubColor,),
                            onPressed: () async {
                              share(
                                storeController.detailStoreData.title!,
                                storeController
                                    .detailStoreData.description!,
                                storeController.detailStoreData
                                    .relatedContentsUrl!,
                              );
                            },
                          ),
                        ],
                      ),
                      SizedBox(height: 10,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(child: Text("${storeController.detailStoreData.description!}")),
                        ],
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        );
      }
    );
  }
}
