import 'package:flutter/material.dart';
import 'package:project_poppin/controller/store_controller.dart';
import 'package:project_poppin/global/share_preference.dart';
import 'package:project_poppin/theme/colors.dart';

import '../data/local_data.dart';

class LocationLocal1ListWidget extends StatefulWidget {
  final int index;
  final StoreController controller;

  const LocationLocal1ListWidget(
      {super.key, required this.index, required this.controller});

  @override
  State<LocationLocal1ListWidget> createState() =>
      _LocationLocal1ListWidgetState();
}

class _LocationLocal1ListWidgetState extends State<LocationLocal1ListWidget> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        widget.controller.setLocationState(local.keys.elementAt(widget.index));
        prefs.setString("local1", local.keys.elementAt(widget.index));
      },
      child: Container(
        height: MediaQuery.sizeOf(context).height*0.06,
        margin: const EdgeInsets.only(bottom: 2),
        color: widget.controller.storeLocationState ==
                local.keys.elementAt(widget.index)
            ? Colors.transparent
            : poppinColorGrey200,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(width: 12,),
            Text(local.keys.elementAt(widget.index),
                style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                    color: poppinColorDarkGrey500)),
            widget.controller.storeLocationState ==
                    local.keys.elementAt(widget.index)
                ? const Icon(Icons.arrow_forward_ios, size: 12)
                : const SizedBox(width: 12,)
          ],
        ),
      ),
    );
  }
}
