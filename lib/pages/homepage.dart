import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sidebar_animation/Models/Location.dart';
import 'package:sidebar_animation/Models/LocationHome.dart';
import 'package:sidebar_animation/Models/Sensor.dart';
import 'package:sidebar_animation/Models/User.dart';
import 'package:sidebar_animation/Services/DataHelpers.dart';
import 'package:sidebar_animation/classes/ChartHistory.dart';
import 'package:sidebar_animation/classes/ChartLineClass.dart';
import 'package:sidebar_animation/classes/ElectroONOFFClass.dart';
import 'package:sidebar_animation/classes/ElectrovanneClass.dart';
import 'package:sidebar_animation/classes/WeatherClass.dart';
import 'package:sidebar_animation/classes/schedulePage.dart';
import 'package:sidebar_animation/pages/Device/AddDevice.dart';
import 'package:sidebar_animation/pages/Device/Devices.dart';
import 'package:sidebar_animation/pages/Device/VerfiyDevice.dart';
import 'package:sidebar_animation/pages/Location/AddLocation.dart';
import 'package:sidebar_animation/pages/Location/AllLocations.dart';
import 'package:sidebar_animation/sidebar/sidebar_layout.dart';
import '../bloc.navigation_bloc/navigation_bloc.dart';
import 'package:sidebar_animation/constants.dart';
import 'package:sidebar_animation/graphic.dart' as graphic;
import 'package:flutter/gestures.dart';
import 'package:sidebar_animation/bloc.navigation_bloc/navigation_bloc.dart';

class MyHomePage extends StatefulWidget with NavigationStates {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String id;
  String sensId;
  bool status;
  List<String> sens;
  Sensor Solsens;
  Sensor Electro;
  DatabaseHelper2 databaseHelper2 = new DatabaseHelper2();
  final RoundedLoadingButtonController _btnController =
      new RoundedLoadingButtonController();
  List<dynamic> sensors = [];
  Future<LocationHome> getHomedetails;
  Future<int> getSensNum;
  Future<int> getLocNum;
  void _onValueChange(String value) {
    setState(() {
      _selectedId = value;
    });
  }

  String _selectedId;

  @override
  void initState() {
    getHomedetails = databaseHelper2.getHomedetails();
    getSensNum = databaseHelper2.NumberofDeviceByUser();
    getLocNum = databaseHelper2.NumberofLocationByUser();

    super.initState();
  }

