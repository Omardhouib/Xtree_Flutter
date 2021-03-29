import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:search_map_place/search_map_place.dart';
import 'package:sidebar_animation/Models/Location.dart';
import 'package:sidebar_animation/Services/DataHelpers.dart';
import 'package:sidebar_animation/pages/Location/AddLocation.dart';
import 'package:sidebar_animation/pages/Location/DeleteLocation.dart';
import 'package:sidebar_animation/pages/Location/LocationDetails.dart';
import 'package:sidebar_animation/pages/Location/UpdateLoc.dart';

import '../../bloc.navigation_bloc/navigation_bloc.dart';

class Locations extends StatefulWidget with NavigationStates {
  @override
  _LocationsState createState() => _LocationsState();
}

class _LocationsState extends State<Locations> {
  DatabaseHelper2 databaseHelper2 = new DatabaseHelper2();
  GoogleMapController _controller;
  final CameraPosition _initialPosition =
      CameraPosition(target: LatLng(33.892166, 9.400138), zoom: 5.0);
  // ignore: non_constant_identifier_names
  List<Marker> Markers = [];
  List<String> locations = [];
  // ignore: non_constant_identifier_names
  Future<List<Location>> Alllocation;
  void _onValueChange(String value) {
    setState(() {
      _selectedId = value;
    });
  }
  String _selectedId;
  @override
  void initState() {
    setState(() {
      Alllocation = databaseHelper2.AllLocationByUser();
      super.initState();
    });

  }

  @override
  Widget build(BuildContext context) {
    List<String> locations = [];
    List<Location> loc = [];
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Column(
        children: [
          Container(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 80, 0, 10),
              child: Row(
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "Locations",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 30.0,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.normal,
                        ),
                      ),
                      Text(
                        'Welcome Omar dhouib',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 15.0,
                          color: Colors.grey,
                          fontWeight: FontWeight.w500,
                          fontStyle: FontStyle.normal,
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(190, 0, 0, 0),
                    child: CircleAvatar(
                      backgroundColor: Colors.blue[100],
                      child: Icon(
                        Icons.perm_identity,
                        size: 30,
                        color: Colors.blue,
                      ),
                      radius: 33,
                    ),
                  ),
                ],
              ),
            ),
          ),
          FutureBuilder<List<Location>>(
//                future: databaseHelper.getData(),
              future: Alllocation,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  //
                  print("loc"+snapshot.data.length.toString());
                  // ignore: non_constant_identifier_names
                  snapshot.data.forEach((Location) {
                    locations.add(Location.siteName);
                  //  print("heello" + locations.toString());
                    Markers = snapshot.data
                        .map((Location) => Marker(
                            markerId: MarkerId(Location.id),
                            position: LatLng(Location.coordinates[0],
                                Location.coordinates[1]),
                            icon: BitmapDescriptor.defaultMarker,
                            onTap: () => {},
                            infoWindow: InfoWindow(
                              title: Location.siteName,
                              onTap: () => {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => LocationDetails(
                                            identifier: Location.id))),
                              },
                            )))
                        .toList(growable: true);
                  });
                }
                return Column(
                  children: [
                    ItemList(list: snapshot.data),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                      child: Container(
                        height: 90,
                        child: Card(
                          semanticContainer: true,
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          elevation: 4,
                          margin: EdgeInsets.fromLTRB(10, 0, 10, 10),
                          child: Row(
                            children: [
                              Padding(
                                padding:
                                const EdgeInsets.fromLTRB(15, 0, 40, 0),
                                child: CircleAvatar(
                                  backgroundColor: Colors.blue,
                                  child: Icon(
                                    Icons.add_circle,
                                    color: Colors.white,
                                  ),
                                  radius: 25,
                                ),
                              ),
                              Text(
                                "ADD LOCATION ",
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 20,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(90, 0, 0, 0),
                                child: FlatButton(
                                  child: Icon(
                                    Icons.add_circle_outline,
                                    color: Colors.blue,
                                    size: 35,
                                  ),
                                  onPressed: () {
                                    showDialog(
                                        context: context,
                                        child: AddLocation(
                                          onValueChange: _onValueChange,
                                          initialValue: _selectedId,
                                        ));
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                      child: Container(
                        height: 350,
                        width: 600,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(12.0)),
                          color: Colors.white,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: GoogleMap(
                            initialCameraPosition: _initialPosition,
                            markers: Set<Marker>.of(Markers),
                            mapType: MapType.normal,
                            onMapCreated: (controller) {
                              setState(() {
                                _controller = controller;
                              });
                            },
                          ),
                        ),
                      ),
                    ),

                  ],
                );
              }),
        ],
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class ItemList extends StatefulWidget {
  List list;
  ItemList({this.list});

  @override
  _ItemListState createState() => _ItemListState();
}

class _ItemListState extends State<ItemList> {
  String type;
  void _onValueChange(String value) {
    setState(() {
      _selectedId = value;
    });
  }


  String _selectedId;
  ScrollController _controller = new ScrollController();

  DatabaseHelper2 databaseHelper2 = new DatabaseHelper2();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 5, 10, 0),
      child: Container(
        height: 370,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.0),
            border: Border.all(color: Colors.transparent,width: 2)
        ),
        child: ListView.builder(
            itemCount: widget.list == null ? 0 : widget.list.length,
            shrinkWrap: true,
            itemBuilder: (context, i) {
              return Container(
                height: 90,
                child: Card(
                  semanticContainer: true,
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  elevation: 3,
                  margin: EdgeInsets.fromLTRB(10, 0, 10, 10),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(10, 20, 0, 0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CircleAvatar(
                                backgroundColor: Colors.grey[300],
                                child: Icon(
                                  Icons.place,
                                  color: Colors.red,
                                ),
                                radius: 25,
                              ),
                              GestureDetector(
                                /* onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => deviceDetails(
                                          list:widget.list,
                                          index: i,
                                          identifier: widget.list[i]["_id"]

                                      ),
                                    ),
                                  );
                                },*/
                                child: Padding(
                                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                                  child: Container(
                                    width: 230,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) => LocationDetails(
                                                        identifier: widget.list[i].id)));
                                          },
                                          child: Text(
                                            widget.list[i].siteName,
                                            style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 20,
                                            ),
                                          ),
                                        ),
                                        Text(
                                          //list[i].toString() ?? '',
                                          "Description: " +
                                              widget.list[i].description,
                                          style: TextStyle(
                                              fontWeight: FontWeight.w400,
                                              fontSize: 11,
                                              color: Colors.grey),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                                child: IconButton(
                                  icon: Icon(
                                    Icons.edit,
                                    color: Colors.green,
                                    size: 27,
                                  ),
                                  onPressed: () {
                                    showDialog(
                                        context: context,
                                        child: UpdateLoc(
                                            onValueChange: _onValueChange,
                                            initialValue: _selectedId,
                                            identifier: widget.list[i].id,
                                            name: widget.list[i].siteName
                                        ));
                                  },
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                                child: IconButton(
                                  icon: Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                    size: 27,
                                  ),
                                  onPressed: () {
                                    showDialog(
                                        context: context,
                                        child: DeleteLocation(
                                            onValueChange: _onValueChange,
                                            initialValue: _selectedId,
                                            identifier: widget.list[i].id,
                                            name: widget.list[i].siteName
                                        ));
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        /*Divider(
                          height: 34,
                          thickness: 0.9,
                          color: Colors.grey[400].withOpacity(0.3),
                          indent: 40,
                          endIndent: 40,
                        ),*/
                      ],
                    ),
                  ),
                ),
              );
            }),
      ),
    );
  }
}
