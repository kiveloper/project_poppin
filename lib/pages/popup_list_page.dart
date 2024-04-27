import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:project_poppin/component/store_list_widget.dart';
import 'package:project_poppin/component/store_list_nav_widget.dart';
import 'package:project_poppin/controller/store_controller.dart';
import 'package:project_poppin/global/share_preference.dart';
import 'package:project_poppin/pages/location_select_page.dart';
import 'package:project_poppin/pages/store_detail_nav_page.dart';

class PopUpListPage extends StatefulWidget {
  const PopUpListPage({super.key});

  @override
  State<PopUpListPage> createState() => _PopUpListPageState();
}

class _PopUpListPageState extends State<PopUpListPage> {
  String locationName = Get.arguments;

  var lastPopTime;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<StoreController>(builder: (storeController) {
      return Scaffold(
        body: Column(
          children: [
            Container(
              padding: EdgeInsets.only(
                  top: MediaQuery.of(context).padding.top + 10),
              child: Row(
                children: [
                  IconButton(onPressed: (){
                    Navigator.pop(context);
                  }, icon: Icon(Icons.arrow_back_ios)),
                  Expanded(
                    child: Text(
                      "$locationName 팝업스토어",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontWeight: FontWeight.w600, fontSize: 18),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 40,
            ),
            storeController.storeFilterLocationList.isEmpty
                ? Center(
                    child: Text(
                      "진행중인 팝업이 없습니다",
                      style: TextStyle(
                          fontSize: 22, fontWeight: FontWeight.w500),
                    ),
                  )
                : Expanded(
                    child: ListView.builder(
                        itemCount: storeController.storeFilterLocationList.length,
                        padding: EdgeInsets.only(left: 16, right: 16),
                        itemBuilder: (context, index) {
                          return StoreListWidget(
                            storeData: storeController.storeFilterLocationList[index],
                            index: index,
                          );
                        }))
          ],
        ),
      );
    });
  }
}