  Future<bool> _onWillPop() async {
    return (await showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            title: new Text('Are you sure?'),
            content: new Text('Do you want to exit the App'),
            actions: <Widget>[
              new FlatButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: new Text('No'),
              ),
              new FlatButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: new Text('Yes'),
              ),
            ],
          ),
        )) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    var hour = DateTime.now().hour;
    return new WillPopScope(
      onWillPop: _onWillPop,
      child: new Scaffold(
        backgroundColor: Colors.grey[200],
        body: FutureBuilder<List>(
//                future: databaseHelper.getData(),
            future: databaseHelper2.AllLocationByUser(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                print(snapshot.error);
                print("mochkla lenaa last *");
              }
              if (snapshot.hasData) {
                if (snapshot.data.isEmpty) {
                  return AlertDialog(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0))),
                    contentPadding: EdgeInsets.only(top: 10.0),
                    content: Container(
                      height: 220,
                      width: 400,
                      child: Column(
                        children: [
                          Icon(
                            Icons.info_outline,
                            color: Colors.amber,
                            size: 50,
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                            child: Text(
                              "WELCOME TO XTREE",
                              style: TextStyle(
                                  fontSize: 22, fontWeight: FontWeight.w500),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                            child: Text(
                              "FIRST STEP",
                              style: TextStyle(
                                  fontSize: 22, fontWeight: FontWeight.w400),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                            child: Text(
                              "You have to add a new location !",
                              style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.grey),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                            child: FlatButton(
                              onPressed: () {
                                showDialog(
                                    context: context,
                                    child: AddLocation(
                                      onValueChange: _onValueChange,
                                      initialValue: _selectedId,
                                    ));
                              }, // passing true
                              child: Text(
                                'ADD NEW LOCATION',
                                style:
                                    TextStyle(color: Colors.blue, fontSize: 20),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }
                return ListView(
                  scrollDirection: Axis.vertical,
                  children: <Widget>[
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(10, 50, 0, 25),
                              child: Row(
                                children: <Widget>[
                                  Container(
                                    width: 365,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        FutureBuilder<LocationHome>(
//                future: databaseHelper.getData(),
                                            future: getHomedetails,
                                            builder: (context, snapshot) {
                                              if (snapshot.hasError) {
                                                print(snapshot.error);
                                                print("mochkla lenaa Home location *");
                                              }
                                              if (snapshot.hasData) {
                                                Location location =
                                                    snapshot.data.locations;
                                                id = snapshot.data.locations.id;
                                                return Text(
                                                  location.siteName,
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    fontSize: 30.0,
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.bold,
                                                    fontStyle: FontStyle.normal,
                                                  ),
                                                );
                                              } else {
                                                return Container();
                                              }
                                            }),
                                        FutureBuilder<User>(
//                future: databaseHelper.getData(),
                                            future: databaseHelper2.getUser(),
                                            builder: (context, snapshot) {
                                              if (snapshot.hasError) {
                                                print(snapshot.error);
                                                print("mochkla lenaa user name *");
                                              }
                                              if (snapshot.hasData) {
                                                return Text(
                                                    'Welcome '+snapshot.data.firstName+' '+snapshot.data.lastName,
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      fontSize: 15.0,
                                                      color: Colors.grey,
                                                      fontWeight:
                                                      FontWeight.w500,
                                                      fontStyle:
                                                      FontStyle.normal,
                                                    ));
                                              } else {
                                                return Container();
                                              }
                                            }),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 0, 0, 0),
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
                        ]),
                    FutureBuilder<LocationHome>(
                        future: getHomedetails,
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            print(snapshot.error);
                            Container();
                          }
                          if (snapshot.hasData) {
                            return FutureBuilder(
                                future: databaseHelper2.Getweather(
                                    snapshot.data.locations.id),
                                builder: (context, snapshot2) {
                                  if (snapshot2.hasError) {
                                    print(snapshot2.error);
                                    Container();
                                  }
                                  return snapshot2.hasData
                                      ? WeatherClass(list: snapshot2.data)
                                      : Container();
                                });
                          } else {
                            return Container();
                          }
                        }),
                    Container(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                      ),
                    ),
                    FutureBuilder<int>(
                        future: getSensNum,
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            print(snapshot.error);
                            print("there is problem number of dev!");
                          }

                          return snapshot.hasData
                              ? Container(
                                  height: 80,
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
                                          padding: const EdgeInsets.fromLTRB(
                                              15, 0, 20, 0),
                                          child: CircleAvatar(
                                            backgroundColor: Colors.green,
                                            child: Icon(
                                              Icons.device_hub,
                                              color: Colors.white,
                                            ),
                                            radius: 25,
                                          ),
                                        ),
                                        Text(
                                          "TOTAL NUMBER OF DEVICES: " +
                                              snapshot.data.toString(),
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              : Container();
                        }),
                    FutureBuilder<int>(
                        future: getLocNum,
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            print(snapshot.error);
                            print("there is problem num of loc !");
                          }

                          return snapshot.hasData
                              ? Container(
                                  height: 80,
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
                                          padding: const EdgeInsets.fromLTRB(
                                              15, 0, 20, 0),
                                          child: CircleAvatar(
                                            backgroundColor: Colors.red,
                                            child: Icon(
                                              Icons.place,
                                              color: Colors.white,
                                            ),
                                            radius: 25,
                                          ),
                                        ),
                                        Text(
                                          "TOTAL NUMBER OF SITES: " +
                                              snapshot.data.toString(),
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              : Container();
                        }),
                    FutureBuilder<LocationHome>(
                        future: getHomedetails,
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            print(snapshot.error);
                            print("there is problem schedule !");
                          }

                          if (snapshot.hasData) {
                            if (snapshot.data.sensors.isEmpty) {
                              return Column(
                                children: [
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 15, 0, 10),
                                    child: Icon(
                                      Icons.info_outline,
                                      color: Colors.amber,
                                      size: 50,
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 0, 0, 0),
                                    child: Text(
                                      "SECOND STEP",
                                      style: TextStyle(
                                          fontSize: 22,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 0, 0, 0),
                                    child: Text(
                                      "You have to add a new device to this location !",
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.grey),
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 20, 0, 0),
                                    child: FlatButton(
                                      onPressed: () {
                                        showDialog(
                                            context: context,
                                            child: VerfiyDevice(
                                              onValueChange: _onValueChange,
                                              initialValue: _selectedId,
                                            ));
                                      }, // passing true
                                      child: Text(
                                        'Add New Device',
                                        style: TextStyle(
                                            color: Colors.blue, fontSize: 20),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            }
                            if (snapshot.data.sol != null) {
                              snapshot.data.sol.rules.forEach((element) {
                                status = element.status;
                              });
                            }

                            if (status == true) {
                              return Container(
                                height: 80,
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
                                        padding: const EdgeInsets.fromLTRB(
                                            15, 0, 20, 0),
                                        child: CircleAvatar(
                                          backgroundColor: Colors.amber,
                                          child: Icon(
                                            Icons.schedule,
                                            color: Colors.white,
                                          ),
                                          radius: 25,
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            "SCHEDULES STATE:    ",
                                            style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 16,
                                            ),
                                          ),
                                          Container(
                                            //color: Colors.green,
                                            height:
                                                20.0, // height of the button
                                            width: 20.0, // width of the button
                                            decoration: BoxDecoration(
                                                color: Colors.green,
                                                border: Border.all(
                                                    color: Colors.grey[350],
                                                    width: 3.0,
                                                    style: BorderStyle.solid),
                                                shape: BoxShape.circle),
                                          ),
                                          Text(
                                            "  ACTIVE",
                                            style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 16,
                                                color: Colors.green),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            } else
                              return Container(
                                height: 80,
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
                                        padding: const EdgeInsets.fromLTRB(
                                            15, 0, 20, 0),
                                        child: CircleAvatar(
                                          backgroundColor: Colors.amber,
                                          child: Icon(
                                            Icons.schedule,
                                            color: Colors.white,
                                          ),
                                          radius: 25,
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            "SCHEDULES STATE:    ",
                                            style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 16,
                                            ),
                                          ),
                                          Container(
                                            //color: Colors.green,
                                            height:
                                                20.0, // height of the button
                                            width: 20.0, // width of the button
                                            decoration: BoxDecoration(
                                                color: Colors.red,
                                                border: Border.all(
                                                    color: Colors.grey[350],
                                                    width: 3.0,
                                                    style: BorderStyle.solid),
                                                shape: BoxShape.circle),
                                          ),
                                          Text(
                                            "  INACTIVE",
                                            style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 16,
                                                color: Colors.red),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                          } else {
                            return Container();
                          }
                        }),
                    FutureBuilder<LocationHome>(
                        future: getHomedetails,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            snapshot.data.locations.sensorIds
                                .forEach((element) {
                              sensId = element;
                            });
                            return FutureBuilder<Sensor>(
                                future:
                                    databaseHelper2.getSolDeviceById(sensId),
                                builder: (context, snapshot2) {
                                  if (snapshot2.hasError) {
                                    print(snapshot2.error);
                                    print("mochkla lenaa *");
                                  }
                                  if (snapshot2.hasData) {
                                    return Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          10, 10, 10, 10),
                                      child: Container(
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                            color: Colors.white),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      0, 15, 0, 5),
                                              child: Container(
                                                height: 60,
                                                width: 350,
                                                child: FlatButton(
                                                  child: Text(
                                                    "SCHEDULE",
                                                    style: TextStyle(
                                                      fontSize: 20,
                                                      color: Colors.blue[600],
                                                    ),
                                                  ),
                                                  onPressed: () {
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) => schedulePage(
                                                                sens: snapshot2
                                                                    .data,
                                                                location: snapshot
                                                                    .data
                                                                    .locations,
                                                                Electro: snapshot
                                                                    .data
                                                                    .electro)));
                                                  },
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              30.0),
                                                      side: BorderSide(
                                                          color:
                                                              Colors.blue[300],
                                                          width: 1.5)),
                                                  color: Colors.blue[100],
                                                  splashColor: Colors.blue[300],
                                                  textColor: Colors.black,
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      0, 0, 0, 8),
                                              child: Text(
                                                "You can controle when to irrigate your land based on our AI or you can Schedule it by yourself.",
                                                style: TextStyle(
                                                    fontSize: 10,
                                                    color: Colors.grey[600],
                                                    fontWeight:
                                                        FontWeight.w400),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  } else {
                                    return Container();
                                  }
                                });
                          } else {
                            return Container();
                          }
                        }),
                    FutureBuilder<LocationHome>(
//                future: databaseHelper.getData(),
                        future: getHomedetails,
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            print(snapshot.error);
                            print("mochkla lenaa *");
                          }
                          if (snapshot.hasData) {
                            return ItemListchart(
                                list: snapshot.data.locations.sensorIds);
                          } else {
                            return Container();
                          }
                        }),
                    FutureBuilder<LocationHome>(
//                future: databaseHelper.getData(),
                        future: getHomedetails,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return ElectrovanneClass(
                                list: snapshot.data.electro);
                          } else {
                            return Container();
                          }
                        }),
                  ],
                );
              } else {
                return Container();
              }
            }),
      ),
    );
  }
}

