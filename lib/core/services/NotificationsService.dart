import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;

class NotificationsService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static void initialize() {
    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: AndroidInitializationSettings("@mipmap/ic_launcher"),
    );
    _notificationsPlugin.initialize(initializationSettings);
  }

  static void display(RemoteMessage msg) async {
    try {
      final id = DateTime.now().microsecondsSinceEpoch ~/ 1000;
      NotificationDetails notificationDetails = NotificationDetails(
        android: AndroidNotificationDetails(
          'mychanel',
          'My channel',
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

  void sendNotification(String title, String token) async {
    //token bjiba men firebase, bjib lfirebaseid for a user, w i get token field men table lusers
    var data = {
      'click_action': 'FLUTTER_NOTIFICATION_CLICK',
      'id': '1',
      'status': 'done',
      'message': title
    };
    try {
      http.Response resp =
          await http.post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
              headers: <String, String>{
                'Content-Type': 'application/json',
                'Authorization':
                    'key=' + const String.fromEnvironment("FIREBASE_API_KEY")
              },
              body: jsonEncode(<String, dynamic>{
                'notification': <String, dynamic>{
                  'body': title,
                  'title': 'You got a new notification',
                  'sound': 'default',
                  'click_action': 'FLUTTER_NOTIFICATION_CLICK'
                },
                'priority': 'high',
                'data': data,
                'to': token
              }));
      if (resp.statusCode == 200) {
        print('Notification sent successfully');
      } else {
        print('Notification failed to send');
      }
    } catch (e) {
      print('ERROR -> $e');
    }
  }


}
