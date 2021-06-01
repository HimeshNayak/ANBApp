import 'package:flutter/material.dart';

import '../screens/mapScreen.dart';

Widget spacingWidget(
    {required BuildContext context,
    required bool myMessage,
    required Widget widget,
    required String time}) {
  return Container(
    margin: EdgeInsets.symmetric(vertical: 5),
    child: Row(
      children: [
        Visibility(
          visible: myMessage,
          child: SizedBox(width: MediaQuery.of(context).size.width * 0.20),
        ),
        Column(
          crossAxisAlignment:
              (myMessage) ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Container(
              width: MediaQuery.of(context).size.width * 0.74,
              padding: EdgeInsets.all(10),
              child: widget,
              decoration: BoxDecoration(
                color: (myMessage) ? Colors.greenAccent : Colors.tealAccent,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            SizedBox(
              height: 2,
            ),
            Text(time),
          ],
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
        ],
      ),
      time: '${dateTime.hour}:${dateTime.minute}');
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
          ],
        ),
      ),
      time: '${dateTime.hour}:${dateTime.minute}');
}
