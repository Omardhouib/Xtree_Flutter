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
import 'package:sidebar_animation/Services/DataHelpers.dart';
import 'package:sidebar_animation/classes/ChartHistory.dart';
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
  DatabaseHelper2 databaseHelper2 = new DatabaseHelper2();
  final RoundedLoadingButtonController _btnController =
      new RoundedLoadingButtonController();
  List<dynamic> sensors = [];
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var hour = DateTime.now().hour;
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: ListView(
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
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            FutureBuilder<List<Location>>(
//                future: databaseHelper.getData(),
                                future: databaseHelper2.AllLocationByUser(),
                                builder: (context, snapshot) {
                                  if (snapshot.hasError) {
                                    print(snapshot.error);
                                    print("mochkla lenaa last *");
                                  }
                                  if (snapshot.hasData) {
                                    Location location = snapshot.data[0];
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
                            backgroundColor: Colors.grey,
                            child: Icon(
                              Icons.perm_identity,
                              color: Colors.white,
                            ),
                            radius: 33,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ]),
          FutureBuilder(
              future: databaseHelper2.Lastlocation(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  print(snapshot.error);
                  print("there is problem !");
                }

                return snapshot.hasData
                    ? FutureBuilder(
                        future: databaseHelper2.Getweather(snapshot.data.id),
                        builder: (context, snapshot2) {
                          if (snapshot2.hasError) {
                            print(snapshot2.error);
                            Container();
                          }
                          return snapshot2.hasData
                              ? Itemclass(list: snapshot2.data)
                              : Container();
                        })
                    : Container();
              }),
          Container(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
            ),
          ),
          FutureBuilder<int>(
              future: databaseHelper2.NumberofDeviceByUser(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  print(snapshot.error);
                  print("there is problem !");
                }

                return snapshot.hasData
                    ? Container(
                        height: 90,
                        child: Card(
                          semanticContainer: true,
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          elevation: 5,
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
                                "Total number of devices: " +
                                    snapshot.data.toString(),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
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
              future: databaseHelper2.NumberofLocationByUser(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  print(snapshot.error);
                  print("there is problem !");
                }

                return snapshot.hasData
                    ? Container(
                        height: 90,
                        child: Card(
                          semanticContainer: true,
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          elevation: 5,
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
                                "Total number of locations: " +
                                    snapshot.data.toString(),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    : Container();
              }),
          Container(
            height: 90,
            child: Card(
              semanticContainer: true,
              clipBehavior: Clip.antiAliasWithSaveLayer,
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
              elevation: 5,
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
                  Text(
                    "Total number of SCHEDULES: 0",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ),
         /* Container(
            height: 100,
            child: Card(
              semanticContainer: true,
              clipBehavior: Clip.antiAliasWithSaveLayer,
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
              elevation: 5,
              margin: EdgeInsets.fromLTRB(10, 0, 10, 10),
              child:  Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                    child: Row(
                      children: [
                        Container(
                          width: 40.0,
                          height: 10.0,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(0.0)),
                            color: Colors.green,
                          ),
                        ),
                        Text(
                          "Humidity",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 17,
                          ),
                        ),
                        Container(
                          width: 40.0,
                          height: 10.0,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(0.0)),
                            color: Colors.blue[800],
                          ),
                        ),
                        Text(
                          "Temperature",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 17,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      Container(
                        width: 40.0,
                        height: 10.0,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(0.0)),
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        "Soil temperature",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                        ),
                      ),
                      Container(
                        width: 40.0,
                        height: 10.0,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(0.0)),
                          color: Colors.green,
                        ),
                      ),
                      Text(
                        "Temperature",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),*/
          FutureBuilder<List<Location>>(
//                future: databaseHelper.getData(),
              future: databaseHelper2.AllLocationByUser(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  print(snapshot.error);
                  print("mochkla lenaa *");
                }
                return snapshot.hasData
                    ? ItemListchart(list: snapshot.data[0].sensorIds)
                    : Container();
              }),

          /* FutureBuilder(
//                future: databaseHelper.getData(),
              future: databaseHelper2.AllElectoByUser(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  print(snapshot.error);
                  print("mochkla lenaa electro *");
                }
                return snapshot.hasData
                    ? ItemListElectro(list: snapshot.data)
                    : Container();
              }),*/
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
                      style: TextStyle(
                        backgroundColor: Colors.transparent,
                      ),
                    );
            }),
      ),
    );
  }

  Widget Itemclass({List list}) {
    var hour = DateTime.now().hour;
    DateTime date = DateTime.now();
    String dateFormat = DateFormat('EEEE').format(date);
    //  final hour formattedDate = DateFormat.j().format(now);
    dynamic currentTime = DateFormat.j().format(DateTime.now());
    return SizedBox(
      height: 300.0,
      child: ListView.builder(
          itemCount: 6,
          scrollDirection: Axis.horizontal,
          itemExtent: 200.0,
          // ignore: missing_return
          itemBuilder: (context, i) {
            int date = (list[i]["dt"]);
            int zero = 100;
            DateTime finalday = DateTime.fromMillisecondsSinceEpoch(
                    int.parse(("$date" + "$zero")))
                .toUtc();
            String dateFormat = DateFormat('EEEE').format(finalday);
            var item = list[i];
            if ((hour < 17) && (hour >= 6)) {
              return Padding(
                padding: const EdgeInsets.fromLTRB(10, 0, 5, 0),
                child: Container(
                  /* decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                       image: DecorationImage(
                           image: NetworkImage(
                               "https://www.pngarts.com/files/5/Lines-Transparent-Background-PNG.png"),
                           fit: BoxFit.cover),
                      gradient: LinearGradient(
                          begin: Alignment.bottomLeft,
                          end: Alignment.topRight,
                          colors: [
                            Color(0xff152238),
                            Color(0xff152238),
                            Color(0xff152238),
                          ])),*/
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      image: DecorationImage(
                          image: NetworkImage(
                              "https://images.unsplash.com/photo-1559628376-f3fe5f782a2e?ixlib=rb-1.2.1&ixid=MXwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHw%3D&auto=format&fit=crop&w=1000&q=80"),
                          fit: BoxFit.cover)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.fromLTRB(95, 10, 0, 0),
                        child: Text(
                          list[i]["temp"]["morn"].round().toString() + "°C",
                          style: TextStyle(color: Colors.white, fontSize: 35),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(95, 0, 0, 0),
                        child: Text(
                          dateFormat,
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ),
                      if (list[i]["pop"] > 0.1)
                        Padding(
                          padding: const EdgeInsets.fromLTRB(18, 0, 0, 0),
                          child: SizedBox(
                            width: 100,
                            height: 100,
                            child: new Image.network(
                                'https://www.dovora.com/resources/weather-icons/showcase/modern_showcase/rain.png'),
                          ),
                        ),
                      if (list[i]["clouds"] > 0 && list[i]["pop"] < 0.1)
                        Padding(
                          padding: const EdgeInsets.fromLTRB(18, 0, 0, 0),
                          child: SizedBox(
                            width: 100,
                            height: 100,
                            child: new Image.network(
                                'https://www.dovora.com/resources/weather-icons/showcase/modern_showcase/overcast.png'),
                          ),
                        ),
                      if (list[i]["pop"] < 0.1 && list[i]["clouds"] < 1)
                        Padding(
                          padding: const EdgeInsets.fromLTRB(18, 0, 0, 0),
                          child: SizedBox(
                            width: 100,
                            height: 100,
                            child: new Image.network(
                                'https://www.dovora.com/resources/weather-icons/showcase/modern_showcase/day_clear.png'),
                          ),
                        ),
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(22, 0, 4, 0),
                            child: Text(
                              list[i]["temp"]["min"].round().toString() + "°C",
                              style:
                              TextStyle(color: Colors.white, fontSize: 18),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                            child: Text(
                              "/",
                              style:
                              TextStyle(color: Colors.white, fontSize: 18),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(4, 0, 0, 0),
                            child: Text(
                              list[i]["temp"]["max"].round().toString() + "°C",
                              style:
                              TextStyle(color: Colors.white, fontSize: 18),
                            ),
                          )
                        ],
                      ),
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
                            child: Text(
                              "Humidity: ",
                              style:
                              TextStyle(color: Colors.white, fontSize: 16),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                            child: Text(
                              list[i]["humidity"].toString() + "%",
                              style:
                              TextStyle(color: Colors.white, fontSize: 16),
                            ),
                          )
                        ],
                      ),
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(15, 5, 0, 0),
                            child: Text(
                              "Precipitation:",
                              style:
                              TextStyle(color: Colors.white, fontSize: 16),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                            child: Text(
                              list[i]["pop"].toString() + "mm",
                              style:
                              TextStyle(color: Colors.white, fontSize: 16),
                            ),
                          )
                        ],
                      ),
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(15, 5, 0, 0),
                            child: Text(
                              "Uv:",
                              style:
                              TextStyle(color: Colors.white, fontSize: 16),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                            child: Text(
                              list[i]["uvi"].toString(),
                              style:
                              TextStyle(color: Colors.white, fontSize: 16),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              );
            }
            else if ((hour < 20) && (hour >= 17)) {
              return Padding(
                padding: const EdgeInsets.fromLTRB(10, 0, 5, 0),
                child: Container(
                  /* decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                       image: DecorationImage(
                           image: NetworkImage(
                               "https://www.pngarts.com/files/5/Lines-Transparent-Background-PNG.png"),
                           fit: BoxFit.cover),
                      gradient: LinearGradient(
                          begin: Alignment.bottomLeft,
                          end: Alignment.topRight,
                          colors: [
                            Color(0xff152238),
                            Color(0xff152238),
                            Color(0xff152238),
                          ])),*/
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      image: DecorationImage(
                          image: NetworkImage(
                              "http://avante.biz/wp-content/uploads/Wallpapers-For-Phone-Android/Wallpapers-For-Phone-Android-036.jpg"),
                          fit: BoxFit.cover)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.fromLTRB(95, 10, 0, 0),
                        child: Text(
                          list[i]["temp"]["eve"].round().toString() + "°C",
                          style: TextStyle(color: Colors.white, fontSize: 35),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(95, 0, 0, 0),
                        child: Text(
                          dateFormat,
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ),
                      if (list[i]["pop"] > 0.1)
                        Padding(
                          padding: const EdgeInsets.fromLTRB(18, 0, 0, 0),
                          child: SizedBox(
                            width: 100,
                            height: 100,
                            child: new Image.network(
                                'https://www.dovora.com/resources/weather-icons/showcase/modern_showcase/rain.png'),
                          ),
                        ),
                      if (list[i]["clouds"] > 0 && list[i]["pop"] < 0.1)
                        Padding(
                          padding: const EdgeInsets.fromLTRB(18, 0, 0, 0),
                          child: SizedBox(
                            width: 100,
                            height: 100,
                            child: new Image.network(
                                'https://www.dovora.com/resources/weather-icons/showcase/modern_showcase/overcast.png'),
                          ),
                        ),
                      if (list[i]["pop"] < 0.1 && list[i]["clouds"] < 1)
                        Padding(
                          padding: const EdgeInsets.fromLTRB(18, 0, 0, 0),
                          child: SizedBox(
                            width: 100,
                            height: 100,
                            child: new Image.network(
                                'https://www.dovora.com/resources/weather-icons/showcase/modern_showcase/day_clear.png'),
                          ),
                        ),
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(22, 0, 4, 0),
                            child: Text(
                              list[i]["temp"]["min"].round().toString() + "°C",
                              style:
                              TextStyle(color: Colors.black, fontSize: 18),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                            child: Text(
                              "/",
                              style:
                              TextStyle(color: Colors.black, fontSize: 18),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(4, 0, 0, 0),
                            child: Text(
                              list[i]["temp"]["max"].round().toString() + "°C",
                              style:
                              TextStyle(color: Colors.black, fontSize: 18),
                            ),
                          )
                        ],
                      ),
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
                            child: Text(
                              "Humidity: ",
                              style:
                              TextStyle(color: Colors.black, fontSize: 16),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                            child: Text(
                              list[i]["humidity"].toString() + "%",
                              style:
                              TextStyle(color: Colors.black, fontSize: 16),
                            ),
                          )
                        ],
                      ),
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(15, 5, 0, 0),
                            child: Text(
                              "Precipitation:",
                              style:
                              TextStyle(color: Colors.black, fontSize: 16),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                            child: Text(
                              list[i]["pop"].toString() + "mm",
                              style:
                              TextStyle(color: Colors.black, fontSize: 16),
                            ),
                          )
                        ],
                      ),
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(15, 5, 0, 0),
                            child: Text(
                              "Uv:",
                              style:
                              TextStyle(color: Colors.white, fontSize: 16),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                            child: Text(
                              list[i]["uvi"].toString(),
                              style:
                              TextStyle(color: Colors.white, fontSize: 16),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              );
            } else {
              return Padding(
                padding: const EdgeInsets.fromLTRB(10, 0, 3, 0),
                child: Container(
                  /* decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                       image: DecorationImage(
                           image: NetworkImage(
                               "https://www.pngarts.com/files/5/Lines-Transparent-Background-PNG.png"),
                           fit: BoxFit.cover),
                      gradient: LinearGradient(
                          begin: Alignment.bottomLeft,
                          end: Alignment.topRight,
                          colors: [
                            Color(0xff152238),
                            Color(0xff152238),
                            Color(0xff152238),
                          ])),*/
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      image: DecorationImage(
                          image: NetworkImage(
                              "https://image.freepik.com/free-vector/milky-way-night-star-sky-stars-dark-background_172933-70.jpg"),
                          fit: BoxFit.cover)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.fromLTRB(95, 10, 0, 0),
                        child: Text(
                          list[i]["temp"]["night"].round().toString() + "°C",
                          style: TextStyle(color: Colors.white, fontSize: 35),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(95, 0, 0, 0),
                        child: Text(
                          dateFormat,
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ),
                      if (list[i]["pop"] > 0.1)
                        Padding(
                          padding: const EdgeInsets.fromLTRB(18, 0, 0, 0),
                          child: SizedBox(
                            width: 100,
                            height: 100,
                            child: new Image.network(
                                'https://www.dovora.com/resources/weather-icons/showcase/modern_showcase/rain.png'),
                          ),
                        ),
                      if (list[i]["clouds"] > 0 && list[i]["pop"] < 0.1)
                        Padding(
                          padding: const EdgeInsets.fromLTRB(18, 0, 0, 0),
                          child: SizedBox(
                            width: 100,
                            height: 100,
                            child: new Image.network(
                                'https://www.dovora.com/resources/weather-icons/showcase/modern_showcase/overcast.png'),
                          ),
                        ),
                      if (list[i]["pop"] < 0.1 && list[i]["clouds"] < 1)
                        Padding(
                          padding: const EdgeInsets.fromLTRB(18, 0, 0, 0),
                          child: SizedBox(
                            width: 100,
                            height: 100,
                            child: new Image.network(
                                'https://www.dovora.com/resources/weather-icons/showcase/modern_showcase/day_clear.png'),
                          ),
                        ),
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(22, 0, 4, 0),
                            child: Text(
                              list[i]["temp"]["min"].round().toString() + "°C",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 18),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                            child: Text(
                              "/",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 18),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(4, 0, 0, 0),
                            child: Text(
                              list[i]["temp"]["max"].round().toString() + "°C",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 18),
                            ),
                          )
                        ],
                      ),
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(15, 15, 0, 0),
                            child: Text(
                              "Humidity: ",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                            child: Text(
                              list[i]["humidity"].toString() + "%",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16),
                            ),
                          )
                        ],
                      ),
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(15, 5, 0, 0),
                            child: Text(
                              "Precipitation:",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                            child: Text(
                              list[i]["pop"].toString() + "mm",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16),
                            ),
                          )
                        ],
                      ),
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(15, 5, 0, 0),
                            child: Text(
                              "Uv:",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                            child: Text(
                              list[i]["uvi"].toString(),
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16),
                            ),
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
      height: 100.0,
      child: ListView.builder(
          itemCount: widget.list == null ? 0 : widget.list.length,
          physics: NeverScrollableScrollPhysics(),
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
                      child: Text(
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
                            print("hihih" + status);
                            status = widget.list[i]["status"].toString();
                            _doSomething();

                            setState(() {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => MyHomePage()));
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
      print("stauts" + status);
      print("id" + id);
      if (status == "true") {
        status = "false";
        On(id);
        _btnController.stop();
      } else if (status == "false") {
        status = "true";
        print("offfff");
        Off(id);
        _btnController.stop();
      }
      _btnController.stop();
    });
  }

  On(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'token';
    final value = prefs.get(key) ?? 0;
    Map data = {'status': 01, 'SensorId': "$id"};
    var jsonResponse = null;
    var response = await http.post(
        DatabaseHelper2.serverUrl + "/dashboard/onoff?token=" + value,
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
    var response = await http.post(
        DatabaseHelper2.serverUrl + "/dashboard/onoff?token=" + value,
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

class ItemListchart extends StatefulWidget {
  List list;
  ItemListchart({this.list});

  @override
  _ItemListchartState createState() => _ItemListchartState();
}

class _ItemListchartState extends State<ItemListchart> {
  DatabaseHelper2 databaseHelper2 = new DatabaseHelper2();

  ScrollController _controller = new ScrollController();
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
                  //  print("helloo" + snapshot.data.toString());
                  String type = snapshot.data.sensorType;
                  if (type != "Relay") {
                    return Padding(
                      padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            color: Colors.white),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                          /*  Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                    snapshot.data.name.toString(),
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  ),
                                Padding(
                                  padding:
                                  const EdgeInsets.fromLTRB(140, 10, 0, 0),
                                  child: Container(
                                    height: 60,
                                    child: AspectRatio(
                                      child: FlatButton(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                            BorderRadius.circular(35)),
                                        child: CircleAvatar(
                                          backgroundColor: Colors.lightBlue,
                                          child: Icon(
                                            Icons.history,
                                            color: Colors.white,
                                            size: 30,
                                          ),
                                          radius: 28,
                                        ),
                                        onPressed: () {
                                          showDialog(
                                              context: context,
                                              child: ChartHistory(
                                                onValueChange: _onValueChange,
                                                initialValue: _selectedId,
                                                identifier: snapshot.data.id,
                                                type: snapshot.data.sensorType,
                                              ));
                                        },
                                      ),
                                      aspectRatio: 2,
                                    ),
                                  ),
                                ),

                              ],
                            ),*/

                               /* Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(20, 10, 0, 0),
                                  child: Text(
                                    snapshot.data.name.toString(),
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(80, 10, 0, 0),
                                  child: Container(
                                    height: 60,
                                    child: AspectRatio(
                                      child: FlatButton(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(35)),
                                        child: CircleAvatar(
                                          backgroundColor: Colors.lightBlue,
                                          child: Icon(
                                            Icons.history,
                                            color: Colors.white,
                                            size: 30,
                                          ),
                                          radius: 28,
                                        ),
                                        onPressed: () {
                                          showDialog(
                                              context: context,
                                              child: ChartHistory(
                                                onValueChange: _onValueChange,
                                                initialValue: _selectedId,
                                                identifier: snapshot.data.id,
                                                type: snapshot.data.sensorType,
                                              ));
                                        },
                                      ),
                                      aspectRatio: 2,
                                    ),
                                  ),*/
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
                                            padding:
                                            const EdgeInsets.fromLTRB(0, 0, 0, 0),
                                            child: Container(
                                              height: 60,
                                              child: AspectRatio(
                                                child: FlatButton(
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                      BorderRadius.circular(35)),
                                                  child: CircleAvatar(
                                                    backgroundColor: Colors.lightBlue,
                                                    child: Icon(
                                                      Icons.history,
                                                      color: Colors.white,
                                                      size: 30,
                                                    ),
                                                    radius: 28,
                                                  ),
                                                  onPressed: () {
                                                    showDialog(
                                                        context: context,
                                                        child: ChartHistory(
                                                          onValueChange: _onValueChange,
                                                          initialValue: _selectedId,
                                                          identifier: snapshot.data.id,
                                                          type: snapshot.data.sensorType,
                                                        ));
                                                  },
                                                ),
                                                aspectRatio: 2,
                                              ),
                                            ),
                                          ),
                                          Text(
                                            snapshot.data.name.toString(),
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20,
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
                                    return
                                      Column(
                                        children: [
                                          chart(snapshot2.data, type),
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
                                                  Container(
                                                      height: 60,
                                                      child: CircleAvatar(
                                                        backgroundColor: Colors.white,
                                                        child: Icon(
                                                          Icons.battery_charging_full,
                                                          color: Colors.amberAccent,
                                                          size: 30,
                                                        ),
                                                        radius: 28,
                                                      ),
                                                    ),
                                                  Padding(
                                                    padding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
                                                    child: Text(
                                                      snapshot2.data[snapshot2.data.length-1]["batterie"].round().toString()+"%",
                                                      style: TextStyle(
                                                        fontWeight: FontWeight.bold,
                                                        fontSize: 18,
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                    height: 60,
                                                    child: CircleAvatar(
                                                      backgroundColor: Colors.white,
                                                      child: Icon(
                                                        Icons.signal_cellular_4_bar,
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
                    // print("helloo"+snapshot.data.id);
                  }
                }
                return Container();
              });
        });
  }
}

Widget chart(List data, String type) {
  List<dynamic> adjustData = [];
  if (data.isNotEmpty) {
    if (type == "CarteDeSol") {
      print(' data is not empty');
      data = data.sublist(data.length - 10, data.length);
      print(data.length);

      data.forEach((element) {
        print(element.toString());
        var hour = DateTime.fromMillisecondsSinceEpoch(element['time'])
            .hour
            .toString();
        var minute = DateTime.fromMillisecondsSinceEpoch(element['time'])
            .minute
            .toString();
        var hum1 = element["humdity1"];
        var hum2 = element["humdity2"];
        var hum3 = element["humdity3"];
        var tot = (hum1 + hum2 + hum3) / 3;
        String time = hour + ":" + minute;
        print(time);
        adjustData.add({"type": "humdity1", "index": time, "value": tot});
        adjustData.add({"type": "humdity2", "index": time, "value": tot});
        adjustData.add({"type": "humdity3", "index": time, "value": tot});
        adjustData.add({
          "type": "temperatureSol",
          "index": time,
          "value": element["temperatureSol"]
        });
      });
    }
    print(' data is not empty');
    data = data.sublist(data.length - 10, data.length);
    print(data.length);

    data.forEach((element) {
      var hour =
          DateTime.fromMillisecondsSinceEpoch(element['time']).hour.toString();
      var minute = DateTime.fromMillisecondsSinceEpoch(element['time'])
          .minute
          .toString();
      String time = hour + ":" + minute;
      print("hello " + element.toString());
      adjustData.add(
          {"type": "temp", "index": time, "value": element["temperature"]});
      adjustData
          .add({"type": "hum", "index": time, "value": element["humidite"]});
    });
  }

  return Container(
    width: 650,
    height: 300,
    child: graphic.Chart(
      data: adjustData,
      margin: EdgeInsets.all(10),
      scales: {
        'index': graphic.CatScale(
          accessor: (map) => map['index'].toString(),
          range: [0, 0.99],
        ),
        'type': graphic.CatScale(
          accessor: (map) => map['type'] as String,
        ),
        'value': graphic.LinearScale(
          accessor: (map) => map['value'] as num,
          nice: true,
          range: [0, 1],
        ),
      },
      geoms: [
        graphic.LineGeom(
          position: graphic.PositionAttr(field: 'index*value'),
          color: graphic.ColorAttr(field: 'type'),
          size: graphic.SizeAttr(field: 'value'),
          shape:
              graphic.ShapeAttr(values: [graphic.BasicLineShape(smooth: true)]),
        )
      ],
      axes: {
        'index': graphic.Defaults.horizontalAxis,
        'value': graphic.Defaults.verticalAxis,
      },
    ),
  );
}
