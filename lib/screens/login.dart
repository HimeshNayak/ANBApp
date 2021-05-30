import 'package:flutter/material.dart';
import 'package:swinger_iot/style/fonts.dart';
import 'package:swinger_iot/widgets/widgets.dart';

import '../models/user.dart';
import '../screens/errorPage.dart';
import '../screens/register.dart';
import '../services/auth.dart';
import '../widgets/commonWidgets.dart';

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
  int pageIndex = 0;

  onRegister() {
    setState(
      () {
        isLoading = true;
      },
    );
    String email = emailController.text.toString();
    String password = passwordController.text.toString();
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
                    (route) => false);
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
                  (route) => false);
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
              (route) => false);
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
                  Colors.greenAccent,
                  Colors.blueAccent,
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
            alignment: Alignment.bottomCenter,
            child: Container(
              width: size.width,
              height: size.height * 0.5,
              child: PageView(
                  controller: _controller,
                  onPageChanged: (int page) {
                    setState(() {
                      pageIndex = page;
                    });
                  },
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.fromLTRB(20, 0, 20, 20),
                      padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
                      decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              offset: Offset(-5, 10),
                              color: Colors.blueAccent,
                              blurRadius: 10,
                            )
                          ],
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(30))),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 10),
                              child: Text('Login with Google', style: body2Bl)),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 10),
                            child: button1('Tap to Login', onSignInGoogleUser,
                                Colors.greenAccent, context),
                          ),
                          Spacer(),
                          Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 10),
                              child: Text('Swipe to Login as Admin',
                                  style: body2Bl)),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(20, 0, 20, 20),
                      padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
                      decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              offset: Offset(-5, 10),
                              color: Colors.blueAccent,
                              blurRadius: 10,
                            )
                          ],
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(30))),
                      child: Column(
                        children: <Widget>[
                          Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 10),
                              child: Text('Login as Admin', style: body2Bl)),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 10),
                            child: textfield1(emailController, 'EMAIL'),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 10),
                            child: textfield1(passwordController, 'PASSWORD'),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 10),
                            child: button1('Register', onRegister,
                                Colors.blueAccent, context),
                          ),
                        ],
                      ),
                    ),
                  ]),
            ),
          )
        ],
      )),
    );
  }
}

// Stack(
// children: [
// Container(
// width: MediaQuery.of(context).size.width,
// height: MediaQuery.of(context).size.height,
// color: Colors.lightBlue,
// child: Container(
// margin: EdgeInsets.symmetric(horizontal: 20, vertical: 100),
// padding: EdgeInsets.all(20),
// decoration: BoxDecoration(
// color: Colors.white,
// borderRadius: BorderRadius.circular(20),
// ),
// ),
// ),
// Positioned(
// top: 150,
// child: Container(
// width: MediaQuery.of(context).size.width,
// padding: EdgeInsets.symmetric(horizontal: 40),
// child: Column(
// children: [
// Text(
// 'SWINGER LAB',
// style:
// TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
// ),
// SizedBox(
// height: 20,
// ),
// TextField(
// controller: emailController,
// decoration: InputDecoration(
// hintText: 'Email',
// ),
// ),
// TextField(
// controller: passwordController,
// decoration: InputDecoration(
// hintText: 'Password',
// ),
// ),
// SizedBox(
// height: 10,
// ),
// OutlinedButton(
// style: OutlinedButton.styleFrom(
// backgroundColor: Colors.white,
// ),
// onPressed: () {
// setState(
// () {
// isLoading = true;
// },
// );
// String email = emailController.text.toString();
// String password = passwordController.text.toString();
// if (email.isNotEmpty && password.isNotEmpty) {
// widget.auth
//     .signInWithEmailAndPassword(email, password)
//     .then(
// (value) {
// if (value != null) {
// widget.userData.getUserDetails().whenComplete(
// () {
// setState(
// () {
// isLoading = false;
// },
// );
// Navigator.pushAndRemoveUntil(
// context,
// MaterialPageRoute(
// builder: (context) => RootPage(
// auth: widget.auth,
// user: widget.userData),
// ),
// (route) => false);
// },
// );
// } else {
// setState(
// () {
// isLoading = false;
// },
// );
// print(
// 'there is no user present with this email password');
// }
// },
// );
// } else {
// setState(
// () {
// isLoading = false;
// print('Enter email and password!');
// },
// );
// }
// },
// child: Container(
// width: MediaQuery.of(context).size.width - 130,
// child: Text(
// 'Sign In as Admin',
// textAlign: TextAlign.center,
// ),
// ),
// ),
// SizedBox(
// height: 10,
// ),
// OutlinedButton(
// style: OutlinedButton.styleFrom(
// backgroundColor: Colors.white,
// ),
// child: Text('Register as Admin'),
// onPressed: () {
// setState(
// () {
// isLoading = true;
// },
// );
// String email = emailController.text.toString();
// String password = passwordController.text.toString();
// if (email.isNotEmpty && password.isNotEmpty) {
// widget.auth
//     .createUserEmailPassword(email, password)
//     .then(
// (value) {
// if (value != null) {
// widget.userData.getUserDetails().whenComplete(
// () {
// setState(
// () {
// isLoading = false;
// },
// );
// Navigator.pushAndRemoveUntil(
// context,
// MaterialPageRoute(
// builder: (context) => RegisterScreen(
// auth: widget.auth,
// user: widget.userData),
// ),
// (route) => false);
// },
// );
// } else {
// setState(
// () {
// isLoading = false;
// },
// );
// print(
// 'some error occurred with this email password');
// }
// },
// );
// } else {
// setState(
// () {
// isLoading = false;
// print('Enter email and password!');
// },
// );
// }
// },
// ),
// SizedBox(
// height: 20,
// ),
// OutlinedButton(
// style: OutlinedButton.styleFrom(
// backgroundColor: Colors.white,
// ),
// onPressed: () {
// setState(
// () {
// isLoading = true;
// },
// );
// widget.auth.signInWithGoogle().then(
// (value) {
// if (value != null) {
// widget.userData.getUserDetails().whenComplete(
// () {
// setState(
// () {
// isLoading = false;
// },
// );
// Navigator.pushAndRemoveUntil(
// context,
// MaterialPageRoute(
// builder: (context) => RootPage(
// auth: widget.auth,
// user: widget.userData,
// ),
// ),
// (route) => false);
// },
// );
// } else {
// setState(
// () {
// isLoading = false;
// },
// );
// Navigator.pushAndRemoveUntil(
// context,
// MaterialPageRoute(
// builder: (context) => ErrorPage(
// message:
// 'Could not Sign in. Please Try Again!',
// ),
// ),
// (route) => false);
// }
// },
// );
// },
// child: Container(
// width: MediaQuery.of(context).size.width - 120,
// child: Text(
// 'Sign in as a user',
// textAlign: TextAlign.center,
// ),
// ),
// ),
// ],
// ),
// ),
// ),
// overlayProgress(context: context, visible: isLoading),
// ],
// ),
