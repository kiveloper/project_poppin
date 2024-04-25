import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:project_poppin/component/location_list_detail_widget.dart';
import 'package:project_poppin/component/location_list_widget.dart';
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
                SizedBox(
                  width: 50,
                ),
                Text(
                  "지역 선택",
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
                ),
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      "취소",
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                          color: poppinSubTitleColor),
                    ))
              ],
            ),
          ),
          SizedBox(
            height: 30,
          ),
          Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: poppinBackGroundColor),
            padding: EdgeInsets.all(16),
            margin: EdgeInsets.only(left: 16, right: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("시/도 선택"),
                SizedBox(
                  width: 30,
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 20,
                ),
                SizedBox(
                  width: 30,
                ),
                Text("시/군/구 선택"),
              ],
            ),
          ),
          SizedBox(
            height: 30,
          ),
          Container(
            height: 1,
            color: poppinBackGroundColor,
          ),
          Expanded(
            child: GetBuilder<StoreController>(
              builder: (storeController) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                      flex: 3,
                      child: ListView.builder(
                          padding: EdgeInsets.only(top: 1),
                          itemCount: local.keys.length,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return LocationListWidget(index: index, controller: storeController);
                          }),
                    ),
                    Flexible(
                      flex: 7,
                      child: ListView.builder(
                          padding: EdgeInsets.only(top: 1),
                          itemCount: local[storeController.storeLocationState]!.length,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return LocationListDetailWidget(index: index, storeController: storeController,);
                          }),
                    )
                  ],
                );
              }
            ),
          )
        ],
      ),
    );
  }
}
