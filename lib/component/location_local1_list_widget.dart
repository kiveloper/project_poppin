import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project_poppin/controller/store_controller.dart';
import 'package:project_poppin/global/share_preference.dart';
import 'package:project_poppin/theme/colors.dart';

import '../data/local_data.dart';

class LocationLocal1ListWidget extends StatefulWidget {
  final int index;
  final StoreController controller;

  const LocationLocal1ListWidget({super.key, required this.index, required this.controller});

  @override
  State<LocationLocal1ListWidget> createState() => _LocationLocal1ListWidgetState();
}

class _LocationLocal1ListWidgetState extends State<LocationLocal1ListWidget> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async{
        widget.controller.setLocationState(local.keys.elementAt(widget.index));
        prefs.setString("local1", local.keys.elementAt(widget.index));
      },
      child: Container(
        padding: EdgeInsets.only(bottom: 16, top: 16),
        margin: EdgeInsets.only(bottom: 2),
        color: Colors.transparent,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(width: 12,),
            Text(local.keys.elementAt(widget.index)),
            widget.controller.storeLocationState == local.keys.elementAt(widget.index)
                ? Icon(Icons.arrow_forward_ios,size: 12)
                : SizedBox()
          ],
        ),
      ),
    );
  }
}
