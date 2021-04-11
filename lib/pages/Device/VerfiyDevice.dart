import 'dart:async';
import 'dart:convert';

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sidebar_animation/Models/Location.dart';
import 'package:sidebar_animation/Services/DataHelpers.dart';
import 'package:http/http.dart' as http;
import 'package:sidebar_animation/pages/Device/AddDevice.dart';

class VerfiyDevice extends StatefulWidget {
  VerfiyDevice({Key key, this.title, this.onValueChange, this.initialValue}) : super(key: key);
  final String title;
  final String initialValue;
  final void Function(String) onValueChange;
  @override
  VerfiyDeviceState createState() => VerfiyDeviceState();
}

class VerfiyDeviceState extends State<VerfiyDevice> {
  void _onValueChange(String value) {
    setState(() {
      _selectedId = value;
    });
  }
  String _selectedId;
  bool _isLoading = false;
  bool t3ada = false;
  bool faregh = false;
  final RoundedLoadingButtonController _btnController =
  new RoundedLoadingButtonController();
  final TextEditingController DevicenameController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    final _key = GlobalKey<FormState>();
    return AlertDialog(
        shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(20.0))),
    contentPadding: EdgeInsets.only(top: 10.0),
        content: SingleChildScrollView(
           child: Column(
              children: [
                Form(
                  key: _key,
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(
                          "DEVICE VERIFICATION",
                          style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                        decoration: BoxDecoration(
                            border: Border(
                                bottom: BorderSide(color: Colors.grey[100]))),
                        child: TextFormField(
                          validator: (value) {
                            if (value.isEmpty) {
                              return "Device name cannot be empty !";
                            } else
                              return null;
                          },
                          controller: DevicenameController,
                          decoration: InputDecoration(
                              icon: Icon(Icons.add, color: Colors.grey[400]),
                              border: InputBorder.none,
                              hintText: "Device identifier",
                              hintStyle: TextStyle(color: Colors.grey[400])),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
          Container(
            width: 150,
            child: FlatButton(
              color: Colors.amberAccent,
              child: Text("Verify", style: TextStyle(color: Colors.white)),
              onPressed: _doSomething,
            ),
          ),
              ],
            ),
      )
      );
  }

  DatabaseHelper2 databaseHelper2 = new DatabaseHelper2();
  final _key = GlobalKey<FormState>();
  void _doSomething() async {
    Timer(Duration(seconds: 1), () {
      print("button pressed ");
      print(" Site name" + DevicenameController.text);
     /* print(" description" + descriptionController.text);
      print(" Coordinates" + coordiante.toString());*/
      Addlocation(DevicenameController.text);
    });
  }

  void Addlocation(String sitename) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'token';
    final value = prefs.get(key) ?? 0;
    var jsonResponse = null;
    Map data = {
      "Sensorid": "$sitename"
    };
    String myUrl = DatabaseHelper2.serverUrl + "/sensors/find?token=" + value;
    var response = await http.post(myUrl,
        headers: {"Content-Type": "application/json"},
        body:
        json.encode(data)
    );
    if (response.statusCode == 200) {
      jsonResponse = json.decode(response.body);

      if (jsonResponse['message'] == "New Sensor have been Found !") {
        setState(() {
          t3ada = true;
          _isLoading = false;
        });
        print("id: "+jsonResponse["SensorFoundId"]);
        await Fluttertoast.showToast(
            msg: "New Device have been Found !",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 3,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 10.0);
        showDialog(
            context: context,
            child: AddDevice(
              identifier: jsonResponse["SensorFoundId"],
              onValueChange: _onValueChange,
              initialValue: _selectedId,
            ));
      } else if ((jsonResponse['message'] == "Already in use !")) {
        await Fluttertoast.showToast(
            msg: "the Device is already in use",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 3,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 10.0);
      }
      else if ((jsonResponse['message'] == "No Sensor Found!")) {
        await Fluttertoast.showToast(
            msg: "No Sensor Found !",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 3,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 10.0);
      }
    }
  }

  /*buttonSection() {
    return Container(
      height: 50,
      child: AspectRatio(
        child: FlatButton(
          color: Colors.amberAccent,
          child: Text("Add", style: TextStyle(color: Colors.white)),
          controller: _btnController,
          onPressed: _doSomething,
        ),
        aspectRatio: 8,
      ),
    );
  }*/
}
