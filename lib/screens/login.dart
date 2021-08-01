import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';

import '../models/user.dart';
import '../screens/errorPage.dart';
import '../services/auth.dart';
import '../style/fonts.dart';
import '../widgets/commonWidgets.dart';
import '../widgets/widgets.dart';

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
      backgroundColor: Color(0xFF9BE5AA),
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            Container(
              width: size.width,
              height: size.height,
              padding: EdgeInsets.fromLTRB(20, 60, 20, 20),
              child: Column(
                children: <Widget>[
                  Text(
                    'AtmaNirbhar',
                    overflow: TextOverflow.visible,
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      height: 1.171875,
                      fontSize: 35.0,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w700,
                      color: Color.fromARGB(255, 255, 255, 255),
                      /* letterSpacing: 0.0, */
                    ),
                  ),
                  (pageIndex == 0)
                      ? Container(
                          margin: EdgeInsets.symmetric(vertical: 30),
                          // width: 356.0,
                          // height: 237.0,
                          child: Column(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.zero,
                                child: Image.asset(
                                  'assets/images/seniors.png',
                                  color: null,
                                  fit: BoxFit.cover,
                                  // width: 356.0,
                                  // height: 237.0,
                                  colorBlendMode: BlendMode.dstATop,
                                ),
                              ),
                              ButtonLoginPage(
                                text: 'Login as a User',
                                function: onSignInGoogleUser,
                              ),
                              ButtonLoginPage(
                                text: 'Login as a Doctor',
                                function: () {
                                  setState(() {
                                    pageIndex = 1;
                                  });
                                },
                              ),
                              ButtonLoginPage(
                                text: 'Register as a Doctor',
                                function: () {
                                  setState(() {
                                    pageIndex = 2;
                                  });
                                },
                              ),
                            ],
                          ),
                        )
                      : (pageIndex == 1)
                          ? loginBg(
                              context: context,
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 10),
                                    child:
                                        Text('Login as Admin', style: body2Bl),
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
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
                ],
              ),
            ),
            overlayProgress(context: context, visible: isLoading),
          ],
        ),
      ),
    );
  }
}
