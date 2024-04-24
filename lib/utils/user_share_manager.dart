
import 'package:flutter_share/flutter_share.dart';

Future<void> share(String title, String text, String linkUrl) async {
  await FlutterShare.share(
      title: title,
      text: text,
      linkUrl: linkUrl,
      chooserTitle: 'Poppin'
  );
}