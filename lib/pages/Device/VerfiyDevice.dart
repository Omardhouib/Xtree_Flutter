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
  VerfiyDevice({Key key, this.title}) : super(key: key);
  final String title;
  @override
  VerfiyDeviceState createState() => VerfiyDeviceState();
}

class VerfiyDeviceState extends State<VerfiyDevice> {
  GoogleMapController _controller;
  final CameraPosition _initialPosition = CameraPosition(target: LatLng(33.892166, 9.400138), zoom: 5.0);
  List<Marker> Markers = [];
  List<Location> locations = [];
  final List<Marker> markers = [];
  bool _isLoading = false;
  bool t3ada = false;
  bool faregh = false;
  final RoundedLoadingButtonController _btnController =
  new RoundedLoadingButtonController();
  final TextEditingController DevicenameController = new TextEditingController();
  final TextEditingController descriptionController =
  new TextEditingController();
  LatLng coordiante;
  addMarker(cordinate) {
    int id = Random().nextInt(1);
    setState(() {
      markers
          .add(Marker(position: cordinate, markerId: MarkerId(id.toString())));
      coordiante = cordinate;
    });
  }

  @override
  Widget build(BuildContext context) {
    final _key = GlobalKey<FormState>();
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: Stack(
        children: [
          Column(
            children: [
              Form(
                key: _key,
                child: Column(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.fromLTRB(10, 150, 10, 0),
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
                            icon: Icon(Icons.place, color: Colors.grey[400]),
                            border: InputBorder.none,
                            hintText: "Site name",
                            hintStyle: TextStyle(color: Colors.grey[400])),
                      ),
                    ),
                    /*Container(
                      padding: EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                          border: Border(
                              bottom: BorderSide(color: Colors.grey[100]))),
                      child: TextFormField(
                        validator: (value) {
                          if (value.isEmpty) {
                            return "Description cannot be empty !";
                          } else
                            return null;
                        },
                        controller: descriptionController,
                        decoration: InputDecoration(
                            icon: Icon(Icons.email, color: Colors.grey[400]),
                            border: InputBorder.none,
                            hintText: "Description",
                            hintStyle: TextStyle(color: Colors.grey[400])),
                      ),
                    ),*/
                  ],
                ),
              ),
            /*  Expanded(
                child: GoogleMap(
                  initialCameraPosition: _initialPosition,
                  mapType: MapType.normal,
                  onMapCreated: (controller) {
                    setState(() {
                      _controller = controller;
                    });
                  },
                  markers: markers.toSet(),
                  onTap: (cordinate) {
                    _controller
                        .animateCamera(CameraUpdate.newLatLng(cordinate));
                    addMarker(cordinate);

                  },
                ),
              ),*/
              SizedBox(
                height: 30,
              ),
              buttonSection(),
            ],
          ),
        ],
      ),
     /* floatingActionButton: FloatingActionButton(
        onPressed: () {
          _controller.animateCamera(CameraUpdate.zoomOut());
        },
        child: Icon(Icons.zoom_out),
      ),*/
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
      _btnController.stop();
    });
  }

  void Addlocation(String sitename) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'token';
    final value = prefs.get(key) ?? 0;
    var jsonResponse = null;
   /* List<double> coordt = new List<double>();
    coordt.add(coord.latitude);
    coordt.add(coord.longitude);
    print("hello"+coordt.toString());
    print("hello"+description);
    print("hello"+sitename);*/
    Map data = {
      "Sensorid": "$sitename"/*,
      "Coordinates": coordt,
      "Description": "$description"*/

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
            msg: "New Sensor have been Found !",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 3,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 10.0);
        await Navigator.of(context).pushAndRemoveUntil(
             MaterialPageRoute(
                builder: (BuildContext context) => AddDevice(
                    identifier: jsonResponse["SensorFoundId"])),
            (Route<dynamic> route) => true);
      } else if ((jsonResponse['message'] == "Already in use")) {
        await Fluttertoast.showToast(
            msg: "Already in use",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 3,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 10.0);
      }
      else if ((jsonResponse['message'] == "No Sensor Found !")) {
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

  buttonSection() {
    return Container(
      height: 50,
      child: AspectRatio(
        child: RoundedLoadingButton(
          color: Colors.amberAccent,
          child: Text("Add", style: TextStyle(color: Colors.white)),
          controller: _btnController,
          onPressed: _doSomething,
        ),
        aspectRatio: 8,
      ),
    );
  }
}
