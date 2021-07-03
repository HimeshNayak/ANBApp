import 'package:flutter/material.dart';

import '../models/user.dart';
import '../services/auth.dart';
import '../widgets/editProfile.dart';

class RegisterScreen extends StatefulWidget {
  final Auth auth;
  final UserData user;

  RegisterScreen({required this.auth, required this.user});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: EditProfile(user: widget.user),
    );
  }
}
