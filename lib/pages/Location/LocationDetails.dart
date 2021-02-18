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
import 'package:sidebar_animation/Services/DataHelpers.dart';
import 'package:sidebar_animation/pages/homepage.dart';
import 'package:sidebar_animation/sidebar/sidebar_layout.dart';
import 'package:sidebar_animation/constants.dart';

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
  DatabaseHelper2 databaseHelper2 = new DatabaseHelper2();
  final RoundedLoadingButtonController _btnController =
  new RoundedLoadingButtonController();
  String identifier;
  List<dynamic> Sensors =[];
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    identifier = widget.identifier;
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
                            FutureBuilder<Location>(
//                future: databaseHelper.getData(),
                                future: databaseHelper2.getLocationByid(identifier),
                                builder: (context, snapshot) {
                                  if (snapshot.hasError) {
                                    print(snapshot.error);
                                    print("mochkla lenaa electro *");
                                  }
                                  return snapshot.hasData
                                      ?  Text(
                                    snapshot.data.siteName,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 30.0,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontStyle: FontStyle.normal,
                                    ),
                                  )
                                      : Text(
                                    "",
                                    style:TextStyle(
                                      backgroundColor: Colors.transparent,
                                    ),
                                  );
                                }
                            ),
                            Text(
                              'Home' + hour.toString(),
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

                    FutureBuilder(
                    future: databaseHelper2.Getweather(identifier),
                    builder: (context, snapshot2) {
                      if (snapshot2.hasError) {
                        print(snapshot2.error);
                        Text(
                          "",
                          style:TextStyle(
                            backgroundColor: Colors.transparent,
                          ),
                        );
                      }
                      return snapshot2.hasData
                          ? Itemclass(list: snapshot2.data)
                          : Text(
                        "",
                        style:TextStyle(
                          backgroundColor: Colors.transparent,
                        ),
                      );
                    }),

          Container(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
            ),
          ),


          FutureBuilder(
//                future: databaseHelper.getData(),
              future: databaseHelper2.AllElectoByUser(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  print(snapshot.error);
                  print("mochkla lenaa electro *");
                }
                return snapshot.hasData
                    ? ItemListElectro(list: snapshot.data)
                    : Text(
                  "",
                  style:TextStyle(
                    backgroundColor: Colors.transparent,
                  ),
                );
              }
          ),

          FutureBuilder<Location>(
//                future: databaseHelper.getData(),
              future: databaseHelper2.getLocationByid(identifier),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  snapshot.data.sensorIds.forEach((element) {
                    Sensors.add(element);
                  });
                  }
                return ListView.builder(
                    itemCount: Sensors == null ? 0 : Sensors.length,
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemBuilder: (context, i) {
                      return Column(
                        children: <Widget>[
                          Row(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(left: 14),
                                child: Text(
                                  'Device name is ',
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(right: 44),
                                child: Text(
                                  //list[i].toString() ?? '',
                                  Sensors[i].toString(),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 40,
                          )
                        ],
                      );
                    });
              }),
        ],
      ),
    );
  }


  Widget _buildProgrammCard() {
    return Container(
      height: 90,
      child: Card(
        semanticContainer: true,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        elevation: 4,
        margin: EdgeInsets.fromLTRB(14, 0, 14, 14),
        child: FutureBuilder(
//                future: databaseHelper.getData(),
            future: databaseHelper2.Lastlocation(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                print(snapshot.error);
                print("mochkla lenaa last *");
              }
              return snapshot.hasData
                  ? Text("Location :" + snapshot.data.siteName)
                  : Text(
                "",
                style:TextStyle(
                  backgroundColor: Colors.transparent,
                ),
              );
            }),
      ),
    );
  }

  Widget Itemclass({List list}) {

    var hour = DateTime.now().hour;
    //  final hour formattedDate = DateFormat.j().format(now);
    dynamic currentTime = DateFormat.j().format(DateTime.now());
    return SizedBox(
      height: 270.0,
      child: ListView.builder(
          itemCount: list.length,
          scrollDirection: Axis.horizontal,
          itemExtent: 200.0,
          // ignore: missing_return
          itemBuilder: (context, i) {
            var item = list[i];
            if ((hour < 18) && (hour >= 6)) {
              return Padding(
                padding: const EdgeInsets.fromLTRB(10, 0, 5, 0),
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      gradient: LinearGradient(
                          begin: Alignment.bottomLeft,
                          end: Alignment.topRight,
                          colors: [
                            Colors.blue[600],
                            Colors.blue,
                            Colors.blue[200]
                          ])),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: [
                          if (list[i]["pop"] > 0.1)
                            new Image.network(
                                'https://www.dovora.com/resources/weather-icons/showcase/modern_showcase/rain.png'),
                          if (list[i]["clouds"] > 0 && list[i]["pop"] < 0.1)
                            new Image.network(
                                'https://www.dovora.com/resources/weather-icons/showcase/modern_showcase/overcast.png'),
                          if (list[i]["pop"] == 0 && list[i]["clouds"] == 0)
                            new Image.network(
                                'https://www.dovora.com/resources/weather-icons/showcase/modern_showcase/day_clear.png'),
                          Text(
                            list[i]["temp"]["day"].round().toString() + "°C",
                            style: TextStyle(color: Colors.black),
                          )
                        ],
                      ),
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(3.0),
                            child: Text(
                              list[i]["temp"]["min"].round().toString() + "/",
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                          Text(
                            list[i]["temp"]["max"].round().toString() + "°C",
                            style: TextStyle(color: Colors.black),
                          )
                        ],
                      ),
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(3.0),
                            child: Text(
                              "humidity:",
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                          Text(
                            list[i]["humidity"].toString() + "%",
                            style: TextStyle(color: Colors.black),
                          )
                        ],
                      ),
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(3.0),
                            child: Text(
                              "Precipitation:",
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                          Text(
                            list[i]["pop"].toString() + "mm",
                            style: TextStyle(color: Colors.black),
                          )
                        ],
                      ),
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(3.0),
                            child: Text(
                              "Uv:",
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                          Text(
                            list[i]["uvi"].toString(),
                            style: TextStyle(color: Colors.black),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              );
            }
            {
              return Padding(
                padding: const EdgeInsets.fromLTRB(10, 0, 5, 0),
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      gradient: LinearGradient(
                          begin: Alignment.bottomLeft,
                          end: Alignment.topRight,
                          colors: [
                            Colors.black,
                            Colors.white10,
                            Colors.white12
                          ])),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: [
                          if (list[i]["pop"] > 0.1)
                            new Image.network(
                                'https://www.dovora.com/resources/weather-icons/showcase/modern_showcase/rain.png'),
                          if (list[i]["clouds"] > 0 && list[i]["pop"] < 0.1)
                            new Image.network(
                                'https://www.dovora.com/resources/weather-icons/showcase/modern_showcase/overcast.png'),
                          if (list[i]["pop"] == 0 && list[i]["clouds"] == 0)
                            new Image.network(
                                'https://www.dovora.com/resources/weather-icons/showcase/modern_showcase/day_clear.png'),
                          Text(
                            list[i]["temp"]["day"].round().toString() + "°C",
                            style: TextStyle(color: Colors.black),
                          )
                        ],
                      ),
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(3.0),
                            child: Text(
                              list[i]["temp"]["min"].round().toString() + "/",
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                          Text(
                            list[i]["temp"]["max"].round().toString() + "°C",
                            style: TextStyle(color: Colors.black),
                          )
                        ],
                      ),
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(3.0),
                            child: Text(
                              "humidity:",
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                          Text(
                            list[i]["humidity"].toString() + "%",
                            style: TextStyle(color: Colors.black),
                          )
                        ],
                      ),
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(3.0),
                            child: Text(
                              "Precipitation:",
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                          Text(
                            list[i]["pop"].toString() + "mm",
                            style: TextStyle(color: Colors.black),
                          )
                        ],
                      ),
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(3.0),
                            child: Text(
                              "Uv:",
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                          Text(
                            list[i]["uvi"].toString(),
                            style: TextStyle(color: Colors.black),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              );
            }
          }),
    );
  }

}


