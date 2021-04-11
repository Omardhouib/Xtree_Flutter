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
import 'package:sidebar_animation/pages/Device/DeleteDev.dart';
import 'package:sidebar_animation/pages/Location/LocationDetails.dart';
import 'package:sidebar_animation/sidebar/sidebar_layout.dart';

class deleteDevVerifyLoc extends StatefulWidget with NavigationStates{
  deleteDevVerifyLoc(
      {Key key,
        this.title,
        this.onValueChange,
        this.initialValue,
      })
      : super(key: key);
  final String initialValue;
  final void Function(String) onValueChange;
  final String title;
  @override
  deleteDevVerifyLocState createState() => deleteDevVerifyLocState();
}

class deleteDevVerifyLocState extends State<deleteDevVerifyLoc> {
  String identifier;
  bool _isLoading = false;
  bool t3ada = false;
  bool faregh = false;
  DatabaseHelper2 databaseHelper2 = new DatabaseHelper2();
  Future<List<Location>> AllLocation;

  @override
  void initState() {
    AllLocation = databaseHelper2.AllUserLocation();
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
                "Choose one Site !",style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w500
              ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
              child: Text(
                "From which you will delete the device",style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                color: Colors.grey
              ),
              ),
            ),
            FutureBuilder<List<Location>>(
//                future: databaseHelper.getData(),
                future: AllLocation,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    print(snapshot.error);
                    print("mochkla lenaa *");
                  }
                  if (snapshot.hasData) {
                    return ItemList(list: snapshot.data);
                  } else {
                    return Container();
                  }
                }),
          ],
        ),
      ),
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
      padding: const EdgeInsets.fromLTRB(10, 25, 10, 0),
      child: Container(
        height: 450,
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
                                            if (widget.list[i].sensorIds.length > 0){
                                              showDialog(
                                                  context: context,
                                                  child: DeleteDev(
                                                      onValueChange: _onValueChange,
                                                      initialValue: _selectedId,
                                                      sensorIds: widget.list[i].sensorIds,
                                                      locationId: widget.list[i].id
                                                  ));
                                            }
                                            else  Fluttertoast.showToast(
                                                msg: widget.list[i].siteName+" does not have any device !",
                                                toastLength: Toast.LENGTH_SHORT,
                                                gravity: ToastGravity.BOTTOM,
                                                timeInSecForIosWeb: 7,
                                                backgroundColor: Colors.red,
                                                textColor: Colors.white,
                                                fontSize: 10.0);

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
                                        Text(
                                          //list[i].toString() ?? '',
                                          "Number of devices: " +
                                              widget.list[i].sensorIds.length.toString(),
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