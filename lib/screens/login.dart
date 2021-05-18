import 'package:flutter/material.dart';

import '../models/user.dart';
import '../screens/errorPage.dart';
import '../services/auth.dart';
import '../services/root.dart';
import '../widgets/commonWidgets.dart';

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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              color: Colors.lightBlue,
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 20, vertical: 100),
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
            Positioned(
              top: 150,
              child: Container(
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.symmetric(horizontal: 40),
                child: Column(
                  children: [
                    Text(
                      'SWINGER LAB',
                      style:
                          TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextField(
                      controller: emailController,
                      decoration: InputDecoration(
                        hintText: 'Email',
                      ),
                    ),
                    TextField(
                      controller: passwordController,
                      decoration: InputDecoration(
                        hintText: 'Password',
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        backgroundColor: Colors.white,
                      ),
                      onPressed: () {
                        setState(
                          () {
                            isLoading = true;
                          },
                        );
                        String email = emailController.text.toString();
                        String password = passwordController.text.toString();
                        if (email.isNotEmpty && password.isNotEmpty) {
                          widget.auth
                              .signInWithEmailAndPassword(email, password)
                              .then(
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
                                              user: widget.userData),
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
                                print(
                                    'there is no user present with this email password');
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
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width - 130,
                        child: Text(
                          'Sign In as Admin',
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        backgroundColor: Colors.white,
                      ),
                      onPressed: () {
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
                                      message:
                                          'Could not Sign in. Please Try Again!',
                                    ),
                                  ),
                                  (route) => false);
                            }
                          },
                        );
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width - 120,
                        child: Text(
                          'Sign in as a user',
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
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
