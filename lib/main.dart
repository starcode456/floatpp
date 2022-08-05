import 'package:firebase_core/firebase_core.dart';
import 'package:float/pages/essaytennis.dart';
import 'package:float/pages/essaytennisinfo.dart';

import 'package:float/pages/splash_screen_page.dart';
import 'package:flutter/material.dart';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';

import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';

import 'models_providers/auth_provider.dart';
import 'models_providers/notifications_provider.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
final BehaviorSubject<ReceivedNotification> didReceiveLocalNotificationSubject =
    BehaviorSubject<ReceivedNotification>();
final BehaviorSubject<String> selectNotificationSubject =
    BehaviorSubject<String>();

class ReceivedNotification {
  final int id;
  final String title;
  final String body;
  final String payload;
  ReceivedNotification(
      {@required this.id,
      @required this.title,
      @required this.body,
      @required this.payload});
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  var initializationSettingsAndroid = AndroidInitializationSettings('app_icon');
  var initializationSettingsIOS = IOSInitializationSettings();
  var initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
  await flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onSelectNotification: (String payload) async {
    if (payload != null) {}
    selectNotificationSubject.add(payload);
  });
  await Firebase.initializeApp();
  runApp(
    MyApp(),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => NotificationsProvider()),
        ChangeNotifierProvider(create: (context) => AuthProvider()),
      ],
      child: GetMaterialApp(
        title: 'float',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(primarySwatch: Colors.cyan),
        home: SplashScreenPage(),
        routes: {
          EssayTennisScreen.routeName: (context) => EssayTennisScreen(),
          EssayTennisInfo.routeName: (context) => EssayTennisInfo(),
          // SearchScreen.routeName:(context) => SearchScreen(),
        },
      ),
    );
  }
}
