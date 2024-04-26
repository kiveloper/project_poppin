import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_poppin/controller/store_controller.dart';
import 'package:project_poppin/utils/time_stamp_manager.dart';
import 'package:url_launcher/url_launcher_string.dart';

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
    return GetBuilder<StoreController>(builder: (storeController) {
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
                          Navigator.pop(context);
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
                      storeController.detailStoreStartMapData.thumbnailImgUrl!,
                      height: MediaQuery.sizeOf(context).width * 0.8,
                      width: MediaQuery.sizeOf(context).width * 0.8,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Image.asset(
                          "assets/images/no_img.jpg",
                          height: MediaQuery.sizeOf(context).width * 0.8,
                          width: MediaQuery.sizeOf(context).width * 0.8,
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
                            storeController.detailStoreStartMapData.title!,
                            style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w700,
                                overflow: TextOverflow.ellipsis),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.share,
                            color: poppinSubColor,
                          ),
                          onPressed: () async {
                            share(
                              storeController.detailStoreStartMapData.title!,
                              storeController
                                  .detailStoreStartMapData.description!,
                              storeController
                                  .detailStoreStartMapData.relatedContentsUrl!,
                            );
                          },
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                            child: Text(
                          "${storeController.detailStoreStartMapData.description!}",
                          style: TextStyle(
                              fontWeight: FontWeight.w500, fontSize: 15),
                        )),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.location_on_outlined,
                          color: poppinMainColor,
                        ),
                        SizedBox(
                          width: 4,
                        ),
                        Expanded(
                            child: Text(
                                "${storeController.detailStoreStartMapData.address!}")),
                      ],
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.calendar_month_outlined,
                          color: poppinMainColor,
                        ),
                        SizedBox(
                          width: 4,
                        ),
                        Expanded(
                            child: Text(
                                "${timeStampToDate(storeController.detailStoreStartMapData.startDate!)}~${timeStampToDate(storeController.detailStoreStartMapData.endDate!)}")),
                      ],
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                          onPressed: () async {
                            await launchUrlString(storeController
                                .detailStoreStartMapData.relatedContentsUrl!);
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: poppinSubColor,
                              foregroundColor: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)
                            )
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(top: 16, bottom: 16),
                            child: Text(
                              "상세 정보 보러가기",
                              style: TextStyle(fontSize: 16, color: Colors.white),
                            ),
                          )),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      );
    });
  }
}
