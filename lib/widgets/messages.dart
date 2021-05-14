import 'package:flutter/material.dart';

Widget locationMessage(Map<dynamic, dynamic> map) {
  DateTime dateTime = map['timestamp'].toDate();
  return Container(
    padding: EdgeInsets.all(10),
    child: Column(
      children: <Widget>[
        Text('Latitude : ${map['latitude']}'),
        Text('Longitude: ${map['longitude']}'),
        Text('${dateTime.hour}:${dateTime.minute}')
      ],
    ),
    decoration: BoxDecoration(
      color: Colors.redAccent,
      borderRadius: BorderRadius.circular(20),
    ),
  );
}
