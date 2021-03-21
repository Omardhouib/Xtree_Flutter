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

class schedulePage extends StatefulWidget with NavigationStates {
  Location location;
  Sensor sens;
  List<Sensor> Electro;
  schedulePage({this.location, this.sens, this.Electro});

  @override
  schedulePageState createState() => schedulePageState();
}

class schedulePageState extends State<schedulePage> {
  DatabaseHelper2 databaseHelper2 = new DatabaseHelper2();
  DateTime selectedDate = DateTime.now();
  List<dynamic> sensors = [];
  final _formKey = GlobalKey<FormState>();
  List<String> _locations = ['AI mode', 'Manuel mode']; // Option 2
  String _selectedLocation;
  final TextEditingController sitenameController = new TextEditingController();
  final TextEditingController descriptionController =
      new TextEditingController();
  Future<void> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
  }
  List<String> Elect = [];
  @override
  void initState() {
    widget.Electro.forEach((element) {
      //print("......"+element.name.toString());
      Elect.add(element.name);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<String> flavours = [];
    String _chosenValue;
    var hour = DateTime.now().hour;
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Padding(
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
        child: ListView(
          scrollDirection: Axis.vertical,
          children: <Widget>[
            Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(10, 15, 0, 25),
                      child: Row(
                        children: <Widget>[
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                widget.location.siteName,
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
                ]),
            FutureBuilder(
                future: databaseHelper2.Getweather(widget.location.id),
                builder: (context, snapshot2) {
                  if (snapshot2.hasError) {
                    print(snapshot2.error);
                    Container();
                  }
                  return snapshot2.hasData
                      ? Itemclass(list: snapshot2.data)
                      : Container();
                }),
            Container(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
              ),
            ),
            Text('mode'),
            DropdownButton(
              hint:
                  Text('Please choose the mode'), // Not necessary for Option 1
              value: _selectedLocation,
              onChanged: (newValue) {
                setState(() {
                  _selectedLocation = newValue;
                });
              },
              items: _locations.map((location) {
                return DropdownMenuItem(
                  child: new Text(location),
                  value: location,
                );
              }).toList(),
            ),
            Text('Device name: '+widget.sens.name),
            Text('the of device'),
            Text('Description'+widget.sens.description),
            Text('status'+widget.sens.status.toString()),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text("${selectedDate.toLocal()}".split(' ')[0]),
                SizedBox(
                  height: 20.0,
                ),
                RaisedButton(
                  onPressed: () => _selectDate(context),
                  child: Text('Select date'),
                ),
              ],
            ),
            Text('T max'),
            TextFormField(
              validator: (value) {
                if (value.isEmpty) {
                  return "Site name cannot be empty !";
                } else
                  return null;
              },
              controller: sitenameController,
              decoration: InputDecoration(
                  icon: Icon(Icons.place, color: Colors.grey[400]),
                  border: InputBorder.none,
                  hintText: "80",
                  hintStyle: TextStyle(color: Colors.grey[400])),
            ),
            Text('T min'),
            TextFormField(
              validator: (value) {
                if (value.isEmpty) {
                  return "Site name cannot be empty !";
                } else
                  return null;
              },
              controller: descriptionController,
              decoration: InputDecoration(
                  icon: Icon(Icons.place, color: Colors.grey[400]),
                  border: InputBorder.none,
                  hintText: "20",
                  hintStyle: TextStyle(color: Colors.grey[400])),
            ),
            Text('Alerted by email'),
            Form(
              key: _formKey,
              child: MultiSelectFormField(
                context: context,
                buttonText: 'Relays',
                itemList: Elect,
                questionText: 'Select Your Relays',
                validator: (flavours) => flavours.length == 0
                    ? 'Please select at least one Relay!'
                    : null,
                onSaved: (flavours) {
                  print(flavours);
                  // Logic to save selected flavours in the database
                },
              ),
              onChanged: () {
                if (_formKey.currentState.validate()) {
                  // Invokes the OnSaved Method
                  _formKey.currentState.save();
                }
              },
            ),
            ItemListchart(sensor: widget.sens)
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
    dynamic currentTime = DateFormat.j().format(DateTime.now());
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
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 35,
                              fontWeight: FontWeight.w400),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(95, 0, 0, 0),
                        child: Text(
                          dateFormat,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w300),
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
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w300),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                            child: Text(
                              "/",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w300),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(4, 0, 0, 0),
                            child: Text(
                              list[i]["temp"]["max"].round().toString() + "°C",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w300),
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
                                  TextStyle(color: Colors.white, fontSize: 15),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                            child: Text(
                              list[i]["humidity"].toString() + "%",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w300),
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
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w300),
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
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w300),
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
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 35,
                              fontWeight: FontWeight.w400),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(95, 0, 0, 0),
                        child: Text(
                          dateFormat,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w300),
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
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w300),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                            child: Text(
                              "/",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w300),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(4, 0, 0, 0),
                            child: Text(
                              list[i]["temp"]["max"].round().toString() + "°C",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w300),
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
                                  TextStyle(color: Colors.white, fontSize: 15),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                            child: Text(
                              list[i]["humidity"].toString() + "%",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w300),
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
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w300),
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
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w300),
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
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 35,
                              fontWeight: FontWeight.w400),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(95, 0, 0, 0),
                        child: Text(
                          dateFormat,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w300),
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
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w300),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                            child: Text(
                              "/",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w300),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(4, 0, 0, 0),
                            child: Text(
                              list[i]["temp"]["max"].round().toString() + "°C",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w300),
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
                                  TextStyle(color: Colors.white, fontSize: 15),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                            child: Text(
                              list[i]["humidity"].toString() + "%",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w300),
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
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w300),
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
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w300),
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

