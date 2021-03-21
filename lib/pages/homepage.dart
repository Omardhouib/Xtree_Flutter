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
import 'package:sidebar_animation/classes/schedulePage.dart';
import 'package:sidebar_animation/pages/Location/HomeLocation.dart';
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
  List<String> sens;
  DatabaseHelper2 databaseHelper2 = new DatabaseHelper2();
  final RoundedLoadingButtonController _btnController =
      new RoundedLoadingButtonController();
  List<dynamic> sensors = [];
  Future<LocationHome> getHomedetails;
  Future<int> getSensNum;
  Future<int> getLocNum;

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
    )) ?? false;
  }

  @override
  Widget build(BuildContext context) {
    var hour = DateTime.now().hour;
    return new WillPopScope(
        onWillPop: _onWillPop,
        child: new Scaffold(
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
                            FutureBuilder<LocationHome>(
//                future: databaseHelper.getData(),
                                future: getHomedetails,
                                builder: (context, snapshot) {
                                  if (snapshot.hasError) {
                                    print(snapshot.error);
                                    print("mochkla lenaa last *");
                                  }
                                  if (snapshot.hasData) {
                                    Location location = snapshot.data.locations;
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
                      future: databaseHelper2.Getweather(snapshot.data.locations.id),
                      builder: (context, snapshot2) {
                        if (snapshot2.hasError) {
                          print(snapshot2.error);
                          Container();
                        }
                        return snapshot2.hasData
                            ? Itemclass(list: snapshot2.data)
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
                                "Total number of DEVICES: " +
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
                                "Total number of LOCATIONS: " +
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
          Container(
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
                  Text(
                    "Total number of SCHEDULES: 0",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ),
          FutureBuilder<LocationHome>(
              future: getHomedetails,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
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
                                              sens: snapshot.data.sol,
                                              location: snapshot.data.locations,
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
                  return ItemListchart(list: snapshot.data.locations.sensorIds);
                } else {
                  return Container();
                }
              }),

          FutureBuilder<LocationHome>(
//                future: databaseHelper.getData(),
              future: databaseHelper2.getHomedetails(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ItemListElectro(list: snapshot.data.electro);
                } else {
                  return Container();
                }
              }),
        ],
      ),
        ),
    );
  }

  Widget Itemclass({List list}) {
    var hour = DateTime.now().hour;
    DateTime date = DateTime.now();
    String dateFormat = DateFormat('EEEE').format(date);
    //  final hour formattedDate = DateFormat.j().format(now);
    //dynamic currentTime = DateFormat.j().format(DateTime.now());
    return SizedBox(
      height: 290.0,
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
                padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
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
                          style: TextStyle(color: Colors.white, fontSize: 35,fontWeight: FontWeight.w400),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(95, 0, 0, 0),
                        child: Text(
                          dateFormat,
                          style: TextStyle(color: Colors.white, fontSize: 16,fontWeight: FontWeight.w300),
                        ),
                      ),
                      if (list[i]["pop"] > 0.1)
                        Padding(
                          padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
                          child: SizedBox(
                            width: 100,
                            height: 100,
                            child: new Image.network(
                                'https://www.dovora.com/resources/weather-icons/showcase/modern_showcase/rain.png'),
                          ),
                        ),
                      if (list[i]["clouds"] > 0 && list[i]["pop"] < 0.1)
                        Padding(
                          padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
                          child: SizedBox(
                            width: 100,
                            height: 100,
                            child: new Image.network(
                                'https://www.dovora.com/resources/weather-icons/showcase/modern_showcase/overcast.png'),
                          ),
                        ),
                      if (list[i]["pop"] < 0.1 && list[i]["clouds"] < 1)
                        Padding(
                          padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
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
                            padding: const EdgeInsets.fromLTRB(15, 0, 4, 0),
                            child: Text(
                              list[i]["temp"]["min"].round().toString() + "°C",
                              style:
                              TextStyle(color: Colors.white, fontSize: 15,fontWeight: FontWeight.w300),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                            child: Text(
                              "/",
                              style:
                              TextStyle(color: Colors.white, fontSize: 15,fontWeight: FontWeight.w300),                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(4, 0, 0, 0),
                            child: Text(
                              list[i]["temp"]["max"].round().toString() + "°C",
                              style:
                              TextStyle(color: Colors.white, fontSize: 15,fontWeight: FontWeight.w300),                            ),
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
                              TextStyle(color: Colors.white, fontSize: 15),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                            child: Text(
                              list[i]["humidity"].toString() + "%",
                              style:
                              TextStyle(color: Colors.white, fontSize: 15,fontWeight: FontWeight.w300),
                            ),
                          )
                        ],
                      ),
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(15, 5, 0, 0),
                            child: Text(
                              "Precipitation: ",
                              style:
                              TextStyle(color: Colors.white, fontSize: 15),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                            child: Text(
                              list[i]["pop"].toString() + "mm",
                              style:
                              TextStyle(color: Colors.white, fontSize: 15,fontWeight: FontWeight.w300),
                            ),
                          )
                        ],
                      ),
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(15, 5, 0, 0),
                            child: Text(
                              "Uv: ",
                              style:
                              TextStyle(color: Colors.white, fontSize: 15),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                            child: Text(
                              list[i]["uvi"].toString(),
                              style:
                              TextStyle(color: Colors.white, fontSize: 15,fontWeight: FontWeight.w300),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              );
            } else if ((hour < 20) && (hour >= 17)) {
              return Padding(
                padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
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
                              "https://lh3.googleusercontent.com/proxy/KYHQGmm33PKCV_kLI5i1rO9o_Jxi8Li67L_z-q84SWLr32bQdXS8LLS0p9E6Oj8Ije3teyNy2rssAaobRP44gVqBt8ppWUbjebw5Tr7d7hj5veYNLeBi2rWD9mi-c595aCwc"),
                          fit: BoxFit.cover)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.fromLTRB(95, 10, 0, 0),
                        child: Text(
                          list[i]["temp"]["eve"].round().toString() + "°C",
                          style: TextStyle(color: Colors.white, fontSize: 35,fontWeight: FontWeight.w400),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(95, 0, 0, 0),
                        child: Text(
                          dateFormat,
                          style: TextStyle(color: Colors.white, fontSize: 16,fontWeight: FontWeight.w300),
                        ),
                      ),
                      if (list[i]["pop"] > 0.1)
                        Padding(
                          padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
                          child: SizedBox(
                            width: 100,
                            height: 100,
                            child: new Image.network(
                                'https://www.dovora.com/resources/weather-icons/showcase/modern_showcase/rain.png'),
                          ),
                        ),
                      if (list[i]["clouds"] > 0 && list[i]["pop"] < 0.1)
                        Padding(
                          padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
                          child: SizedBox(
                            width: 100,
                            height: 100,
                            child: new Image.network(
                                'https://www.dovora.com/resources/weather-icons/showcase/modern_showcase/overcast.png'),
                          ),
                        ),
                      if (list[i]["pop"] < 0.1 && list[i]["clouds"] < 1)
                        Padding(
                          padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
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
                            padding: const EdgeInsets.fromLTRB(15, 0, 4, 0),
                            child: Text(
                              list[i]["temp"]["min"].round().toString() + "°C",
                              style:
                              TextStyle(color: Colors.white, fontSize: 15,fontWeight: FontWeight.w300),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                            child: Text(
                              "/",
                              style:
                              TextStyle(color: Colors.white, fontSize: 15,fontWeight: FontWeight.w300),                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(4, 0, 0, 0),
                            child: Text(
                              list[i]["temp"]["max"].round().toString() + "°C",
                              style:
                              TextStyle(color: Colors.white, fontSize: 15,fontWeight: FontWeight.w300),                            ),
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
                              TextStyle(color: Colors.white, fontSize: 15),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                            child: Text(
                              list[i]["humidity"].toString() + "%",
                              style:
                              TextStyle(color: Colors.white, fontSize: 15,fontWeight: FontWeight.w300),
                            ),
                          )
                        ],
                      ),
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(15, 5, 0, 0),
                            child: Text(
                              "Precipitation: ",
                              style:
                              TextStyle(color: Colors.white, fontSize: 15),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                            child: Text(
                              list[i]["pop"].toString() + "mm",
                              style:
                              TextStyle(color: Colors.white, fontSize: 15,fontWeight: FontWeight.w300),
                            ),
                          )
                        ],
                      ),
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(15, 5, 0, 0),
                            child: Text(
                              "Uv: ",
                              style:
                              TextStyle(color: Colors.white, fontSize: 15),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                            child: Text(
                              list[i]["uvi"].toString(),
                              style:
                              TextStyle(color: Colors.white, fontSize: 15,fontWeight: FontWeight.w300),
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
                padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
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
                          style: TextStyle(color: Colors.white, fontSize: 35,fontWeight: FontWeight.w400),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(95, 0, 0, 0),
                        child: Text(
                          dateFormat,
                          style: TextStyle(color: Colors.white, fontSize: 16,fontWeight: FontWeight.w300),
                        ),
                      ),
                      if (list[i]["pop"] > 0.1)
                        Padding(
                          padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
                          child: SizedBox(
                            width: 100,
                            height: 100,
                            child: new Image.network(
                                'https://www.dovora.com/resources/weather-icons/showcase/modern_showcase/rain.png'),
                          ),
                        ),
                      if (list[i]["clouds"] > 0 && list[i]["pop"] < 0.1)
                        Padding(
                          padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
                          child: SizedBox(
                            width: 100,
                            height: 100,
                            child: new Image.network(
                                'https://www.dovora.com/resources/weather-icons/showcase/modern_showcase/overcast.png'),
                          ),
                        ),
                      if (list[i]["pop"] < 0.1 && list[i]["clouds"] < 1)
                        Padding(
                          padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
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
                            padding: const EdgeInsets.fromLTRB(15, 0, 4, 0),
                            child: Text(
                              list[i]["temp"]["min"].round().toString() + "°C",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 15,fontWeight: FontWeight.w300),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                            child: Text(
                              "/",
                              style:
                              TextStyle(color: Colors.white, fontSize: 15,fontWeight: FontWeight.w300),                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(4, 0, 0, 0),
                            child: Text(
                              list[i]["temp"]["max"].round().toString() + "°C",
                              style:
                              TextStyle(color: Colors.white, fontSize: 15,fontWeight: FontWeight.w300),                            ),
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
                                  TextStyle(color: Colors.white, fontSize: 15),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                            child: Text(
                              list[i]["humidity"].toString() + "%",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 15,fontWeight: FontWeight.w300),
                            ),
                          )
                        ],
                      ),
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(15, 5, 0, 0),
                            child: Text(
                              "Precipitation: ",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 15),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                            child: Text(
                              list[i]["pop"].toString() + "mm",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 15,fontWeight: FontWeight.w300),
                            ),
                          )
                        ],
                      ),
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(15, 5, 0, 0),
                            child: Text(
                              "Uv: ",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 15),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                            child: Text(
                              list[i]["uvi"].toString(),
                              style:
                                  TextStyle(color: Colors.white, fontSize: 15,fontWeight: FontWeight.w300),
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
  bool  pressGeoON = false;
  bool cmbscritta = false;
  final RoundedLoadingButtonController _btnController =
      new RoundedLoadingButtonController();

  ScrollController _controller = new ScrollController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 20),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            color: Colors.white),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 10, 0, 0),
              child: Text(
                "Relays:",
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            ListView.builder(
                itemCount: widget.list == null ? 0 : widget.list.length,
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (context, i) {
                  id = widget.list[i].id.toString();
                  print("...."+cmbscritta.toString());
                  if (widget.list[i].status != cmbscritta)
                  return Row(
                            children: [
                              Padding(
                                padding: EdgeInsets.fromLTRB(10, 0, 140, 0),
                                child: Text(
                                  //list[i].toString() ?? '',
                                  widget.list[i].name.toString(),
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(right: 94),
                                child: Text(
                                  "ON",
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green[300]),
                                ),
                              ),
                              Column(
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.link_off),
                                    iconSize: 30,
                                    color: Colors.red,
                                    onPressed: () {
                                      status = widget.list[i].status.toString();
                                      _doSomething();
                                    },
                                  ),
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                                    child: Text(
                                      "TURN OFF",
                                      style:
                                      TextStyle(fontSize: 12, color: Colors.grey),
                                    ),
                                  ),

                                ],
                              ),
                            ],
                          );
                  else if (widget.list[i].status == cmbscritta){
                    return Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.fromLTRB(25, 0, 120, 0),
                          child: Text(
                            //list[i].toString() ?? '',
                            widget.list[i].name.toString(),
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(right: 94),
                          child: Text(
                            "OFF",
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.red[300]),
                          ),
                        ),
                        Column(
                          children: [
                            IconButton(
                              icon: Icon(Icons.flash_on),
                              color: Colors.green,
                              iconSize: 30,
                              onPressed: () {
                                status = widget.list[i].status.toString();
                                _doSomething();
                              },
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                              child: Text(
                                "TURN ON",
                                style:
                                TextStyle(fontSize: 12, color: Colors.grey),
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
                  }
                  return Container();
                }),
          ],
        ),
      ),
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
        setState(() {
          pressGeoON = !pressGeoON;
          cmbscritta = !cmbscritta;
        });
      //  _btnController.stop();
      } else if (status == "false") {
        status = "true";
        print("offfff");
        Off(id);
        setState(() {
          pressGeoON = !pressGeoON;
          cmbscritta = !cmbscritta;
        });
       // _btnController.stop();
      }
      //_btnController.stop();
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
                                      padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                                      child: Padding(
                                        padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
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
                                      padding: const EdgeInsets.fromLTRB(0, 22, 0, 0),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            snapshot.data.name.toString(),
                                            style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 20,
                                            ),
                                          ),
                                          Text(
                                            snapshot.data.description.toString(),
                                            style: TextStyle(
                                              color: Colors.grey,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 12,
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
                                        chart(snapshot2.data, type),
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
        adjustData.add({"type": "humdity1", "index": time, "value": hum1});
        adjustData.add({"type": "humdity2", "index": time, "value": hum2});
        adjustData.add({"type": "humdity3", "index": time, "value": hum3});
        adjustData.add({"type": "humdity4", "index": time, "value": tot});
        adjustData.add({
          "type": "temperatureSol",
          "index": time,
          "value": element["temperatureSol"]
        });
      });
      return Column(
        children: [
          Row(
            children: [
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(40, 0, 0, 0),
                    child: Container(
                      width: 40,
                      height: 5,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(3.0)),
                        color: Colors.blue,
                      ),

                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(5, 0, 10, 0),
                    child: Text(
                      "Humidity 1",
                      style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                          color: Colors.grey
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                    child: Container(
                      width: 40,
                      height: 5,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(3.0)),
                        color: Colors.green,
                      ),

                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(5, 0, 10, 0),
                    child: Text(
                      "Humidity 2",
                      style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                          color: Colors.grey
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                    child: Container(
                      width: 40,
                      height: 5,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(3.0)),
                        color: Colors.amber,
                      ),

                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(5, 0, 10, 0),
                    child: Text(
                      "Humidity 3",
                      style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                          color: Colors.grey
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          Row(
            children: [
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(40, 5, 0, 20),
                    child: Container(
                      width: 40,
                      height: 5,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(3.0)),
                        color: Colors.blue[900],
                      ),

                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(5, 5, 10, 20),
                    child: Text(
                      "Average humidity",
                      style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                          color: Colors.grey
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(5, 5, 0, 20),
                    child: Container(
                      width: 40,
                      height: 5,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(3.0)),
                        color: Colors.purple,
                      ),

                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(5, 5, 10, 20),
                    child: Text(
                      "Temperature",
                      style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                          color: Colors.grey
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          Container(
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
          ),
        ],
      );
    }
    else
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
    return Column(
      children: [
        Row(
          children: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(40, 0, 0, 20),
                  child: Container(
                    width: 40,
                    height: 5,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(3.0)),
                      color: Colors.green,
                    ),

                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(5, 0, 10, 20),
                  child: Text(
                    "Humidity",
                    style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                        color: Colors.grey
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 0, 20),
                  child: Container(
                    width: 40,
                    height: 5,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(3.0)),
                      color: Colors.blue,
                    ),

                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(5, 0, 10, 20),
                  child: Text(
                    "Temperature",
                    style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                        color: Colors.grey
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        Container(
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
        ),
      ],
    );
  }
}
