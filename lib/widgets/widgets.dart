import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:swinger_iot/style/fonts.dart';

Widget textFieldContainer({required Widget child}) {
  return Container(
    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
    decoration: BoxDecoration(
      color: Colors.greenAccent.withOpacity(0.3),
      borderRadius: BorderRadius.all(
        Radius.circular(30),
      ),
    ),
    child: child,
  );
}

Widget button1(String hint, Function next, Color color, context) {
  return TextButton(
    child: Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.all(
          Radius.circular(30),
        ),
      ),
      child: Center(
        child: Text(
          '$hint',
          style: heading2Wl,
        ),
      ),
    ),
    onPressed: () {
      next();
    },
  );
}

Widget sosButton(String hint, Function next, Color color, context) {
  return TextButton(
    child: Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.3,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
      ),
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
    ),
    onPressed: () {
      next();
    },
  );
}

Widget loginBg({required BuildContext context, required Widget child}) {
  return Container(
    margin: EdgeInsets.only(top: 20),
    padding: EdgeInsets.only(top: 20),
    decoration: BoxDecoration(
      boxShadow: [
        BoxShadow(
          offset: Offset(-5, 10),
          color: Colors.greenAccent,
          blurRadius: 10,
        )
      ],
      color: Colors.white,
      borderRadius: BorderRadius.all(
        Radius.circular(30),
      ),
    ),
    child: child,
  );
}

class ButtonLoginPage extends StatelessWidget {
  final String text;
  final Function function;
  ButtonLoginPage({required this.text, required this.function});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 360.0,
      height: 70.0,
      margin: EdgeInsets.symmetric(vertical: 10),
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
          color: Color.fromARGB(255, 100, 177, 116)),
      child: GestureDetector(
        onTap: () {
          function();
        },
        child: Text(
          text,
          overflow: TextOverflow.visible,
          textAlign: TextAlign.center,
          style: TextStyle(
            height: 1.171875,
            fontSize: 20.0,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w700,
            color: Color.fromARGB(255, 255, 255, 255),
            /* letterSpacing: 0.0, */
          ),
        ),
      ),
    );
  }
}
