import 'package:flutter/material.dart';

Widget locationMessage(
    BuildContext context, Map<dynamic, dynamic> map, bool myMessage) {
  DateTime dateTime = map['timestamp'].toDate();
  return Row(
    children: [
      Visibility(
        visible: myMessage,
        child: SizedBox(width: MediaQuery.of(context).size.width * 0.20),
      ),
      Container(
        width: MediaQuery.of(context).size.width * 0.74,
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
      ),
      Visibility(
        visible: !myMessage,
        child: SizedBox(width: MediaQuery.of(context).size.width * 0.20),
      ),
    ],
  );
}
