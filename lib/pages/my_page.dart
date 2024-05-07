import 'dart:io';

import 'package:flutter/material.dart';

class MyPage extends StatefulWidget {
  const MyPage({super.key});

  @override
  State<MyPage> createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  @override
  Widget build(BuildContext context) {

    dynamic lastPopTime;

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
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset("assets/images/poppin_logo.png", height: 100, width: double.infinity),
              const SizedBox(height: 20),
              const Text("마이페이지 서비스는", style: TextStyle(fontWeight: FontWeight.w400, fontSize: 14),),
              const Text.rich(TextSpan(
                children: <TextSpan>[
                  TextSpan(text: '준비중', style: TextStyle(fontWeight: FontWeight.w600,fontSize: 14)),
                  TextSpan(text: ' 입니다', style: TextStyle(fontSize: 14)),
                ]
              )),
              const SizedBox(height: 30,),
              const Text("빠른 시간 안에 만나요:D", style: TextStyle(fontWeight: FontWeight.w400, fontSize: 14),),
              SizedBox(height: MediaQuery.sizeOf(context).height*0.1,),
              const Text("문의사항", style: TextStyle(fontWeight: FontWeight.w400, fontSize: 14),),
              const Text("contact@kapitalletter.com", style: TextStyle(fontWeight: FontWeight.w400, fontSize: 14,decoration: TextDecoration.underline),),
            ],
          ),
        ),
      ),
    );
  }
}
