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

class AddDevice extends StatefulWidget {
  AddDevice({Key key, this.title, this.identifier}) : super(key: key);
  final String title;
  final String identifier;
  @override
  AddDeviceState createState() => AddDeviceState();
}

class AddDeviceState extends State<AddDevice> {
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
            /*  SizedBox(
                height: 30,
              ),*/
              FutureBuilder<List<Location>>(
//                future: databaseHelper.getData(),
                  future: databaseHelper2.AllLocationByUser(),
                  builder: (context,snapshot) {
                    if (snapshot.hasData) {
                      snapshot.data.forEach((Location) {
                        print("beforee: "+Location.coordinates[0].toString());
                        Markers = snapshot.data.map((Location) => Marker(
                            markerId: MarkerId(Location.id),
                            position: LatLng(Location.coordinates[0], Location.coordinates[1]),
                            icon: BitmapDescriptor.defaultMarker,
                            onTap: ()  {

                              /*print("coorddd111"+Location.coordinates.toString()),*/
                              print("coorddd111"+Location.id.toString());
                              coordt.add(Location.coordinates[0]);
                              coordt.add(Location.coordinates[1]);
                               id=Location.id;

                            setState(() {});
                            },
                            infoWindow: InfoWindow(title: Location.siteName,onTap: () => {
                              print("coorddd"+Location.coordinates.toString())
                            },)
                        )).toList(growable: true);
                        print("Markers berfore!!! :"+Markers.toString());
                      });
                    }
                    print("Markers !!! :"+Markers.toString());
                    return Expanded(
                        child:GoogleMap(
                      initialCameraPosition: _initialPosition,
                      markers: Set<Marker>.of(Markers),
                      mapType: MapType.hybrid,
                      onMapCreated: (controller){
                        setState(() {
                          _controller = controller;
                        });
                      },
                      /*markers: markers.toSet(),
            onTap: (cordinate){
              _controller.animateCamera(CameraUpdate.newLatLng(cordinate));
              addMarker(cordinate);
              print("cord"+cordinate.toString());
            },*/

                    ),
                    );

                  }),
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
       print(" description" + descriptionController.text);
      print("loc id :"+id);
      print("Coordinates :"+coordt.toString());
      print(" Sens id: " + identifier.toString());

      Addlocation(DevicenameController.text, descriptionController.text, identifier, id, coordt);
      _btnController.stop();
    });
  }

  void Addlocation(String sitename, String description, String SensId, String LocId, List coord) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'token';
    final value = prefs.get(key) ?? 0;
    var jsonResponse = null;
    Map data = {
      "SensorName": "$sitename" ,
      "SensorId": "$SensId",
      "Description": "$description",
      "SensorCoordinates": coord,
      "LocationId": "$LocId"

    };
    String myUrl = DatabaseHelper2.serverUrl + "/sensors/Add?token=" + value;
    var response = await http.post(myUrl,
        headers: {"Content-Type": "application/json"}, body: json.encode(data));
    if (response.statusCode == 200) {
      jsonResponse = json.decode(response.body);

      if (jsonResponse['message'] == "New Sensor have been added !") {
        setState(() {
          t3ada = true;
          _isLoading = false;
        });
        await Fluttertoast.showToast(
            msg: "New Sensor have been added !",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 3,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 10.0);
      } else if ((jsonResponse['message'] == "Some kind of error !")) {
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
