import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'models/user.dart';
import 'services/root.dart';
import 'services/auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    RootPage(
      auth: new Auth(),
      user: new UserData(),
    ),
  );
}
