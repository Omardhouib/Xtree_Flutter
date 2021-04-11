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
import 'package:sidebar_animation/pages/Location/AllLocations.dart';
import 'package:sidebar_animation/pages/Location/LocationDetails.dart';
import 'package:sidebar_animation/sidebar/sidebar_layout.dart';

class UpdateLoc extends StatefulWidget with NavigationStates{
  UpdateLoc(
      {Key key,
      this.title,
      this.onValueChange,
      this.initialValue,
      this.identifier,
      this.name})
      : super(key: key);
  String identifier;
  String name;
  final String initialValue;
  final void Function(String) onValueChange;
  final String title;
  @override
  UpdateLocState createState() => UpdateLocState();
}

class UpdateLocState extends State<UpdateLoc> {
  String identifier;
  GoogleMapController _controller;
  final CameraPosition _initialPosition =
  CameraPosition(target: LatLng(33.892166, 9.400138), zoom: 6.0);
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
    identifier = widget.identifier;
    final _key = GlobalKey<FormState>();
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
                  "UPDATE SITE: "+widget.name,style: TextStyle(
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
                            return "Site name cannot be empty !";
                          } else
                            return null;
                        },
                        controller: sitenameController,
                        decoration: InputDecoration(
                            icon: Icon(Icons.place, color: Colors.grey[400]),
                            border: InputBorder.none,
                            hintText: "New site name",
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
                            icon: Icon(Icons.description, color: Colors.grey[400]),
                            border: InputBorder.none,
                            hintText: "New description",
                            hintStyle: TextStyle(color: Colors.grey[400])),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: 600,
                width: 400,
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
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Container(
                  width: 250,
                  height: 40,
                  child: AspectRatio(
                    child: FlatButton(
                      color: Colors.amberAccent,
                      child: Text("Update Site", style: TextStyle(color: Colors.white)),
                      onPressed:(){
                        if(sitenameController.text == ""){
                          Fluttertoast.showToast(
                              msg: "Please define your site name !",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 5,
                              backgroundColor: Colors.red,
                              textColor: Colors.white,
                              fontSize: 10.0);

                        }
                        else if(descriptionController.text == ""){
                          Fluttertoast.showToast(
                              msg: "Please define your description !",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 5,
                              backgroundColor: Colors.red,
                              textColor: Colors.white,
                              fontSize: 10.0);

                        }
                        else if(coordiante == null){
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
      print(" Site name" + sitenameController.text);
      print(" description" + descriptionController.text);
      print(" Coordinates" + coordiante.toString());
      Addlocation(identifier, sitenameController.text, coordiante,
          descriptionController.text);
    });
  }

  void Addlocation(String identifier, String sitename, LatLng coord,
      String description) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'token';
    final value = prefs.get(key) ?? 0;
    List<double> coordt = new List<double>();
    coordt.add(coord.latitude);
    coordt.add(coord.longitude);
    print("hello" + coordt.toString());
    print("hello" + description);
    print("hello" + sitename);
    Map data = {
      "id": "$identifier",
      "SiteName": "$sitename",
      "Coordinates": coordt,
      "Description": "$description"
    };
    String myUrl =
        DatabaseHelper2.serverUrl + "/location/updateloc?token=" + value;
    final response = await http.put(myUrl,
        headers: {"Content-Type": "application/json"}, body: json.encode(data));

    if (json.decode(response.body)['status'] == "ok") {
      await Fluttertoast.showToast(
          msg: "Site Updated",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 3,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 10.0);
      Navigator.of(context)
          .push(new MaterialPageRoute(
          builder: (context) =>
              SideBarLayout(
              )));

    } else {
      await Fluttertoast.showToast(
          msg: "Error !",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 5,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 10.0);
      Navigator.pop(context, true);
    }
  }

  buttonSection() {
    return Container(
      height: 50,
      child: AspectRatio(
        child: RoundedLoadingButton(
          color: Colors.amberAccent,
          child: Text("Update", style: TextStyle(color: Colors.white)),
          controller: _btnController,
          onPressed: () {
             if(sitenameController.text == ""){
            Fluttertoast.showToast(
            msg: "Please define your site name !",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 5,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 10.0);
            }
             else if(descriptionController.text == ""){
               Fluttertoast.showToast(
                   msg: "Please define your description !",
                   toastLength: Toast.LENGTH_SHORT,
                   gravity: ToastGravity.BOTTOM,
                   timeInSecForIosWeb: 5,
                   backgroundColor: Colors.red,
                   textColor: Colors.white,
                   fontSize: 10.0);

             }
             else if(coordiante == null){
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
    );
  }
}
