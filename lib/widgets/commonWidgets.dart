import 'package:flutter/material.dart';

Widget buildingScreenWidget(BuildContext context, Color bgColor, Color color) {
  return Container(
    width: MediaQuery.of(context).size.width,
    height: MediaQuery.of(context).size.height,
    color: bgColor,
    child: Center(
      child: CircularProgressIndicator(
        color: color,
      ),
    ),
  );
}
