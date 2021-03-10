import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'http.dart';

class FirebaseSettings {
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  BuildContext context;

  init(BuildContext contextt) {
    this.context = contextt;
    var initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/launcher_icon');
    var initializationSettingsIOS = IOSInitializationSettings(
        onDidReceiveLocalNotification: onDidReceiveLocalNotification);
    var initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
    flutterLocalNotificationsPlugin
        .initialize(initializationSettings,
            onSelectNotification: selectNotification)
        .then((value) => _initFirebaseMessaging());
  }

  _initFirebaseMessaging() {
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        _showNotification(message);
      },
      // onBackgroundMessage: Platform.isIOS? null:myBackgroundMessageHandler,
      onLaunch: (Map<String, dynamic> message) async {
        _showNotification(message);
      },
      onResume: (Map<String, dynamic> message) async {
        _showNotification(message);
      },
    );
    _firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(
            sound: true, badge: true, alert: true, provisional: false));
    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {});
    // _firebaseMessaging.getToken().then((String token) {
    //   assert(token != null);
    // });
    // _firebaseMessaging.subscribeToTopic("matchscore");
  }

  Future _showNotification(Map<String, dynamic> message) async {
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
        'channel id', 'channel name', 'channel desc',
        importance: Importance.max,
        priority: Priority.high,
        styleInformation: BigTextStyleInformation(''));
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();

    var platformChannelSpecifics = new NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      0,
      message['notification']['title'],
      message['notification']['body'],
      platformChannelSpecifics,
    );
  }

  Future selectNotification(String payload) async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }

  Future onDidReceiveLocalNotification(
      int id, String title, String body, String payload) async {
    showDialog(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: Text(
          title,
          textScaleFactor: .8,
        ),
        content: Text(
          body,
          textScaleFactor: .8,
        ),
        actions: [
          CupertinoDialogAction(
            isDefaultAction: true,
            child: Text(
              'Ok',
              textScaleFactor: .8,
            ),
            onPressed: () async {
              // Navigator.of(context, rootNavigator: true).pop();
              // await Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeft, child: SecondScreen(payload),
              //   ),
              // );
            },
          )
        ],
      ),
    );
  }

  updateToken() async {
    String fcmToken = await _firebaseMessaging.getToken();
    var response = await Http(url: 'fcm/update', body: {'fcm_token': fcmToken})
        .putWithHeader();
    return response;
  }

  revokeToken() async {
    var response = await Http(url: 'fcm/revoke', body: null).putWithHeader();
    return response;
  }
}
