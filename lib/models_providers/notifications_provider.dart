import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationsProvider with ChangeNotifier {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  bool _showNotification;
  bool get showNotificationss => _showNotification;

  Future<void> scheduleFloatNotification(
      {@required String title,
      @required String words,
      @required int id,
      @required DateTime dueDate}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool showNotifications = prefs.getBool('showNotifications') ?? true;

    var timeDifference = (dueDate.millisecondsSinceEpoch -
            DateTime.now().millisecondsSinceEpoch) /
        1000 /
        60 /
        60;

    dueDate.add(Duration(hours: 8));

    var scheduledNotificationDateTime1 =
        timeDifference >= 1 ? dueDate.subtract(Duration(hours: 1)) : null;
    var scheduledNotificationDateTime2 =
        timeDifference >= 24 ? dueDate.subtract(Duration(hours: 24)) : null;
    var scheduledNotificationDateTime3 =
        timeDifference >= 72 ? dueDate.subtract(Duration(hours: 72)) : null;
    var scheduledNotificationDateTime4 =
        timeDifference >= 168 ? dueDate.subtract(Duration(hours: 168)) : null;

    var vibrationPattern = Int64List(4);
    vibrationPattern[0] = 0;
    vibrationPattern[1] = 1000;
    vibrationPattern[2] = 5000;
    vibrationPattern[3] = 2000;

    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'your other channel id',
      'your other channel name',
      'your other channel description',
      icon: 'ic_launcher',
      // sound: AndroidNotificationSound.sound,
      // largeIcon: 'ic_launcher',
      //largeIconBitmapSource: BitmapSource.Drawable,
      vibrationPattern: vibrationPattern,
      enableVibration: true,
    );
    var iOSPlatformChannelSpecifics =
        IOSNotificationDetails(sound: "slow_spring_board.mp3");
    NotificationDetails platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics);

    if (scheduledNotificationDateTime1 != null && showNotifications) {
      await flutterLocalNotificationsPlugin.schedule(
          id,
          'You can do this!',
          'You have 1 hour left - $title',
          scheduledNotificationDateTime1,
          platformChannelSpecifics);
      // await flutterLocalNotificationsPlugin.schedule(
      //     id,
      //     'You can do this!',
      //     'You have 1 hour left - $title',
      //     scheduledNotificationDateTime1,
      //     platformChannelSpecifics);
    }

    if (scheduledNotificationDateTime2 != null && showNotifications) {
      await flutterLocalNotificationsPlugin.schedule(
          id,
          'You can do this!',
          'You have 1 hour left - $title',
          scheduledNotificationDateTime2,
          platformChannelSpecifics);
      // await flutterLocalNotificationsPlugin.schedule(
      //     id + 1,
      //     'You can do this!',
      //     'You have 1 day left - $title',
      //     scheduledNotificationDateTime2,
      //     platformChannelSpecifics);
    }

    if (scheduledNotificationDateTime3 != null && showNotifications) {
      await flutterLocalNotificationsPlugin.schedule(
          id,
          'You can do this!',
          'You have 1 hour left - $title',
          scheduledNotificationDateTime3,
          platformChannelSpecifics);
      // await flutterLocalNotificationsPlugin.schedule(
      //     id + 2,
      //     'You can do this!',
      //     'You have 3 days left - $title',
      //     scheduledNotificationDateTime3,
      //     platformChannelSpecifics);
    }

    if (scheduledNotificationDateTime4 != null && showNotifications) {
      await flutterLocalNotificationsPlugin.schedule(
          id,
          'You can do this!',
          'You have 1 hour left - $title',
          scheduledNotificationDateTime4,
          platformChannelSpecifics);
      // await flutterLocalNotificationsPlugin.schedule(
      //     id + 3,
      //     'You can do this!',
      //     'You have 7 days left - $title',
      //     scheduledNotificationDateTime4,
      //     platformChannelSpecifics);
    }
  }

  Future<void> cancelFLoatNotificationById({int id}) async {
    flutterLocalNotificationsPlugin.cancel(id);
    flutterLocalNotificationsPlugin.cancel(id + 1);
    flutterLocalNotificationsPlugin.cancel(id + 2);
    flutterLocalNotificationsPlugin.cancel(id + 3);
  }

  Future<void> cancleAllNotifications() async {
    flutterLocalNotificationsPlugin.cancelAll().then((onValue) {
      print('Cancleed');
    });
  }
}
