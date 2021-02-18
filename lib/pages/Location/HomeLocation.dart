import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sidebar_animation/Services/DataHelpers.dart';
import 'package:sidebar_animation/pages/Location/AddLocation.dart';
import 'package:sidebar_animation/pages/Location/AllLocations.dart';
import 'package:sidebar_animation/sidebar/sidebar.dart';
import 'package:sidebar_animation/sidebar/sidebar_layout.dart';
import 'package:sidebar_animation/constants.dart';

import 'package:flutter/gestures.dart';
import 'package:sidebar_animation/bloc.navigation_bloc/navigation_bloc.dart';

class HomeLocation extends StatelessWidget with NavigationStates {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyHomeLocation(),
    );
  }
}

class MyHomeLocation extends StatefulWidget {
  MyHomeLocation({Key key, this.title}) : super(key: key);
  final String title;

  MyHomeLocationState createState() => MyHomeLocationState();
}

class MyHomeLocationState extends State<MyHomeLocation> {
  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    var hour = DateTime.now().hour;
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: ListView(
        children: <Widget>[
          Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(7, 50, 0, 25),
                    child: Row(
                      children: <Widget>[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              'Home'+hour.toString(),
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
                                fontSize: 16.0,
                                color: Colors.grey[600],
                                fontWeight: FontWeight.normal,
                                fontStyle: FontStyle.normal,
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(190, 0, 0, 0),
                          child: CircleAvatar(
                            backgroundColor: Colors.blueGrey,
                            child: Icon(
                              Icons.perm_identity,
                              color: Colors.white,
                            ),
                            radius: 35,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ]),
          Container(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 60, 0, 60),
            ),
          ),
          _buildGridView(),
        ],
      ),
    );
  }


  SizedBox _buildGridView() {
    return SizedBox(
      height: 350.0,
      child: GridView.count(
        crossAxisCount: 2,
        padding: EdgeInsets.fromLTRB(60, 40, 60, 40),
        childAspectRatio: 1.35,
        crossAxisSpacing: 20,
        mainAxisSpacing: 10,
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(13),
            child: Container(
              padding: EdgeInsets.all(0),
              decoration: BoxDecoration(
                color: Colors.blue[300],
                borderRadius: BorderRadius.circular(13),
                boxShadow: [
                  BoxShadow(
                    offset: Offset(0, 17),
                    blurRadius: 17,
                    spreadRadius: -23,
                    color: kShadowColor,
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Locations(),

                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      children: <Widget>[
                    Text(
                    //list[i].toString() ?? '',
                    'locations'
                    ),
                    Icon(
                    Icons.place,
                  ),
                        Spacer(),
                        Spacer(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(13),
            child: Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.red[400],
                borderRadius: BorderRadius.circular(13),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AddLocation(),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      children: <Widget>[
                        Spacer(),
                        Spacer(),
                        Text(
                          "Add location",
                          textAlign: TextAlign.center,
                          style: Theme.of(this.context)
                              .textTheme
                              .title
                              .copyWith(fontSize: 15),
                        ),
                        Icon(
                          Icons.add,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(13),
            child: Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.green[400],
                borderRadius: BorderRadius.circular(13),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {},
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      children: <Widget>[
                        Spacer(),
                        Spacer(),
                        Text(
                          "Kegel Exercises",
                          textAlign: TextAlign.center,
                          style: Theme.of(this.context)
                              .textTheme
                              .title
                              .copyWith(fontSize: 15),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(13),
            child: Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.amberAccent[400],
                borderRadius: BorderRadius.circular(13),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {},
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      children: <Widget>[
                        Spacer(),
                        Spacer(),
                        Text(
                          "Kegel Exercises",
                          textAlign: TextAlign.center,
                          style: Theme.of(this.context)
                              .textTheme
                              .title
                              .copyWith(fontSize: 15),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
  }