class ItemListElectro extends StatefulWidget {
  List list;
  ItemListElectro({this.list});

  @override
  _ItemListElectroState createState() => _ItemListElectroState();
}

class _ItemListElectroState extends State<ItemListElectro> {
  String id;
  String status;
  String active = "true";
  final RoundedLoadingButtonController _btnController =
  new RoundedLoadingButtonController();

  ScrollController _controller = new ScrollController();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 270.0,
      child: ListView.builder(
          itemCount: widget.list == null ? 0 : widget.list.length,
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemBuilder: (context, i) {

            id = widget.list[i]["_id"].toString();
            return Column(
              children: <Widget>[
                Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 14),
                      child: Text(
                        'Device name is ',
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(right: 44),
                      child: Text(
                        //list[i].toString() ?? '',
                        widget.list[i]["name"].toString(),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(right: 44),
                      child:Text(
                        status = widget.list[i]["status"].toString(),
                      ),
                    ),
                    Container(
                      height: 50,
                      width: 100,
                      child: AspectRatio(
                        child: RoundedLoadingButton(
                          color: Colors.amberAccent,
                          child: Text("Login",
                              style: TextStyle(color: Colors.white)),
                          onPressed: () {
                            print("hihih"+status);
                            status = widget.list[i]["status"].toString();
                            _doSomething();

                            setState(() {
                              Navigator.push(
                                  context, MaterialPageRoute(builder: (context) => MyHomePage()));
                            });
                          },
                          controller: _btnController,
                        ),
                        aspectRatio: 8,
                      ),
                    ),
                  ],
                ),
              ],
            );
          }),
    );
  }
/*
isactive =false;

  isactive=!isactive;
*/

  void _doSomething() async {
    Timer(Duration(seconds: 1), () {
      print("button pressed ");
      print("stauts"+status);
      print("id"+id);
      if(status == "true"){
        status = "false";
        On(id);
        _btnController.stop();
      }
      else if(status == "false"){
        status = "true";
        print("offfff");
        Off(id);
        _btnController.stop();
      }
      _btnController.stop();
    }
    );
  }

  On(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'token';
    final value = prefs.get(key) ?? 0;
    Map data = {'status': 01, 'SensorId': "$id"};
    var jsonResponse = null;
    var response = await http.post(DatabaseHelper2.serverUrl + "/dashboard/onoff?token=" + value,
        headers: {"Content-Type": "application/json"},
//        "http://192.168.56.81:3000/api/users/login",
        body: json.encode(data));
    print('statusCode  :' + response.statusCode.toString());
    if (response.statusCode == 200) {
      jsonResponse = json.decode(response.body);
    }
    print(response.body);
  }

  Off(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'token';
    final value = prefs.get(key) ?? 0;
    Map data = {'status': 00, 'SensorId': "$id"};
    var jsonResponse = null;
    var response = await http.post(DatabaseHelper2.serverUrl + "/dashboard/onoff?token=" + value,
        headers: {"Content-Type": "application/json"},
//        "http://192.168.56.81:3000/api/users/login",
        body: json.encode(data));
    print('statusCode  :' + response.statusCode.toString());
    if (response.statusCode == 200) {
      jsonResponse = json.decode(response.body);
    }
    print(response.body);
  }
}


