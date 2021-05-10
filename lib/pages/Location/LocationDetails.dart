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
import 'package:sidebar_animation/Models/Locationdetails.dart';
import 'package:sidebar_animation/Models/Sensor.dart';
import 'package:sidebar_animation/Models/User.dart';
import 'package:sidebar_animation/Services/DataHelpers.dart';
import 'package:sidebar_animation/classes/ChartHistory.dart';
import 'package:sidebar_animation/classes/ElectrovanneClass.dart';
import 'package:sidebar_animation/classes/WeatherClass.dart';
import 'package:sidebar_animation/classes/schedulePage.dart';
import 'package:sidebar_animation/pages/homepage.dart';
import 'package:sidebar_animation/sidebar/sidebar_layout.dart';
import 'package:sidebar_animation/constants.dart';
import 'package:sidebar_animation/graphic.dart' as graphic;
import 'package:flutter/gestures.dart';
import 'package:sidebar_animation/bloc.navigation_bloc/navigation_bloc.dart';

class LocationDetails extends StatefulWidget with NavigationStates {
  LocationDetails({Key key, this.title, this.identifier}) : super(key: key);
  final String title;
  String identifier;

  @override
  LocationDetailsState createState() => LocationDetailsState();
}

class LocationDetailsState extends State<LocationDetails> {
  String id;
  String sensId;
  String IdSens;
  bool status;
  List<String> sens;
  Sensor Solsens;
  DatabaseHelper2 databaseHelper2 = new DatabaseHelper2();
  final RoundedLoadingButtonController _btnController =
  new RoundedLoadingButtonController();
  List<dynamic> sensors = [];
  Future<Locationdetails> getLocationdetails;
  Future<int> getSensNum;
  Future<int> getLocNum;
 // Future<Locationsoldetails> getLocationsoldetails;

  @override
  void initState() {
    getLocationdetails = databaseHelper2.getLocationsdetailsByid(widget.identifier);
    getSensNum = databaseHelper2.NumberofDeviceByUser();
    getLocNum = databaseHelper2.NumberofLocationByUser();
    //getLocationsoldetails = databaseHelper2.getLocationssoldetailsByid(widget.identifier);

    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    MediaQueryData queryData;
    queryData = MediaQuery.of(context);
    var hour = DateTime.now().hour;
    return new Scaffold(
        backgroundColor: Colors.grey[200],
        body: ListView(
          scrollDirection: Axis.vertical,
          children: <Widget>[
            Container(
              width: queryData.size.width,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    new IconButton(
                      icon: new Icon(Icons.arrow_back, color: Colors.black,size: 30,),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    Container(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(10, 0, 0, 25),
                        child: Row(
                          children: <Widget>[
                            Container(
                              width: queryData.size.width - 100,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  FutureBuilder<Location>(
//                future: databaseHelper.getData(),
                                      future: databaseHelper2.getLocationByid(widget.identifier),
                                      builder: (context, snapshot) {
                                        if (snapshot.hasError) {
                                          print(snapshot.error);
                                          print("mochkla lenaa last *");
                                        }
                                        if (snapshot.hasData) {
                                          Location location = snapshot.data;
                                          id = snapshot.data.id;
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
                                          print("mochkla lenaa *");
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
                              padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
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
            ),
            FutureBuilder<Location>(
                future: databaseHelper2.getLocationByid(widget.identifier),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    print(snapshot.error);
                    Container();
                  }
                  if (snapshot.hasData) {
                    return FutureBuilder(
                        future: databaseHelper2.Getweather(snapshot.data.id),
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
                    print("there is problem !");
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
                            padding:
                            const EdgeInsets.fromLTRB(15, 0, 20, 0),
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
                    print("there is problem !");
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
                            padding:
                            const EdgeInsets.fromLTRB(15, 0, 20, 0),
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
                            "TOTAL NUMBER OF STIES: " +
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
            FutureBuilder<Locationdetails>(
                future: getLocationdetails,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    print(snapshot.error);
                    print("there is problem sol!");
                    return Container(
                      child: Text("hello"),
                    );
                  }
                  if(snapshot.hasData){
                    snapshot.data.location.sensorIds.forEach((element) {
                       IdSens = element;
                    });
                    return FutureBuilder<Sensor>(
//
                        future: databaseHelper2.getSolDeviceById(IdSens),
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            print(snapshot.error);
                            print("mochkla lenaa *");
                          }
                          if (snapshot.hasData) {
                    snapshot.data.rules.forEach((element) {
                      status = element.status;
                    });
                    if (status == true){
                      // print("status:"+status.toString());
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
                                padding: const EdgeInsets.fromLTRB(15, 0, 20, 0),
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
                                    height: 20.0, // height of the button
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
                                        fontSize: 16,color: Colors.green
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    }
                    else
                      //  print("status:"+status.toString());
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
                                padding: const EdgeInsets.fromLTRB(15, 0, 20, 0),
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
                                    height: 20.0, // height of the button
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
                                        fontSize: 16,color: Colors.red
                                    ),
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
                        });
                  } else {
                    return Container();
                  }


                }),

            FutureBuilder<Locationdetails>(
                future: getLocationdetails,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    snapshot.data.location.sensorIds.forEach((element) {
                      sensId = element;
                      print("element: "+element);
                    });
                    return FutureBuilder<Sensor>(
                        future: databaseHelper2.getSolDeviceById(sensId),
                        builder: (context, snapshot2) {
                          if (snapshot2.hasError) {
                            print(snapshot2.error);
                            print("mochkla lenaa button schedule*");
                          }
                          if (snapshot2.hasData) {
                            print("sensdata: "+snapshot2.data.toString());
                            return Padding(
                              padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.0),
                                    color: Colors.white
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(0, 15, 0, 5),
                                      child: Container(
                                        height: 60,
                                        width: 350,
                                        child: FlatButton(
                                          child: Text("SCHEDULE",
                                            style: TextStyle(
                                              fontSize: 20,
                                              color: Colors.blue[600],
                                            ),),
                                          onPressed: (){
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        schedulePage(
                                                            sens: snapshot2.data,
                                                            location: snapshot.data.location,
                                                            Electro: snapshot.data.electro
                                                        )));
                                          },
                                          shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(30.0),
                                              side: BorderSide(color: Colors.blue[300],width: 1.5)

                                          ),
                                          color: Colors.blue[100],
                                          splashColor: Colors.blue[300],
                                          textColor: Colors.black,
                                        ),

                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 8),
                                      child: Text(
                                        "You can controle when to irrigate your land based on our AI or you can Schedule it by yourself.",
                                        style: TextStyle(
                                            fontSize: 10,
                                            color: Colors.grey[600],
                                            fontWeight: FontWeight.w400
                                        ),
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


            FutureBuilder<Locationdetails>(
//                future: databaseHelper.getData(),
                future: getLocationdetails,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    print(snapshot.error);
                    print("mochkla lenaa chart *");
                  }
                  if (snapshot.hasData) {
                    print(snapshot.data.toString());
                    return ItemListchart(list: snapshot.data.location.sensorIds);
                  } else {
                    return Container();
                  }
                }),

            FutureBuilder<Locationdetails>(
//                future: databaseHelper.getData(),
                future: getLocationdetails,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ElectrovanneClass(list: snapshot.data.electro);
                  } else {
                    return Container();
                  }
                }),
          ],
        ),
      );

  }
}
