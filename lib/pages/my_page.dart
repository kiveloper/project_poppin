import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_poppin/component/store_list_widget.dart';
import 'package:project_poppin/controller/store_controller.dart';

import '../theme/colors.dart';

class MyPage extends StatefulWidget {
  const MyPage({super.key});

  @override
  State<MyPage> createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  @override
  Widget build(BuildContext context) {
    dynamic lastPopTime;
    String userId = "";

    return PopScope(
      canPop: false,
      onPopInvoked: (bool didPop) {
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
          // 두 번 연속으로 뒤로가기 버튼을 누르면 앱 종료
          exit(0);
        }
      },
      child: GetBuilder<StoreController>(
          builder: (storeController) {
        return Scaffold(
          body: storeController.storeCurationList.isEmpty
              ? SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: MediaQuery.sizeOf(context).height*0.35),
                      Text(
                        "유저 코드를 입력해주세요",
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: poppinColorGreen500,
                            fontSize: 20),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(28),
                        child: TextField(
                          onChanged: (text) {
                            userId = text;
                          },
                          decoration: InputDecoration(
                            hintText: '유저 코드를 입력하세요',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      ElevatedButton(onPressed: () {
                        storeController.getCurationStoreData(userId);
                      }, child: Text("확인"))
                    ],
                  ),
                )
              : Column(
                children: [
                  Container(
                    padding: EdgeInsets.only(
                        top: MediaQuery.of(context).padding.top + 16),
                    child: const Row(
                      children: [
                        Expanded(
                          child: Text(
                            "인스타 ID",
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
                  SizedBox(height: 40,),
                  Expanded(
                    child: ListView.builder(
                        itemCount:
                        storeController.storeCurationList.length,
                        padding: const EdgeInsets.only(left: 16, right: 16),
                        itemBuilder: (context, index) {
                          return StoreListWidget(
                            storeData: storeController.storeCurationList[index],
                            index: index,
                          );
                        }),
                  )
                ],
              ),
        );
      }),
    );
  }
}
