import 'package:flutter/material.dart';

import 'models/user.dart';
import 'services/root.dart';
import 'services/auth.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(RootPage(auth: new Auth(), user: new User()));
}
