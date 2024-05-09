import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_poppin/controller/store_controller.dart';
import 'package:project_poppin/theme/colors.dart';

import '../component/store_list_widget.dart';

class PopUpListNavPage extends StatefulWidget {
  const PopUpListNavPage({super.key});

  @override
  State<PopUpListNavPage> createState() => _PopUpListNavPageState();
}

class _PopUpListNavPageState extends State<PopUpListNavPage> {
  ScrollController scrollController = ScrollController();
  dynamic lastPopTime;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<StoreController>(builder: (storeController) {
      return PopScope(
          canPop: false,
          onPopInvoked: (bool didPop) {
            if (storeController.storeDetailState) {
              storeController
                  .setStoreDetailState(!storeController.storeDetailState);
            } else {
              final now = DateTime.now();
              if (lastPopTime == null ||
                  now.difference(lastPopTime) > const Duration(seconds: 2)) {
                lastPopTime = now;
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('뒤로 버튼을 한번 더 누르면 앱이 종료됩니다.'),
                  ),
                );
                return;
              } else {
                exit(0);
              }
            }
          },
          child: Scaffold(
            body: Column(
              children: [
                Container(
                  padding: EdgeInsets.only(
                      top: MediaQuery.of(context).padding.top + 16),
                  child: const Row(
                    children: [
                      Expanded(
                        child: Text(
                          "팝업 리스트",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 13,
                              color: poppinColorGreen500),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
                storeController.storeAllList.isEmpty
                    ? const Center(
                        child: Text(
                          "진행중인 팝업이 없습니다",
                          style: TextStyle(
                              fontSize: 22, fontWeight: FontWeight.w500),
                        ),
                      )
                    : Expanded(
                        child: ListView.builder(
                            controller: scrollController,
                            itemCount: storeController.storeAllList.length,
                            padding: const EdgeInsets.only(left: 16, right: 16),
                            itemBuilder: (context, index) {
                              return StoreListWidget(
                                storeData: storeController.storeAllList[index],
                                index: index,
                              );
                            }))
              ],
            ),
          ));
    });
  }
}
