import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tcc_hugo/routes.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz;

class CustomNotification {
  final int id;
  final String? title;
  final String? body;
  final String? payload;

  CustomNotification(
      {required this.id,
      required this.title,
      required this.body,
      required this.payload});
}

class NotificationService {

  late FlutterLocalNotificationsPlugin localNotificationsPlugin;
  late AndroidNotificationDetails androidDetails;

  NotificationService() {
    localNotificationsPlugin = FlutterLocalNotificationsPlugin();
    _setupNotifications();
  }

  _setupNotifications() async {
    await _setupTimezone();
    await initializeNotifications();
  }

  Future<void> _setupTimezone() async {
    tz.initializeTimeZones();
    final String? timeZoneName = await FlutterNativeTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timeZoneName!));
  }

  initializeNotifications() async {
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    await localNotificationsPlugin.initialize(
        const InitializationSettings(android: android),
        onSelectNotification: _onSelectNotification);
  }

  _onSelectNotification(String? payload) {
    if (payload != null && payload.isNotEmpty) {
      Navigator.of(Routes.navigatorKey!.currentContext!)
          .pushNamed(payload);
    }
  }

  showLocalNotification(CustomNotification notification) {
    print("pay"+notification.payload!);
   
    androidDetails = const AndroidNotificationDetails(
        'lembretes_notifications_x', 'Lembretes',
        channelDescription: 'Este canal é para lembretes',
        importance: Importance.max,
        priority: Priority.max,
        enableVibration: true);

    localNotificationsPlugin.show(notification.id, notification.title,
        notification.body, NotificationDetails(android: androidDetails),
        payload: notification.payload);
  }

  showNotificationScheduled(CustomNotification notification, DateTime data) {
    
    

    androidDetails = const AndroidNotificationDetails(
        'lembretes_notifications_x', 'Lembretes',
        channelDescription: 'Este canal é para lembretes',
        importance: Importance.max,
        priority: Priority.max,
        enableVibration: true);

    localNotificationsPlugin.zonedSchedule(
        
        notification.id,
        notification.title,
        notification.body,
        tz.TZDateTime.from(data, tz.local),
        NotificationDetails(android: androidDetails),
        payload: notification.payload,
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime);
      
  }

  void cancelScheduledNotification(int notificationId) async {
    
      await localNotificationsPlugin.cancel(notificationId);
  }

  checkForNotifications() async {
    final details =
        await localNotificationsPlugin.getNotificationAppLaunchDetails();
    if (details != null && details.didNotificationLaunchApp) {
      _onSelectNotification(details.payload);
    }
  }

  cancelAll() async {
     
    await localNotificationsPlugin.cancelAll();
  }
}
