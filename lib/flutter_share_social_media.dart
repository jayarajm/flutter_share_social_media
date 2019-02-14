import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/services.dart';

enum ShareType { facebook, instagram, more }

class FlutterShareSocialMedia {
  static const MethodChannel _channel =
      const MethodChannel('flutter_share_social_media');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  static Future<String> share(ShareType type, Uint8List imageBytes, String caption) async {
    final Map<String, dynamic> params = <String, dynamic>{
      "type": type.toString(),
      "image": imageBytes,
      "caption": caption
    };
    final String message = await _channel.invokeMethod('share', params);
    return message;
  }

  static Future<String> shareFacebook(Uint8List imageBytes) async {
    final String message =
        await _channel.invokeMethod('shareFacebook', imageBytes);
    return message;
  }

  static Future<String> shareInstagram(Uint8List imageBytes) async {
    final String message =
        await _channel.invokeMethod('shareInstagram', imageBytes);
    return message;
  }
}
