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

Widget longButton(
    {required BuildContext context,
    required String text,
    required Function function}) {
  return OutlinedButton(
    onPressed: () {
      function();
    },
    child: Container(
      width: MediaQuery.of(context).size.width,
      child: Text(
        text,
        textAlign: TextAlign.center,
      ),
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

Widget overlayProgress({required BuildContext context, required bool visible}) {
  return Visibility(
    visible: visible,
    child: Container(
      color: Colors.white70,
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Center(child: CircularProgressIndicator()),
    ),
  );
}
