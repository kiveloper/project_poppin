import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_poppin/component/location_local2_list_detail_widget.dart';
import 'package:project_poppin/component/location_local1_list_widget.dart';
import 'package:project_poppin/controller/store_controller.dart';
import 'package:project_poppin/data/local_data.dart';
import 'package:project_poppin/theme/colors.dart';

class LocationSelectPage extends StatefulWidget {
  const LocationSelectPage({super.key});

  @override
  State<LocationSelectPage> createState() => _LocationSelectPageState();
}

class _LocationSelectPageState extends State<LocationSelectPage> {
  StoreController storeController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            padding:
                EdgeInsets.only(top: MediaQuery.of(context).padding.top + 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(
                  width: 50,
                ),
                const Text(
                  "지역 선택",
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                      color: poppinColorDarkGrey500),
                ),
                SizedBox(
                  width: 50,
                  child: TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text(
                        "취소",
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 10,
                            color: poppinColorDarkGrey400),
                      )),
                )
              ],
            ),
          ),
          Container(
            height: 1,
            color: poppinBackGroundColor,
          ),
          Expanded(
            child: GetBuilder<StoreController>(builder: (storeController) {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(
                    flex: 3,
                    child: ListView.builder(
                        padding: const EdgeInsets.only(top: 1),
                        itemCount: local.keys.length,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return LocationLocal1ListWidget(
                              index: index, controller: storeController
                          );
                        }),
                  ),
                  Flexible(
                    flex: 7,
                    child: ListView.builder(
                        padding: const EdgeInsets.only(top: 1),
                        itemCount:
                            local[storeController.storeLocationState]!.length,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return LocationLocal2ListDetailWidget(
                            index: index,
                            storeController: storeController,
                          );
                        }),
                  )
                ],
              );
            }),
          )
        ],
      ),
    );
  }
}
