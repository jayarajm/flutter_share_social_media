import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:ui' as ui;
import 'dart:typed_data';
import 'package:flutter/rendering.dart';

import 'package:flutter/services.dart';
import 'package:flutter_share_social_media/flutter_share_social_media.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';

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
                ),
                Container(
                  child: RaisedButton(
                    onPressed: shareSheet,
                    child: Text("Share Sheet"),
                  ),
                  width: 100,
                  height: 50,
                ),
                Container(
                  child: RaisedButton(
                    onPressed: initiateFacebookLogin,
                    child: Text("Facebook login"),
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
    ByteData byteData = await getGloableImageData();
    String result = await FlutterShareSocialMedia.share(
        ShareType.facebook, byteData.buffer.asUint8List(), "caption");
    print(result);
  }

  shareInstagram() async {
    ByteData byteData = await getGloableImageData();
    String result = await FlutterShareSocialMedia.share(
        ShareType.instagram, byteData.buffer.asUint8List(), "caption");
    print(result);
  }

  shareSheet() async {
    ByteData byteData = await getGloableImageData();
    String result = await FlutterShareSocialMedia.share(
        ShareType.more, byteData.buffer.asUint8List(), "caption");
    print(result);
  }

  initiateFacebookLogin() async {
    final facebookLogin = FacebookLogin();
    facebookLogin.loginBehavior = FacebookLoginBehavior.webViewOnly;
    final facebookLoginResult =
        await facebookLogin.logInWithReadPermissions(['email', 'user_friends']);
    switch (facebookLoginResult.status) {
      case FacebookLoginStatus.cancelledByUser:
        break; // do nothing
      case FacebookLoginStatus.error:
        // await showErrorDialog(context);
        break;
      case FacebookLoginStatus.loggedIn:
        // change UI now that login is in progress
        setState(() {
          // gettingFbData = true;
        });
        // final fbProfile = fbApiService
        //     .getFacebookProfile(facebookLoginResult.accessToken.token);
        // print(fbProfile);
        break;
      default:
        break;
    }
  }

  Future<ByteData> getGloableImageData() async {
    RenderRepaintBoundary boundary =
        _globalKey.currentContext.findRenderObject();
    ui.Image image = await boundary.toImage();
    return await image.toByteData(format: ui.ImageByteFormat.png);
  }
}
