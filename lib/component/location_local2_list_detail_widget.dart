import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_poppin/controller/store_controller.dart';
import 'package:project_poppin/pages/popup_list_page.dart';
import 'package:project_poppin/theme/colors.dart';

import '../data/local_data.dart';
import '../global/share_preference.dart';
import '../services/analytics_helper.dart';

class LocationLocal2ListDetailWidget extends StatefulWidget {
  final int index;
  final StoreController storeController;

  const LocationLocal2ListDetailWidget(
      {super.key, required this.index, required this.storeController});

  @override
  State<LocationLocal2ListDetailWidget> createState() =>
      _LocationLocal2ListDetailWidgetState();
}

class _LocationLocal2ListDetailWidgetState
    extends State<LocationLocal2ListDetailWidget> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.storeController.storeFilterLocationList.clear();
        List<String> local2 =
            local[widget.storeController.storeLocationState]![widget.index].split('/');

        prefs.setStringList("local2", local2);

        widget.storeController.getStoreListLocationFilter(
            widget.storeController.storeLocationState, local2, true);

        if (Platform.isAndroid) {
          Get.to(() => const PopUpListPage(),
              transition: Transition.leftToRight,
              arguments: local[widget.storeController.storeLocationState]![
                  widget.index]);
        } else if (Platform.isIOS) {
          Get.to(() => const PopUpListPage(),
              arguments: local[widget.storeController.storeLocationState]![
                  widget.index]);
        }

        AnalyticsHelper().logEvent(
          'onLoad_map_filter_list',
          {
            'screen_class': "popup_list_page",
            'platform' : Platform.isAndroid ? 'android' : 'ios'
          },
        );
      },
      child: Container(
        height: MediaQuery.sizeOf(context).height * 0.06,
        decoration: const BoxDecoration(
            border: Border(
                bottom: BorderSide(width: 1, color: poppinColorGrey200))),
        margin: const EdgeInsets.only(left: 2, bottom: 2),
        child: Row(
          children: [
            Container(
              margin: const EdgeInsets.only(left: 10),
              child: local.keys.contains(local[
                      widget.storeController.storeLocationState]![widget.index])
                  ? Text(
                      "${local[widget.storeController.storeLocationState]![widget.index]} 전체",
                      style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w400,
                          color: poppinColorDarkGrey500),
                    )
                  : Text(
                      local[widget.storeController.storeLocationState]![widget.index] == "중구/명동/중"
                          ? "중구/명동"
                          : local[widget.storeController.storeLocationState]![widget.index],
                      style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w400,
                          color: poppinColorDarkGrey500)),
            ),
          ],
        ),
      ),
    );
  }
}
