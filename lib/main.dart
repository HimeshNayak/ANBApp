// @dart=2.9

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'models/user.dart';
import 'screens/login.dart';
import 'screens/homeAdmin.dart';
import 'screens/homeUser.dart';
import 'screens/errorPage.dart';
import 'services/auth.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('Handling a background message ${message.messageId}');
}

const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel', // id
  'High Importance Notifications', // title
  'This channel is used for important notifications.', // description
  importance: Importance.high,
);

/// Initialize the [FlutterLocalNotificationsPlugin] package.
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  await Firebase.initializeApp();

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  runApp(
    RootPage(
      auth: new Auth(),
      user: new UserData(),
    ),
  );
}

class RootPage extends StatefulWidget {
  final Auth auth;
  final UserData user;
  RootPage({@required this.auth, @required this.user});
  @override
  _RootPageState createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  @override
  void initState() {
    super.initState();
    FirebaseMessaging.onMessage.listen(
      (RemoteMessage message) {
        RemoteNotification notification = message.notification;
        AndroidNotification android = message.notification?.android;
        if (notification != null && android != null) {
          flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                channel.description,
                icon: 'launch_background',
              ),
            ),
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SWINGER IOT',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        primaryColor: Colors.greenAccent,
        scaffoldBackgroundColor: Colors.white,
      ),
      debugShowCheckedModeBanner: false,
      home: FutureBuilder<String>(
        future: widget.user.getType(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data == 'USER') {
              return HomeUser(auth: widget.auth, user: widget.user);
            } else if (snapshot.data == 'ADMIN') {
              return HomeAdmin(auth: widget.auth, user: widget.user);
            } else if (snapshot.data == 'LOGIN') {
              return LoginPage(auth: widget.auth, userData: widget.user);
            } else {
              return ErrorPage(
                message:
                    'Some problem accessing the user. Close app and try again!',
              );
            }
          }
          return LoginPage(auth: widget.auth, userData: widget.user);
        },
      ),
    );
  }
}
