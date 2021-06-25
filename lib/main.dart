// @dart=2.9

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:swinger_iot/widgets/commonWidgets.dart';

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
              return FutureBuilder<DocumentSnapshot>(
                future: FirebaseFirestore.instance
                    .collection('users')
                    .doc(widget.user.uid)
                    .get(),
                builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                  if (snapshot.hasData) {
                    Map<String, dynamic> userMap =
                        snapshot.data?.data() as Map<String, dynamic>;
                    String doctorUid = userMap['doctorUid'] ?? '';
                    UserData userData = UserData.setFields(userMap);
                    if (doctorUid.isNotEmpty)
                      return FutureBuilder(
                        future: FirebaseFirestore.instance
                            .collection('admins')
                            .doc(doctorUid)
                            .get(),
                        builder:
                            (context, AsyncSnapshot<DocumentSnapshot> snap) {
                          if (snap.hasData) {
                            Map<String, dynamic> doctorMap =
                                snap.data?.data() as Map<String, dynamic>;
                            UserData doctorData =
                                new UserData.setFields(doctorMap);
                            return HomeUser(
                              auth: widget.auth,
                              user: userData,
                              doctor: doctorData,
                            );
                          }
                          return buildingScreenWidget(context, Colors.white);
                        },
                      );
                    else {
                      UserData docData = UserData.setFields({});
                      return HomeUser(
                        auth: widget.auth,
                        user: userData,
                        doctor: docData,
                      );
                    }
                  }
                  return buildingScreenWidget(context, Colors.white);
                },
              );
            } else if (snapshot.data == 'ADMIN') {
              return FutureBuilder(
                future: FirebaseFirestore.instance
                    .collection('admins')
                    .doc(widget.user.uid)
                    .get(),
                builder: (context, AsyncSnapshot<DocumentSnapshot> snap) {
                  if (snap.hasData) {
                    Map<String, dynamic> userMap =
                        snap.data?.data() as Map<String, dynamic>;
                    UserData userData = UserData.setFields(userMap);
                    return HomeAdmin(auth: widget.auth, user: userData);
                  }
                  return buildingScreenWidget(context, Colors.white);
                },
              );
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