class ItemListchart extends StatefulWidget {
  Sensor sensor;
  ItemListchart({this.sensor});

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
    return FutureBuilder<Sensor>(
        future: databaseHelper2.getDevById(widget.sensor.id),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            print(snapshot.error);
            print("there is problem !");
          }

          if (snapshot.hasData) {
            //  print("helloo" + snapshot.data.toString());
            String type = snapshot.data.sensorType;
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
                                    0, 22, 0, 0),
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
                                      snapshot.data.description
                                          .toString(),
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
          return Container();
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
                          color: Colors.grey),
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
                          color: Colors.grey),
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
                          color: Colors.grey),
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
                          color: Colors.grey),
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
                          color: Colors.grey),
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
                  shape: graphic.ShapeAttr(
                      values: [graphic.BasicLineShape(smooth: true)]),
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
    } else
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
                        color: Colors.grey),
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
                        color: Colors.grey),
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
                shape: graphic.ShapeAttr(
                    values: [graphic.BasicLineShape(smooth: true)]),
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

class MultiSelectFormField extends FormField<List<String>> {
  /// Holds the items to display on the dialog.
  final List<String> itemList;

  /// Enter text to show on the button.
  final String buttonText;

  /// Enter text to show question on the dialog
  final String questionText;

  // Constructor
  MultiSelectFormField({
    this.buttonText,
    this.questionText,
    this.itemList,
    BuildContext context,
    FormFieldSetter<List<String>> onSaved,
    FormFieldValidator<List<String>> validator,
    List<String> initialValue,
  }) : super(
          onSaved: onSaved,
          validator: validator,
          initialValue: initialValue ?? [], // Avoid Null
          autovalidate: true,
          builder: (FormFieldState<List<String>> state) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    InkWell(
                        child: Card(
                            elevation: 3,
                            child: ClipPath(
                                child: Container(
                                  height: 50,
                                  width: 200,
                                  color: Colors.blue,
                                  child: Center(
                                    //If value is null or no option is selected
                                    child: (state.value == null ||
                                            state.value.length <= 0)

                                        // Show the buttonText as it is
                                        ? Text(
                                            buttonText,
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold),
                                          )

                                        // Else show number of selected options
                                        : Text(
                                            state.value.length == 1
                                                // SINGLE FLAVOR SELECTED
                                                ? '${state.value.length.toString()} '
                                                    ' ${buttonText.substring(0, buttonText.length - 1)} SELECTED '
                                                // MULTIPLE FLAVOR SELECTED
                                                : '${state.value.length.toString()} '
                                                    ' $buttonText SELECTED',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold),
                                          ),
                                  ),
                                ),
                                clipper: ShapeBorderClipper(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(3))))),
                        onTap: () async => state.didChange(await showDialog(
                                context: context,
                                builder: (_) => MultiSelectDialog(
                                      question: Text(questionText),
                                      answers: itemList,
                                    )) ??
                            []))
                  ],
                ),
                // If validation fails, display an error
                state.hasError
                    ? Center(
                        child: Text(
                          state.errorText,
                          style: TextStyle(color: Colors.red),
                        ),
                      )
                    : Container() //Else show an empty container
              ],
            );
          },
        );
}

class MultiSelectDialog extends StatefulWidget {
  /// List to display the answer.
  final List<String> answers;

  /// Widget to display the question.
  final Widget question;

  /// Map that holds selected option with a boolean value
  /// i.e. { 'a' : false}.
  static Map<String, bool> mappedItem;

  MultiSelectDialog({this.answers, this.question});

  @override
  _MultiSelectDialogState createState() => _MultiSelectDialogState();
}

class _MultiSelectDialogState extends State<MultiSelectDialog> {
  /// List to hold the selected answer
  /// i.e. ['a'] or ['a','b'] or ['a','b','c'] etc.
  final List<String> selectedItems = [];

  /// Function that converts the list answer to a map.
  Map<String, bool> initMap() {
    return MultiSelectDialog.mappedItem = Map.fromIterable(widget.answers,
        key: (k) => k.toString(),
        value: (v) {
          if (v != true && v != false)
            return false;
          else
            return v as bool;
        });
  }

  @override
  Widget build(BuildContext context) {
    if (MultiSelectDialog.mappedItem == null) {
      initMap();
    }
    return SimpleDialog(
      title: widget.question,
      children: [
        ...MultiSelectDialog.mappedItem.keys.map((String key) {
          return StatefulBuilder(
            builder: (_, StateSetter setState) => CheckboxListTile(
                title: Text(key), // Displays the option
                value: MultiSelectDialog
                    .mappedItem[key], // Displays checked or unchecked value
                controlAffinity: ListTileControlAffinity.platform,
                onChanged: (value) =>
                    setState(() => MultiSelectDialog.mappedItem[key] = value)),
          );
        }).toList(),
        Align(
            alignment: Alignment.center,
            child: RaisedButton(
                child: Text('Submit'),
                onPressed: () {
                  // Clear the list
                  selectedItems.clear();

                  // Traverse each map entry
                  MultiSelectDialog.mappedItem.forEach((key, value) {
                    if (value == true) {
                      selectedItems.add(key);
                    }
                  });

                  // Close the Dialog & return selectedItems
                  Navigator.pop(context, selectedItems);
                  print("......."+selectedItems.toString());
                }))
      ],
    );
  }
}