class ItemListchart extends StatefulWidget {
  List list;
  ItemListchart({this.list});

  @override
  _ItemListchartState createState() => _ItemListchartState();
}

class _ItemListchartState extends State<ItemListchart> {
  DatabaseHelper2 databaseHelper2 = new DatabaseHelper2();
  void _onValueChange(String value) {
    setState(() {
      _selectedId = value;
    });
  }

  String _selectedId;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: widget.list.length,
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemBuilder: (context, i) {
//            DateTime t = DateTime.parse(list[i]['date_published'].toString());

          return FutureBuilder<Sensor>(
              future: databaseHelper2.getDevById(widget.list[i].toString()),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  print(snapshot.error);
                  print("there is problem !");
                }

                if (snapshot.hasData) {
                  String type = snapshot.data.sensorType;
                  if (type != "Relay") {
                    return Padding(
                      padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            color: Colors.white),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              height: 90,
                              child: Card(
                                semanticContainer: true,
                                clipBehavior: Clip.antiAliasWithSaveLayer,
                                color: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                                elevation: 0,
                                child: Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          10, 0, 0, 0),
                                      child: Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            0, 0, 10, 0),
                                        child: CircleAvatar(
                                          radius: 25,
                                          backgroundColor: Colors.lightBlue,
                                          child: IconButton(
                                            icon: Icon(Icons.history),
                                            color: Colors.white,
                                            iconSize: 30,
                                            onPressed: () {
                                              showDialog(
                                                  context: context,
                                                  child: ChartHistory(
                                                    onValueChange:
                                                        _onValueChange,
                                                    initialValue: _selectedId,
                                                    identifier:
                                                        snapshot.data.id,
                                                    type: snapshot
                                                        .data.sensorType,
                                                    name: snapshot.data.name,
                                                  ));
                                            },
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          0, 15, 0, 0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            snapshot.data.name.toString(),
                                            style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 20,
                                            ),
                                          ),
                                          Text(
                                            "Identifier: " +
                                                snapshot.data.sensorIdentifier
                                                    .toString(),
                                            style: TextStyle(
                                              color: Colors.grey,
                                              fontWeight: FontWeight.w400,
                                              fontSize: 11,
                                            ),
                                          ),
                                          Text(
                                            "Type: " +
                                                snapshot.data.sensorType
                                                    .toString(),
                                            style: TextStyle(
                                              color: Colors.grey,
                                              fontWeight: FontWeight.w400,
                                              fontSize: 11,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            FutureBuilder(
                                future: databaseHelper2
                                    .getdataDeviceByID(snapshot.data.id),
                                builder: (context, snapshot2) {
                                  if (snapshot2.hasError) {
                                    print(snapshot2.error);
                                    Text(
                                      "",
                                      style: TextStyle(
                                        backgroundColor: Colors.transparent,
                                      ),
                                    );
                                  }
                                  if (snapshot2.hasData) {
                                    return Column(
                                      children: [
                                        ChartLineClass(
                                            data: snapshot2.data, type: type),
                                        Container(
                                          height: 90,
                                          child: Card(
                                            semanticContainer: true,
                                            clipBehavior:
                                                Clip.antiAliasWithSaveLayer,
                                            color: Colors.white,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20.0),
                                            ),
                                            elevation: 0,
                                            child: Row(
                                              children: [
                                                Container(
                                                  height: 60,
                                                  child: CircleAvatar(
                                                    backgroundColor:
                                                        Colors.white,
                                                    child: Icon(
                                                      Icons
                                                          .battery_charging_full,
                                                      color: Colors.amberAccent,
                                                      size: 30,
                                                    ),
                                                    radius: 28,
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          0, 0, 20, 0),
                                                  child: Text(
                                                    snapshot2.data[snapshot2
                                                                    .data
                                                                    .length -
                                                                1]["batterie"]
                                                            .round()
                                                            .toString() +
                                                        "%",
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 18,
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                  height: 60,
                                                  child: CircleAvatar(
                                                    backgroundColor:
                                                        Colors.white,
                                                    child: Icon(
                                                      Icons
                                                          .signal_cellular_4_bar,
                                                      color: Colors.redAccent,
                                                      size: 30,
                                                    ),
                                                    radius: 28,
                                                  ),
                                                ),
                                                Text(
                                                  "50%",
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 18,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
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
                return Container();
              });
        });
  }
}
