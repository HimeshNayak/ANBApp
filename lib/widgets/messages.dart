import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

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
  void launchGoogleMaps(double lat, double lng) async {
    var url = 'google.navigation:q=${lat.toString()},${lng.toString()}';
    var fallbackUrl =
        'https://www.google.com/maps/search/?api=1&query=${lat.toString()},${lng.toString()}';
    try {
      bool launched =
          await launch(url, forceSafariVC: false, forceWebView: false);
      if (!launched) {
        await launch(fallbackUrl, forceSafariVC: false, forceWebView: false);
      }
    } catch (e) {
      await launch(fallbackUrl, forceSafariVC: false, forceWebView: false);
    }
  }

  DateTime dateTime = map['timestamp'].toDate();
  return spacingWidget(
      context: context,
      myMessage: myMessage,
      widget: Column(
        children: <Widget>[
          (myMessage)
              ? Text('Your location has been sent to the doctor.')
              : TextButton(
                  onPressed: () {
                    launchGoogleMaps(map['latitude'], map['longitude']);
                  },
                  child: Text('SOS Tapped\nShow Directions'),
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
