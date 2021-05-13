import 'package:flutter/material.dart';

import '../screens/homeAdmin.dart';
import '../screens/homeUser.dart';
import '../widgets/commonWidgets.dart';
import 'auth.dart';

class RootPage extends StatelessWidget {
  final Auth auth;
  RootPage({required this.auth});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SWINGER IOT',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: FutureBuilder<bool>(
          future: auth.getUser(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data == true) {
                return HomeUser();
              } else {
                return HomeAdmin();
              }
            }
            return buildingScreenWidget(context, Colors.white, Colors.blue);
          }),
    );
  }
}
