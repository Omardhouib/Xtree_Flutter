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

class AddLocation extends StatefulWidget {
  AddLocation({Key key, this.title}) : super(key: key);
  final String title;
  @override
  AddLocationState createState() => AddLocationState();
}

class AddLocationState extends State<AddLocation> {
  GoogleMapController _controller;
  final CameraPosition _initialPosition =
  CameraPosition(target: LatLng(24.903623, 67.198367));
  final List<Marker> markers = [];
  bool _isLoading = false;
  bool t3ada = false;
  bool faregh = false;
  final RoundedLoadingButtonController _btnController =
  new RoundedLoadingButtonController();
  final TextEditingController sitenameController = new TextEditingController();
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
      body: Stack(
        children: [
          Column(
            children: [
              Form(
                key: _key,
                child: Column(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                          border: Border(
                              bottom: BorderSide(color: Colors.grey[100]))),
                      child: TextFormField(
                        validator: (value) {
                          if (value.isEmpty) {
                            return "Site name cannot be empty !";
                          } else
                            return null;
                        },
                        controller: sitenameController,
                        decoration: InputDecoration(
                            icon: Icon(Icons.place, color: Colors.grey[400]),
                            border: InputBorder.none,
                            hintText: "Site name",
                            hintStyle: TextStyle(color: Colors.grey[400])),
                      ),
                    ),
                    Container(
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
                    ),
                  ],
                ),
              ),
              Expanded(
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
              ),
              SizedBox(
                height: 30,
              ),
              buttonSection(),
            ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _controller.animateCamera(CameraUpdate.zoomOut());
        },
        child: Icon(Icons.zoom_out),
      ),
    );
  }

  DatabaseHelper2 databaseHelper2 = new DatabaseHelper2();
  final _key = GlobalKey<FormState>();
  void _doSomething() async {
    Timer(Duration(seconds: 1), () {
      print("button pressed ");
      print(" Site name" + sitenameController.text);
      print(" description" + descriptionController.text);
      print(" Coordinates" + coordiante.toString());
      Addlocation(sitenameController.text, coordiante, descriptionController.text);
      _btnController.stop();
    });
  }

  void Addlocation(String sitename, LatLng coord, String description) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'token';
    final value = prefs.get(key) ?? 0;
    List<double> coordt = new List<double>();
    coordt.add(coord.latitude);
    coordt.add(coord.longitude);
    print("hello"+coordt.toString());
    print("hello"+description);
    print("hello"+sitename);
    Map data = {
      "SiteName": "$sitename",
      "Coordinates": coordt,
      "Description": "$description"

    };    String myUrl = DatabaseHelper2.serverUrl + "/location/Add?token=" + value;
    await http.post(myUrl,
        headers: {"Content-Type": "application/json"},
        body:
          json.encode(data)
    ).then((response) {
      print('Response status : ${response.statusCode}');
      print('Response body : ${response.body}');
    });
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
