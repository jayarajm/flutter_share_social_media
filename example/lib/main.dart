import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:ui' as ui;
import 'dart:typed_data';
import 'package:flutter/rendering.dart';
import 'dart:io';
import 'package:flutter/services.dart' show rootBundle;

import 'package:flutter/services.dart';
import 'package:flutter_share_social_media/flutter_share_social_media.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';
  GlobalKey _globalKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      platformVersion = await FlutterShareSocialMedia.platformVersion;
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
            title: const Text('Plugin example app'),
          ),
          body: Center(
            child: Column(
              children: <Widget>[
                RepaintBoundary(
                  key: _globalKey,
                  child: Container(
                    width: 200,
                    height: 200,
                    color: Colors.red,
                  ),
                ),
                Container(
                  child: RaisedButton(
                    onPressed: shareFacebook,
                    child: Text("Share FB"),
                  ),
                  width: 100,
                  height: 50,
                ),
                Container(
                  child: RaisedButton(
                    onPressed: shareInstagram,
                    child: Text("Share Insta"),
                  ),
                  width: 100,
                  height: 50,
                )
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: shareFacebook,
            tooltip: 'Increment',
            child: Icon(Icons.add),
          )),
    );
  }

  shareFacebook() async {
    RenderRepaintBoundary boundary =
        _globalKey.currentContext.findRenderObject();
    ui.Image image = await boundary.toImage();
    ByteData byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    await FlutterShareSocialMedia.shareFacebook(byteData.buffer.asUint8List());
    // print(result);
  }

  shareInstagram() async {
    RenderRepaintBoundary boundary =
        _globalKey.currentContext.findRenderObject();
    ui.Image image = await boundary.toImage();
    ByteData byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    await FlutterShareSocialMedia.shareInstagram(byteData.buffer.asUint8List());
    // print(result);
  }
}
