import 'package:flutter/material.dart';

import 'services/root.dart';
import 'services/auth.dart';

void main() {
  runApp(RootPage(auth: new Auth()));
}
