import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/user.dart';

String constructFCMPayload(
    String token, String from, String receiver, String message) {
  return jsonEncode(
    {
      "to": token,
      "data": {"sender": from, "receiver": receiver},
      "notification": {"title": "Message from $from", "body": message}
    },
  );
}

Future<void> sendNotification(
    String token, String from, String receiver, String message) async {
  if (token == null) {
    print('Unable to send FCM message, no token exists.');
    return;
  }

  try {
    await http
        .post(
      Uri.parse('https://fcm.googleapis.com/fcm/send'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'key='
      },
      body: constructFCMPayload(token, from, receiver, message),
    )
        .then((value) {
      print(value.body.toString());
    }).catchError((e) {
      print(e);
    });
    print('FCM request for device sent!');
  } catch (e) {
    print(e);
  }
}
