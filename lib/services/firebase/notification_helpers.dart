import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationHelpers {
  static FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static void initLocalNotification() async {
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('ic_launcher');
    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
      requestSoundPermission: true,
      requestBadgePermission: true,
      requestAlertPermission: true,
      //onDidReceiveLocalNotification: (int i,){},
    );
    const DarwinInitializationSettings initializationSettingsMacOS =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    const InitializationSettings initializationSettings =
        InitializationSettings(
            android: initializationSettingsAndroid,
            iOS: initializationSettingsIOS,
            macOS: initializationSettingsMacOS);
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: (response) {
      // if (response.payload != null) {
      //   final notificationFlag = response.payload!;
      //   AppRoutes.toMainPageFromNotification(notificationFlag);
      // }
    });
  }

  /// Create a [AndroidNotificationChannel] for heads up notifications
  static AndroidNotificationChannel channel = const AndroidNotificationChannel(
    "ATOM_POWER",
    'High Importance Notifications',
    description: 'This channel is used for hey play notifications.', // title
    importance: Importance.high,
  );

  static showLocalNotification(RemoteMessage message) async {
    try {
      log("Notification is received and message is ${message.notification?.title}");
      const android = AndroidNotificationDetails(
        "ap_channel_id",
        "ap_channel",
        channelDescription: 'channel description',
        priority: Priority.high,
        importance: Importance.max,
        playSound: true,
        icon: "@drawable/ic_launcher",
        color: Colors.black,
        colorized: true,
      );
      const iOS = DarwinNotificationDetails();
      const platform = NotificationDetails(android: android, iOS: iOS);
      await flutterLocalNotificationsPlugin.show(
        0,
        message.notification?.title ?? "BXB",
        message.notification?.body,
        platform,
      );
    } catch (e) {
      log("Error is $e");
    }
  }
}
