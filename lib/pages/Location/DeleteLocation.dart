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
import 'package:sidebar_animation/pages/Location/LocationDetails.dart';
import 'package:sidebar_animation/sidebar/sidebar_layout.dart';

class DeleteLocation extends StatefulWidget with NavigationStates{
  DeleteLocation(
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
  DeleteLocationState createState() => DeleteLocationState();
}

class DeleteLocationState extends State<DeleteLocation> {
  String identifier;
  bool _isLoading = false;
  bool t3ada = false;
  bool faregh = false;

  @override
  Widget build(BuildContext context) {
    identifier = widget.identifier;
    final _key = GlobalKey<FormState>();
    return AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0))),
        contentPadding: EdgeInsets.only(top: 10.0),
      content: Container(
        height: 180,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              Icons.warning,
              color: Colors.red,
              size: 50,
            ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                    child: Text(
                      "Are you sure !",style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w500
                    ),
                    ),
                  ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
              child: Text(
                "You won't be able to revert this !",style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w300
              ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                  child: Text(
                    "Delete the site: ",style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                    color: Colors.grey
                  ),
                  ),
                ),
                Text(
                  widget.name,style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey[900]
                ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(30, 10, 0, 0),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 40, 0),
                    child: FlatButton(
                      onPressed: () {
                        _doSomething();
                      }, // passing true
                      child: Text('Yes',style: TextStyle(
                        color: Colors.blue
                      ),),
                    ),
                  ),
                  FlatButton(
                    onPressed: () => Navigator.pop(context, false), // passing false
                    child: Text('No'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  DatabaseHelper2 databaseHelper2 = new DatabaseHelper2();
  final _key = GlobalKey<FormState>();
  void _doSomething() async {
    Timer(Duration(seconds: 1), () {
      print("button pressed ");
      DeleteLoc(identifier);
    });
  }

  void DeleteLoc(String identifier) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'token';
    final value = prefs.get(key) ?? 0;
    Map data = {
      "LocationId": "$identifier"
    };
    String myUrl =
        DatabaseHelper2.serverUrl + "/location/remouve?token=" + value;
    final response = await http.post(myUrl,
        headers: {"Content-Type": "application/json"}, body: json.encode(data));

    if (json.decode(response.body)['status'] == "ok") {
      await Fluttertoast.showToast(
          msg: "Location Deleted",
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
    }
  }
}
