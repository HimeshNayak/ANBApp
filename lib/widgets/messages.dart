import 'package:flutter/material.dart';

import '../screens/mapScreen.dart';

Widget spacingWidget(
    {required BuildContext context,
    required bool myMessage,
    required Widget widget}) {
  return Container(
    margin: EdgeInsets.symmetric(vertical: 5),
    child: Row(
      children: [
        Visibility(
          visible: myMessage,
          child: SizedBox(width: MediaQuery.of(context).size.width * 0.20),
        ),
        Container(
          width: MediaQuery.of(context).size.width * 0.74,
          padding: EdgeInsets.all(10),
          child: widget,
          decoration: BoxDecoration(
            color: Colors.white70,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.blueAccent, width: 1),
          ),
        ),
        Visibility(
          visible: !myMessage,
          child: SizedBox(width: MediaQuery.of(context).size.width * 0.20),
        ),
      ],
    ),
  );
}

Widget locationMessage(
    BuildContext context, Map<dynamic, dynamic> map, bool myMessage) {
  DateTime dateTime = map['timestamp'].toDate();
  print(map['latitude']);
  print(map['longitude']);
  return spacingWidget(
    context: context,
    myMessage: myMessage,
    widget: Column(
      children: <Widget>[
        OutlinedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MapScreen(
                  latitude: map['latitude'],
                  longitude: map['longitude'],
                ),
              ),
            );
          },
          child: Text('Show Directions'),
        ),
        Text(
          '${dateTime.hour}:${dateTime.minute}',
        ),
      ],
    ),
  );
}

Widget textMessage(
    BuildContext context, Map<dynamic, dynamic> map, bool myMessage) {
  DateTime dateTime = map['timestamp'].toDate();
  return spacingWidget(
    context: context,
    myMessage: myMessage,
    widget: Container(
      child: Column(
        children: <Widget>[
          Text(map['text']),
          Text(
            '${dateTime.hour}:${dateTime.minute}',
          )
        ],
      ),
    ),
  );
}
