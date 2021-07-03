import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

class DistanceScreen extends StatefulWidget {
  @override
  _DistanceScreenState createState() => _DistanceScreenState();
}

class _DistanceScreenState extends State<DistanceScreen> {
  FlutterBluetoothSerial _bluetooth = FlutterBluetoothSerial.instance;
  String op = "00 Foot";
  String deviceAddress = "";
  bool isConnectButtonEnabled = true;
  bool isDisConnectButtonEnabled = false;

  void _connect() async {
    List<BluetoothDevice> devices = [];
    devices = await _bluetooth.getBondedDevices();
    // ignore: unnecessary_statements
    devices.forEach((device) async {
      print(device);
      if (device.name == "HC-05") {
        setState(() {
          deviceAddress = device.address;
        });
        await BluetoothConnection.toAddress(deviceAddress).then((_connection) {
          _connection.input.listen((Uint8List data) {
            print('Arduino Data : ${ascii.decode(data)}');
            setState(() {
              op = ascii.decode(data) + " Foot";
            });
          });

          _connection.input.listen(null).onDone(() {
            print('Disconnected remotely!');
          });
        }).whenComplete(() {
          setState(() {
            isConnectButtonEnabled = false;
            isDisConnectButtonEnabled = true;
          });
        });
      } else {
        print('No devices present');
      }
    });
  }

  void _disconnect() async {
    setState(() {
      op = "Disconnected";
      isConnectButtonEnabled = true;
      isDisConnectButtonEnabled = false;
    });
    await BluetoothConnection.toAddress(deviceAddress).then((_connection) {
      _connection.close();
      _connection.dispose();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Distance Screen',
        ),
      ),
      body: Column(
        children: [
          Text(
            "Please make sure you paired your HC-05, its default password is 1234",
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.redAccent),
          ),
          Container(
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.fromLTRB(15, 100, 0, 0),
                  child: FlatButton(
                    onPressed: isConnectButtonEnabled ? _connect : null,
                    child: Text("Connect HC-05"),
                    color: Colors.greenAccent,
                    disabledColor: Colors.grey,
                  ),
                ),
                SizedBox(
                  width: 25,
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(0, 100, 0, 0),
                  child: FlatButton(
                    onPressed: isDisConnectButtonEnabled ? _disconnect : null,
                    child: Text("Disconnect HC-05"),
                    color: Colors.redAccent,
                    disabledColor: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 50),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                color: Colors.deepOrange,
                elevation: 10,
                child: Text(
                  "Output:",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 5,
                      color: Colors.amberAccent,
                      fontStyle: FontStyle.italic),
                ),
              ),
              Card(
                color: Colors.deepOrange,
                elevation: 10,
                child: Text(
                  "There is an object at ",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.amberAccent),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Card(
                color: Colors.deepOrange,
                elevation: 10,
                child: Text(
                  "$op   ",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                      color: Colors.amberAccent),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Card(
                color: Colors.deepOrange,
                elevation: 10,
                child: Text(
                  "away from the Sensor!! ",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.amberAccent),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
