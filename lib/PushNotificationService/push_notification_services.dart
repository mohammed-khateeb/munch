import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';


class PushNotificationServices {
  static String? fcmToken;

  static final flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static setUpLocalNotification() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('logo');

    //Initialization Settings for iOS
    const IOSInitializationSettings initializationSettingsIOS =
        IOSInitializationSettings(
      requestSoundPermission: false,
      requestBadgePermission: false,
      requestAlertPermission: false,
    );

    //InitializationSettings for initializing settings for both platforms (Android & iOS)
    const InitializationSettings initializationSettings =
        InitializationSettings(
            android: initializationSettingsAndroid,
            iOS: initializationSettingsIOS);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);
  }

  static Future<dynamic> onSelectNotification(payload) async {}

  static Future<void> firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    return Future<void>.value();
  }

  static showNotification(RemoteMessage message) async {
    AndroidNotificationDetails androidNotificationDetails =
        const AndroidNotificationDetails(
          'channel ID', 'channel name',
          importance: Importance.max,
          playSound: true,
          priority: Priority.max,
          fullScreenIntent: true,
          icon: "logo",
    );

    IOSNotificationDetails iosNotificationDetails =
        const IOSNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
            badgeNumber: 1);

    var platform = NotificationDetails(
        android: androidNotificationDetails, iOS: iosNotificationDetails);

    await flutterLocalNotificationsPlugin.show(
      0,
      message.notification!.title!,
      message.notification!.body!,
      platform,
      payload: message.data["type"],
    );
  }
}
