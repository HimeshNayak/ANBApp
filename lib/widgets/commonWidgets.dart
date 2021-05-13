import 'package:flutter/material.dart';

Widget buildingScreenWidget(BuildContext context, Color bgColor) {
  return Container(
    width: MediaQuery.of(context).size.width,
    height: MediaQuery.of(context).size.height,
    color: bgColor,
    child: Center(
      child: CircularProgressIndicator(),
    ),
  );
}

Widget longButton(Color color, String text) {
  return Container(
    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 30),
    child: Text(
      text,
      style: TextStyle(color: Colors.white, fontSize: 20),
    ),
    decoration: BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(10),
    ),
  );
}

Widget bgWidget({required Widget child, required BuildContext context}) {
  return Container(
      margin: EdgeInsets.all(20),
      padding: EdgeInsets.all(20),
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white,
      ),
      child: child);
}
