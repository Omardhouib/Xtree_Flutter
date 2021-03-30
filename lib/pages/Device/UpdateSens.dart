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
import 'package:sidebar_animation/bloc.navigation_bloc/navigation_bloc.dart';
import 'package:sidebar_animation/pages/Device/Devices.dart';
import 'package:sidebar_animation/pages/Device/HomeDevice.dart';
import 'package:sidebar_animation/pages/Device/deviceDetails.dart';
import 'package:sidebar_animation/pages/homepage.dart';

class UpdateSens extends StatefulWidget with NavigationStates {
  UpdateSens({Key key, this.title, this.onValueChange, this.initialValue, this.identifier, this.name}) : super(key: key);
  final String title;
  final String identifier;
  final String initialValue;
  String name;
  final void Function(String) onValueChange;
  @override
  UpdateSensState createState() => UpdateSensState();
}

class UpdateSensState extends State<UpdateSens> {
  GoogleMapController _controller;
  final CameraPosition _initialPosition =
  CameraPosition(target: LatLng(33.892166, 9.400138), zoom: 5.0);
  List<Marker> Markers = [];
  List<Location> locations = [];
  final List<Marker> markers = [];
  List<double> coordt = new List<double>();
  String id;
  bool _isLoading = false;
  bool t3ada = false;
  bool faregh = false;
  final RoundedLoadingButtonController _btnController =
  new RoundedLoadingButtonController();
  final TextEditingController DevicenameController =
  new TextEditingController();
  final TextEditingController descriptionController =
  new TextEditingController();
  LatLng coordiante;
  String identifier;
  /* addMarker(cordinate) {
    int id = Random().nextInt(1);
    setState(() {
      markers
          .add(Marker(position: cordinate, markerId: MarkerId(id.toString())));
      coordiante = cordinate;
    });
  }*/

  @override
  Widget build(BuildContext context) {
    final _key = GlobalKey<FormState>();
    identifier = widget.identifier;
    return AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.0))),
      contentPadding: EdgeInsets.only(top: 10.0),
      content: SingleChildScrollView(
      child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  "Update Device: "+widget.name,style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500
                ),
                ),
              ),
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
                            return "Device name cannot be empty !";
                          } else
                            return null;
                        },
                        controller: DevicenameController,
                        decoration: InputDecoration(
                            icon: Icon(Icons.place, color: Colors.grey[400]),
                            border: InputBorder.none,
                            hintText: "New Device Name",
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
                            hintText: "New Description",
                            hintStyle: TextStyle(color: Colors.grey[400])),
                      ),
                    ),
                  ],
                ),
              ),
              /*  SizedBox(
                height: 30,
              ),*/
              FutureBuilder<List<Location>>(
//                future: databaseHelper.getData(),
                  future: databaseHelper2.AllLocationByUser(),
                  builder: (context,snapshot) {
                    if (snapshot.hasData) {
                      snapshot.data.forEach((Location) {
                        Markers = snapshot.data.map((Location) => Marker(
                            markerId: MarkerId(Location.id),
                            position: LatLng(Location.coordinates[0], Location.coordinates[1]),
                            icon: BitmapDescriptor.defaultMarker,
                            onTap: ()  {

                              /*print("coorddd111"+Location.coordinates.toString()),*/
                              coordt.add(Location.coordinates[0]);
                              coordt.add(Location.coordinates[1]);
                              id=Location.id;

                              setState(() {});
                            },
                            infoWindow: InfoWindow(title: Location.siteName,onTap: () => {
                              print("coorddd"+Location.coordinates.toString())
                            },)
                        )).toList(growable: true);
                      });
                    }
                    return Container(
                      height: 600,
                      width: 400,
                      child:GoogleMap(
                        initialCameraPosition: _initialPosition,
                        markers: Set<Marker>.of(Markers),
                        mapType: MapType.normal,
                        onMapCreated: (controller){
                          setState(() {
                            _controller = controller;
                          });
                        },
                      ),
                    );

                  }),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Container(
                  width: 250,
                  height: 40,
                  child: AspectRatio(
                    child: FlatButton(
                        color: Colors.amberAccent,
                        child: Text("Update", style: TextStyle(color: Colors.white)),
                        onPressed:(){
                          if(DevicenameController.text == ""){
                            Fluttertoast.showToast(
                                msg: "Please define your new sensor name !",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 5,
                                backgroundColor: Colors.red,
                                textColor: Colors.white,
                                fontSize: 10.0);
                          }
                          else if(descriptionController.text == ""){
                            Fluttertoast.showToast(
                                msg: "Please define your new sensor description !",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 5,
                                backgroundColor: Colors.red,
                                textColor: Colors.white,
                                fontSize: 10.0);
                          }
                          else if(coordt.isEmpty == true){
                            Fluttertoast.showToast(
                                msg: "Please select a new place on the map !",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 5,
                                backgroundColor: Colors.red,
                                textColor: Colors.white,
                                fontSize: 10.0);
                          }
                          else {
                            _doSomething();
                          }
                        }
                    ),
                    aspectRatio: 8,
                  ),
                ),
              ),
            ],
          ),
      ));
  }

  DatabaseHelper2 databaseHelper2 = new DatabaseHelper2();
  final _key = GlobalKey<FormState>();
  void _doSomething() async {
    Timer(Duration(seconds: 1), () {
      print("button pressed ");
      print(" Site name" + DevicenameController.text);
      print(" description" + descriptionController.text);
      print("Coordinates :"+coordt.toString());
      print(" Sens id: " + identifier.toString());

      Addlocation(identifier, DevicenameController.text, descriptionController.text, coordt);
    });
  }

  void Addlocation(String SensId, String sitename, String description, List coord) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'token';
    final value = prefs.get(key) ?? 0;
    var jsonResponse = null;
    Map data = {
      "id": "$SensId",
      "name": "$sitename" ,
      "Description": "$description",
      "SensorCoordinates": coord,

    };
    String myUrl = DatabaseHelper2.serverUrl + "/sensors/updatesens?token=" + value;
    var response = await http.put(myUrl,
        headers: {"Content-Type": "application/json"}, body: json.encode(data));
    if (response.statusCode == 200) {
      jsonResponse = json.decode(response.body);

      if (jsonResponse['message'] == "Device Updated") {
        setState(() {
          t3ada = true;
          _isLoading = false;
        });
        await Fluttertoast.showToast(
            msg: "Device Updated !",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 3,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 10.0);
      } else
        await Fluttertoast.showToast(
            msg: "Some kind of error !",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 3,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 10.0);

    }
  }
}
