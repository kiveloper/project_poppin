import 'package:flutter/material.dart';
import 'package:project_poppin/controller/store_controller.dart';
import 'package:project_poppin/theme/colors.dart';

import '../data/local_data.dart';
import '../global/share_preference.dart';

class LocationListDetailWidget extends StatefulWidget {
  final int index;
  final StoreController storeController;
  const LocationListDetailWidget({super.key, required this.index, required this.storeController});

  @override
  State<LocationListDetailWidget> createState() => _LocationListDetailWidgetState();
}

class _LocationListDetailWidgetState extends State<LocationListDetailWidget> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        List<String> local2 = local[widget.storeController.storeLocationState]![widget.index].split('/');

        prefs.setStringList("local2", local2);
        widget.storeController.getStoreListLocationFilter(widget.storeController.storeLocationState, local2);

        Navigator.pop(context);
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(width: 1, color: poppinBackGroundColor))
        ),
        padding: EdgeInsets.only(bottom: 16, top: 16),
        margin: EdgeInsets.only(bottom: 2),
        child: Container(
            margin: EdgeInsets.only(left: 10),
            child: local.keys.contains(local[widget.storeController.storeLocationState]![widget.index])
                ? Text("${local[widget.storeController.storeLocationState]![widget.index]} 전체")
                : Text(local[widget.storeController.storeLocationState]![widget.index])
        ),
      ),
    );
  }
}
