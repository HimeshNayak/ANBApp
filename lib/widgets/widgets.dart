import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:swinger_iot/style/fonts.dart';

Widget textfield1(controller, String hint) {
  return Container(
    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
    decoration: BoxDecoration(
      color: Colors.greenAccent.withOpacity(0.3),
      borderRadius: BorderRadius.all(
        Radius.circular(30),
      ),
    ),
    child: TextField(
      controller: controller,
      decoration: InputDecoration(
        border: InputBorder.none,
        hintText: '$hint',
      ),
    ),
  );
}

Widget button1(String hint, Function next, Color color, context) {
  return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.all(
          Radius.circular(30),
        ),
      ),
      child: InkWell(
        child: Center(
            child: Text(
          '$hint',
          style: heading2Wl,
        )),
        onTap: () {
          next();
        },
      ));
}

Widget sosButton(String hint, Function next, Color color, context) {
  return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.3,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
      ),
      child: InkWell(
        child: Container(
          padding: EdgeInsets.all(20),
          child: Center(
            child: Text('$hint',
                style: GoogleFonts.comfortaa(
                    textStyle: TextStyle(
                        fontSize: 40,
                        color: Colors.white,
                        fontWeight: FontWeight.bold))),
          ),
        ),
        onTap: () {
          next();
        },
      ));
}
