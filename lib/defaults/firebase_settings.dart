import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:food_booking_app/defaults/local-notification.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'http.dart';


FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

_showNotification(RemoteNotification notification) {
  var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
    'channel id',
    'channel name',
    'channel desc',
    icon: '@mipmap/ic_launcher',
    importance: Importance.max,
    priority: Priority.high,
    styleInformation: BigTextStyleInformation('')
  );
  var iOSPlatformChannelSpecifics = IOSNotificationDetails();

  var platformChannelSpecifics = new NotificationDetails(android: androidPlatformChannelSpecifics, iOS: iOSPlatformChannelSpecifics);
  flutterLocalNotificationsPlugin.show(
      0,
    notification.title,
    notification.body,
    platformChannelSpecifics,
  );
}

class FirebaseSettings {
  BuildContext context;

  init(BuildContext contextt) async{
    SharedPreferences _sharedPreference = await SharedPreferences.getInstance();
    this.context = contextt;
    // FirebaseMessaging.onBackgroundMessage(_messageHandler);
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (_sharedPreference.getBool('notify')) {
        if (message.notification.title == 'Truck is in set disposal area.') {
          if (_sharedPreference.getBool('notifyAtDisposal')) {
            _showNotification(message.notification);
          }
        }
        else {
          _showNotification(message.notification);
        }
      }
    });
    FirebaseMessaging.onMessageOpenedApp.listen((message) async {
    });
  }

  updateToken() async{
    var response;
    FirebaseMessaging _firebaseMessaging;
    _firebaseMessaging = FirebaseMessaging.instance;
    _firebaseMessaging.getToken().then((value) async {
      response = await Http(url: 'fcm', body: {'fcm': value}).putWithHeader();
    });
    return response;
  }

  revokeToken() async{
    var response = await Http(url: 'fcm/revoke', body: null).putWithHeader();
    return response;
  }
}