
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class TempFcmPage extends StatefulWidget {
  const TempFcmPage({super.key});

  @override
  State<TempFcmPage> createState() => _TempFcmPageState();
}

class _TempFcmPageState extends State<TempFcmPage> {

  var backText = "";

  @override
  void initState() {
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage? message) {
      if (message != null) {
        if (message.notification != null) {
          print("background"+ " ${message.notification!.title}");
          print("background"+ " ${message.notification!.body}");
          print("background"+ " ${message.data["click_action"]}");
        }
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 10),
            child: ElevatedButton(onPressed: () async{
              String? fcmToken = await FirebaseMessaging.instance.getToken();
              print("토큰 테스트 $fcmToken}");
            }, child: Text("testMessage")),
          ),
          Container(
            margin: EdgeInsets.only(top:10),
            child: ElevatedButton(onPressed: () async{
              if(await Permission.notification.isDenied) {
                await Permission.notification.request();
              }
            }, child: Text("permission")),
          ),
          Container(
            margin: EdgeInsets.only(top:10),
            child: ElevatedButton(onPressed: () async{
              FirebaseMessaging.onMessage.listen((RemoteMessage? message) {
                if (message != null) {
                  if (message.notification != null) {
                    print(message.notification!.title);
                    print(message.notification!.body);
                    print(message.data["click_action"]);
                  }
                }
              });
            }, child: Text("forground push")),
          ),
          Container(
            margin: EdgeInsets.only(top:10),
            child: ElevatedButton(onPressed: () async{
              FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage? message) {
                if (message != null) {
                  if (message.notification != null) {
                    print("background"+ " ${message.notification!.title}");
                    print("background"+ " ${message.notification!.body}");
                    print("background"+ " ${message.data["type"]}");
                  }
                }
              });
            }, child: Text("bacground push")),
          ),
        ],
      ),
    );
  }
}