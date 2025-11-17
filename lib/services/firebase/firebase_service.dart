import 'dart:io';

import 'package:firebase_core/firebase_core.dart';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../router/router.dart';
import 'firebase_options.dart';
import 'notification_helpers.dart';

class FirebaseService {
  static Future<void> initFirebase() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    await FirebaseMessaging.instance.setAutoInitEnabled(true);
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // Subscribe to topic based on build flavor
    const bool isRelease = bool.fromEnvironment('dart.vm.product');
    String topic = isRelease ? 'bxb_prod' : 'bxb_stg';
    await FirebaseMessaging.instance.subscribeToTopic(topic);
    debugPrint('Subscribed to topic: $topic');

    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    await FirebaseMessaging.instance.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    // Wait for APNs token (iOS) and FCM token to be ready
    String? token = await FirebaseMessaging.instance.getToken();
    debugPrint('FCM Token: $token');

    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage? message) => {
              if (message != null)
                {
                  debugPrint("${message.notification?.title}"),
                  debugPrint("${message.notification?.body}"),
                }
            });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      print("onMessage: ${message.data}");
      NotificationHelpers.initLocalNotification();

      if (Platform.isAndroid) {
        NotificationHelpers.showLocalNotification(message);
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      dynamic page = message.data["page"];
      dynamic id = message.data["id"];
      BuildContext? context = rootNavigatorKey.currentContext;
      switch (page) {
        case "handicap":
          context?.pushNamed(RouteNames.fixture.handicap);

          break;
        case "accumulator":
          context?.pushNamed(RouteNames.fixture.accumulator);
          break;
        case "finished_prediction":
          if (id != null) {
            context?.pushNamed(RouteNames.prediciton.historyDetail,
                queryParameters: {"id": id.toString()});
          } else {
            context?.pushNamed(RouteNames.prediciton.finishedHistory);
          }

          break;
        case "on_going_prediciton":
          if (id != null) {
            context?.pushNamed(RouteNames.prediciton.historyDetail,
                queryParameters: {"id": id.toString()});
          } else {
            context?.pushNamed(RouteNames.prediciton.onGoingHistory);
          }
          break;
        case "coin_history":
          context?.pushNamed(RouteNames.coin.coinHistory);

          break;
        case "score":
          context?.pushNamed(RouteNames.fixture.score);
          break;

        case "notification":
          context?.pushNamed(RouteNames.misc.notification);
          break;
        default:
      }
    });
  }

  static Future<RemoteMessage?> get notificationMessage =>
      FirebaseMessaging.instance.getInitialMessage();

  @pragma('vm:entry-point')
  static Future<void> _firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {}
}
