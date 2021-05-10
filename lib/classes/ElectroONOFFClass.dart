import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sidebar_animation/Services/DataHelpers.dart';
import 'package:http/http.dart' as http;

class ElectroONOFFClass extends StatefulWidget {
  dynamic Electro;

  ElectroONOFFClass({this.Electro});
  @override
  _ElectroONOFFClassState createState() => _ElectroONOFFClassState();
}

class _ElectroONOFFClassState extends State<ElectroONOFFClass> {
  String id;
  String status;
  String active = "true";
  bool pressGeoON = false;
  bool cmbscritta = false;
  @override
  Widget build(BuildContext context) {
    MediaQueryData queryData;
    queryData = MediaQuery.of(context);
    id = widget.Electro.id.toString();
    return Container(
      width: queryData.size.width,
      child: Row(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
            child: Container(
              height: 80,
              width: 200,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    //Electro.toString() ?? '',
                    widget.Electro.name.toString(),
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    //Electro.toString() ?? '',
                    "Identifier: "+widget.Electro.sensorIdentifier.toString(),
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w400,
                      color: Colors.grey
                    ),
                  ),
                  Text(
                    //Electro.toString() ?? '',
                    "Description: "+widget.Electro.description.toString(),
                    style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w400,
                        color: Colors.grey
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(0, 0, 0, 50),
            child: Text(
              widget.Electro.status != cmbscritta ? "ON" : "OFF",
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                 color: widget.Electro.status != cmbscritta ? Colors.green : Colors.red ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(70, 0, 0, 30),
            child: Column(
              children: [
                IconButton(
                  icon: widget.Electro.status != cmbscritta ? Icon(Icons.flash_off) : Icon(Icons.flash_on),
                  iconSize: 30,
                  color: widget.Electro.status != cmbscritta ? Colors.red : Colors.green,
                  onPressed: () {
                     status = widget.Electro.status.toString();
                    _doSomething();

                     setState(() {
                      cmbscritta = !cmbscritta;
                     //7yela
                     // widget.Electro.status=!widget.Electro.status;
                    //rasmi
                     // widget.Electro  =  _doSomething();
                    });
                  },
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                  child: Text(
                    widget.Electro.status != cmbscritta ? "TURN OFF" : "TURN ON",
                    style:
                    TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _doSomething() async {
    Timer(Duration(seconds: 1), () {
      print("button pressed ");
      print("stauts" + status);
      print("id" + id);
      if (status == "true") {
        status = "false";
        On(id);

        //  _btnController.stop();
      } else if (status == "false") {
        status = "true";
        print("offfff");
        Off(id);
        /*   setState(() {
          pressGeoON = !pressGeoON;
          cmbscritta = !cmbscritta;
        });*/
        // _btnController.stop();
      }
      //_btnController.stop();
    });
  }

  On(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'token';
    final value = prefs.get(key) ?? 0;
    Map data = {'status': 01, 'SensorId': "$id"};
    var jsonResponse = null;
    var response = await http.post(
        DatabaseHelper2.serverUrl + "/dashboard/onoff?token=" + value,
        headers: {"Content-Type": "application/json"},
//        "http://192.168.56.81:3000/api/users/login",
        body: json.encode(data));
    print('statusCode  :' + response.statusCode.toString());
    if (response.statusCode == 200) {
      jsonResponse = json.decode(response.body);
    }
    print(response.body);
  }

  Off(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'token';
    final value = prefs.get(key) ?? 0;
    Map data = {'status': 00, 'SensorId': "$id"};
    var jsonResponse = null;
    var response = await http.post(
        DatabaseHelper2.serverUrl + "/dashboard/onoff?token=" + value,
        headers: {"Content-Type": "application/json"},
//        "http://192.168.56.81:3000/api/users/login",
        body: json.encode(data));
    print('statusCode  :' + response.statusCode.toString());
    if (response.statusCode == 200) {
      jsonResponse = json.decode(response.body);
    }
    print(response.body);
  }
}




