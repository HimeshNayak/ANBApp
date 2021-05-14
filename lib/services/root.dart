import 'package:flutter/material.dart';

import '../models/user.dart';
import '../screens/login.dart';
import '../screens/homeAdmin.dart';
import '../screens/homeUser.dart';
import '../screens/errorPage.dart';
import '../widgets/commonWidgets.dart';
import 'auth.dart';

class RootPage extends StatelessWidget {
  final Auth auth;
  final UserData user;
  RootPage({required this.auth, required this.user});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SWINGER IOT',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: FutureBuilder<String?>(
          future: user.getType(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data == 'USER') {
                return HomeUser(auth: auth, user: user);
              } else if (snapshot.data == 'ADMIN') {
                return HomeAdmin(auth: auth, user: user);
              } else if (snapshot.data == 'LOGIN') {
                return LoginPage(auth: auth, userData: user);
              } else {
                return ErrorPage(
                    message:
                        'Some problem accessing the user. Close app and try again!');
              }
            }
            return buildingScreenWidget(context, Colors.white);
          }),
    );
  }
}
