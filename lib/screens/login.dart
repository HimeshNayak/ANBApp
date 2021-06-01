import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:swinger_iot/style/fonts.dart';
import 'package:swinger_iot/widgets/widgets.dart';

import '../models/user.dart';
import '../screens/errorPage.dart';
import '../services/auth.dart';
import 'package:swinger_iot/widgets/commonWidgets.dart';

// ignore: import_of_legacy_library_into_null_safe
import '../main.dart';

class LoginPage extends StatefulWidget {
  final Auth auth;
  final UserData userData;
  LoginPage({required this.auth, required this.userData});
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isLoading = false;
  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  TextEditingController emailControllerRegister = new TextEditingController();
  TextEditingController passwordControllerRegister =
      new TextEditingController();
  int pageIndex = 0;

  onLogin() {
    setState(
      () {
        isLoading = true;
      },
    );
    String email = emailController.value.text.toString();
    String password = passwordController.value.text.toString();
    if (email.isNotEmpty && password.isNotEmpty) {
      widget.auth.signInWithEmailAndPassword(email, password).then(
        (value) {
          if (value != null) {
            widget.userData.getUserDetails().whenComplete(
              () {
                setState(
                  () {
                    isLoading = false;
                  },
                );
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        RootPage(auth: widget.auth, user: widget.userData),
                  ),
                  (route) => false,
                );
              },
            );
          } else {
            setState(
              () {
                isLoading = false;
              },
            );
            print('there is no user present with this email password');
          }
        },
      );
    } else {
      setState(
        () {
          isLoading = false;
          print('Enter email and password!');
        },
      );
    }
  }

  onRegister() {
    setState(
      () {
        isLoading = true;
      },
    );
    String email = emailControllerRegister.text.toString();
    String password = passwordControllerRegister.text.toString();
    if (email.isNotEmpty && password.isNotEmpty) {
      widget.auth.createUserEmailPassword(email, password).then(
        (value) {
          if (value != null) {
            widget.userData.getUserDetails().whenComplete(
              () {
                setState(
                  () {
                    isLoading = false;
                  },
                );
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        RootPage(auth: widget.auth, user: widget.userData),
                  ),
                  (route) => false,
                );
              },
            );
          } else {
            setState(
              () {
                isLoading = false;
              },
            );
            print('there is no user present with this email password');
          }
        },
      );
    } else {
      setState(
        () {
          isLoading = false;
          print('Enter email and password!');
        },
      );
    }
  }

  onSignInGoogleUser() {
    setState(
      () {
        isLoading = true;
      },
    );
    widget.auth.signInWithGoogle().then(
      (value) {
        if (value != null) {
          widget.userData.getUserDetails().whenComplete(
            () {
              setState(
                () {
                  isLoading = false;
                },
              );
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => RootPage(
                    auth: widget.auth,
                    user: widget.userData,
                  ),
                ),
                (route) => false,
              );
            },
          );
        } else {
          setState(
            () {
              isLoading = false;
            },
          );
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => ErrorPage(
                message: 'Could not Sign in. Please Try Again!',
              ),
            ),
            (route) => false,
          );
        }
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _controller = PageController();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  late PageController _controller;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            Container(
              width: size.width,
              height: size.height,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: <Color>[
                    Colors.white,
                    Colors.greenAccent.shade200,
                  ],
                  tileMode: TileMode.repeated,
                ),
              ),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 50),
                child: Text(
                  'SWINGER LAB',
                  style: heading1Bl,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Container(
                width: size.width,
                height:
                    (pageIndex == 0) ? size.height * 0.5 : size.height * 0.7,
                child: (pageIndex == 0)
                    ? loginBg(
                        context: context,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 10),
                              child: button1(
                                  'Login as User',
                                  onSignInGoogleUser,
                                  Colors.greenAccent,
                                  context),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 10),
                              child: button1('Login as Admin', () {
                                setState(() {
                                  pageIndex = 1;
                                });
                              }, Colors.greenAccent, context),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 10),
                              child: button1('Register as Admin', () {
                                setState(() {
                                  pageIndex = 2;
                                });
                              }, Colors.greenAccent, context),
                            ),
                          ],
                        ),
                      )
                    : (pageIndex == 1)
                        ? loginBg(
                            context: context,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 10),
                                  child: Text('Login as Admin', style: body2Bl),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 10),
                                  child: textFieldContainer(
                                    child: TextField(
                                      controller: emailController,
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: 'EMAIL',
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 10),
                                  child: textFieldContainer(
                                    child: TextField(
                                      controller: passwordController,
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: 'PASSWORD',
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 10),
                                  child: button1('Login', onLogin,
                                      Colors.blueAccent, context),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 10),
                                  child: button1('Back', () {
                                    setState(() {
                                      pageIndex = 0;
                                    });
                                  }, Colors.greenAccent, context),
                                ),
                              ],
                            ),
                          )
                        : loginBg(
                            context: context,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 10),
                                  child: Text('Register for Admin',
                                      style: body2Bl),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 10),
                                  child: textFieldContainer(
                                    child: TextField(
                                      controller: emailControllerRegister,
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: 'EMAIL',
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 10),
                                  child: textFieldContainer(
                                    child: TextField(
                                      controller: passwordControllerRegister,
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: 'PASSWORD',
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 10),
                                  child: button1('Register', onRegister,
                                      Colors.blueAccent, context),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 10),
                                  child: button1('Back', () {
                                    setState(() {
                                      pageIndex = 0;
                                    });
                                  }, Colors.greenAccent, context),
                                ),
                              ],
                            ),
                          ),
              ),
            ),
            overlayProgress(context: context, visible: isLoading),
          ],
        ),
      ),
    );
  }
}
