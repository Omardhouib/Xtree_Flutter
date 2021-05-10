import 'dart:async';
import 'dart:convert';

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sidebar_animation/Models/Location.dart';
import 'package:sidebar_animation/Models/Sensor.dart';
import 'package:sidebar_animation/Services/DataHelpers.dart';
import 'package:http/http.dart' as http;
import 'package:sidebar_animation/bloc.navigation_bloc/navigation_bloc.dart';
import 'package:sidebar_animation/pages/Device/ConfirmeDeleteDev.dart';
import 'package:sidebar_animation/pages/Location/LocationDetails.dart';
import 'package:sidebar_animation/sidebar/sidebar_layout.dart';

class DeleteDev extends StatefulWidget with NavigationStates{
  DeleteDev(
      {Key key,
        this.title,
        this.onValueChange,
        this.initialValue, this.sensorIds, this.locationId,
      })
      : super(key: key);
  final String initialValue;
  String locationId;
  List<String> sensorIds;
  final void Function(String) onValueChange;
  final String title;
  @override
  DeleteDevState createState() => DeleteDevState();
}

class DeleteDevState extends State<DeleteDev> {
  String identifier;
  bool _isLoading = false;
  bool t3ada = false;
  bool faregh = false;
  DatabaseHelper2 databaseHelper2 = new DatabaseHelper2();

  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    final _key = GlobalKey<FormState>();
    return AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0))),
      contentPadding: EdgeInsets.only(top: 10.0),
      content: Container(
        height: 600,
        width: 400,
        child: Column(
          children: [
            Icon(
              Icons.info_outline,
              color: Colors.amber,
              size: 50,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
              child: Text(
                "Choose one Device !",style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w500
              ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
              child: Text(
                "From which you will delete it",style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: Colors.grey
              ),
              ),
            ),
            ItemList(list: widget.sensorIds, locationId: widget.locationId)

          ],
        ),
      ),
    );
  }
}

class ItemList extends StatefulWidget {
  List list;
  String locationId;
  ItemList({this.list, this.locationId});

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
      padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
      child: Container(
        height: 500,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.0),
            border: Border.all(color: Colors.transparent,width: 2)
        ),
        child: ListView.builder(
            itemCount: widget.list == null ? 0 : widget.list.length,
            shrinkWrap: true,
            itemBuilder: (context, i) {
              return  FutureBuilder<Sensor>(
//                future: databaseHelper.getData(),
                  future: databaseHelper2.getAllDeviceById(widget.list[i]),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      print(snapshot.error);
                      print("mochkla lenaa *");
                    }
                    if (snapshot.hasData) {
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
                                          Icons.device_hub,
                                          color: Colors.blue,
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
                                            width: 165,
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                              Text(
                                              snapshot.data.name,
                                              style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 20,
                                              ),
                                            ),
                                          Text(
                                            //list[i].toString() ?? '',
                                            "Description: " +
                                                snapshot.data.description,
                                            style: TextStyle(
                                                fontWeight: FontWeight.w400,
                                                fontSize: 11,
                                                color: Colors.grey),
                                          ),
                                          Text(
                                            //list[i].toString() ?? '',
                                            "Device Type: " +
                                                snapshot.data.sensorType,
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
                                            Icons.delete,
                                            color: Colors.red,
                                            size: 27,
                                          ),
                                          onPressed: () {
                                            showDialog(
                                                context: context,
                                                child: ConfirmeDeleteDev(
                                                    onValueChange: _onValueChange,
                                                    initialValue: _selectedId,
                                                    LocationId: widget.locationId,
                                                    SensorId: snapshot.data.id,
                                                    name: snapshot.data.name
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
                      );;
                    } else {
                      return Container();
                    }
                  });

            }),
      ),
    );
  }
}