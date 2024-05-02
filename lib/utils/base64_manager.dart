import 'dart:convert';
import 'dart:typed_data';

Uint8List base64Decoder(String baseString) {
  Uint8List decodingImg = base64Decode(baseString.split(',')[1]);
  return decodingImg;
}