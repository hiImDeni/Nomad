import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:overlay_support/overlay_support.dart';

class NotificationService extends ChangeNotifier {
  //todo: cloud functions to automatically send notifications

  static final  FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  static User user = FirebaseAuth.instance.currentUser;

  static void  registerNotification() async {
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // On iOS, this helps to take the user permissions
    // ignored if on Android
    NotificationSettings settings = await firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');

      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        // Parse the message received
        var title = message.notification.title;
        var body = message.notification.body;

        showSimpleNotification(
          Text(title),
          leading: Icon(Icons.info_outline),
          subtitle: Text(body),
          // background: Colors.cyan.shade700,
          duration: Duration(seconds: 2),
        );
      });

      firebaseMessaging.getToken().then((token) {
        print('token: $token');
        FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .update({'pushToken': token});
      });
    } else {
      print('User declined or has not accepted permission');
    }
  }

  static Future _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
    print("Handling a background message: ${message.messageId}");
  }

  static checkForInitialMessage() async {
    RemoteMessage initialMessage = await firebaseMessaging.getInitialMessage();

    if (initialMessage != null) {
      var title = initialMessage.notification.title;
      var body = initialMessage.notification.body;

    }
  }

  void configLocalNotification() {
    var initializationSettingsAndroid = new AndroidInitializationSettings('app_icon');
    var initializationSettingsIOS = new IOSInitializationSettings();
    var initializationSettings = new InitializationSettings(android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }
}