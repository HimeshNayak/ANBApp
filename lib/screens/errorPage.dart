import 'package:flutter/material.dart';

class ErrorPage extends StatelessWidget {
  final String message;

  ErrorPage({required this.message});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.network(
                'https://ipsrsolutions.com/uploads/2020/04/262-2622379_chow-big-data-analytics-png.jpg',
              ),
              Padding(
                padding: EdgeInsets.all(20),
                child: Text(
                  message,
                  style: TextStyle(fontSize: 15),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
