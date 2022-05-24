import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationsService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static void initialize() {
    final InitializationSettings initializationSettings =
        InitializationSettings(
            android: AndroidInitializationSettings(""),
            iOS: IOSInitializationSettings(
                defaultPresentAlert: true,
                defaultPresentBadge: true,
                defaultPresentSound: true,
                requestAlertPermission: true,
                requestBadgePermission: true,
                requestSoundPermission: true));
    _notificationsPlugin.initialize(initializationSettings);
  }

  static void display(RemoteMessage msg) async {
    try {
      final id = DateTime.now().microsecondsSinceEpoch ~/ 1000;
      NotificationDetails notificationDetails = NotificationDetails(
        android: AndroidNotificationDetails(
          'default_notification_channel_id',
          'default_notification_channel',
          // 'This is let\'s talk channel',
          importance: Importance.max,
          priority: Priority.high,
          ticker: 'ticker',
        ),
        iOS: IOSNotificationDetails(),
      );
      await _notificationsPlugin.show(id, msg.notification!.title ?? '',
          msg.notification!.title ?? '', notificationDetails);
    } on Exception catch (e) {
      print(e);
    }
  }
}
