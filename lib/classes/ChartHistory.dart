import 'dart:async';
import 'dart:convert';

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:sidebar_animation/Services/DataHelpers.dart';
import 'package:http/http.dart' as http;
import 'package:sidebar_animation/bloc.navigation_bloc/navigation_bloc.dart';
import 'package:sidebar_animation/graphic.dart' as graphic;

class ChartHistory extends StatefulWidget with NavigationStates {
  ChartHistory({Key key, this.title, this.onValueChange, this.initialValue, this.identifier, this.type, this.name}) : super(key: key);
  final String title;
  final String identifier;
  final String type;
  final String name;
  final String initialValue;
  final void Function(String) onValueChange;
  @override
  ChartHistoryState createState() => ChartHistoryState();
}

class ChartHistoryState extends State<ChartHistory> {
  String identifier;
  String type;
  String name;
  num Time;
  num DateS;
  List<dynamic> data= [];
  DateTime selectedDate = DateTime.now();
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

  @override
  Widget build(BuildContext context) {
    final _key = GlobalKey<FormState>();
    identifier = widget.identifier;
    type = widget.type;
    name = widget.name;
    return AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0))),
        contentPadding: EdgeInsets.only(top: 0.0),
        content: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 20,
              ),
              Text(
                name,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 0, 0, 15),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[

                    Text(
                      "${selectedDate.toLocal()}".split(' ')[0],
                      style: TextStyle(
                          fontSize: 15, fontWeight: FontWeight.w400),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(30, 0, 0, 0),
                      child: Container(
                        width: 140,
                        height: 30,
                        child: FlatButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              side: BorderSide(
                                  color: Colors.blue[300], width: 1.5)),
                          onPressed: () => _selectDate(context),
                          color: Colors.transparent,
                          textColor: Colors.blue,
                          child: Row(
                            children: [
                              Icon(
                                Icons.calendar_today,
                                color: Colors.blue,
                                size: 20,
                              ),
                              Text(
                                '   Select date',
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              FutureBuilder<List>(
//                future: databaseHelper.getData(),
                  future: databaseHelper2.getdataDeviceByID(widget.identifier),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      print(snapshot.error);
                      print("mochkla lenaa *");
                    }
                    if (snapshot.hasData) {
                      /*print("first:"+snapshot.data[0]["time"].toString());
                      snapshot.data.forEach((element) {
                       int time = (element['time']);
                         Time  = element['time'];
                       DateS = (selectedDate.millisecondsSinceEpoch / (1000));
                       print("timeee"+Time.toString());
                       print("selecteddate: "+DateS.toString());
                       if(DateS >= Time){
                         data.add(element);
                         print("elemnt"+element.toString());
                       }
                      });*/
                      return Column(
                        children: [
                          chart(snapshot.data, type),
                          SizedBox(
                            height: 15,
                          ),
                          Row(
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
                                  snapshot.data[snapshot.data.length-1]["batterie"].round().toString()+"%",
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
                        ],
                      );
                    } else {
                      return Container();
                    }
                  }),
            ],
          ),
        ));
  }

  DatabaseHelper2 databaseHelper2 = new DatabaseHelper2();
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
                    padding: const EdgeInsets.fromLTRB(20, 8, 0, 0),
                    child: Container(
                      width: 20,
                      height: 5,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(3.0)),
                        color: Colors.blue,
                      ),

                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(5, 8, 5, 0),
                    child: Text(
                      "Humidity 1",
                      style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 15,
                          color: Colors.grey
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(5, 8, 0, 0),
                    child: Container(
                      width: 20,
                      height: 5,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(3.0)),
                        color: Colors.green,
                      ),

                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(5, 8, 5, 0),
                    child: Text(
                      "Humidity 2",
                      style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 15,
                          color: Colors.grey
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(5, 8, 0, 0),
                    child: Container(
                      width: 20,
                      height: 5,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(3.0)),
                        color: Colors.amber,
                      ),

                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(5, 8, 5, 0),
                    child: Text(
                      "Humidity 3",
                      style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 15,
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
                    padding: const EdgeInsets.fromLTRB(20, 0, 0, 20),
                    child: Container(
                      width: 20,
                      height: 5,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(3.0)),
                        color: Colors.blue[900],
                      ),

                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(5, 0, 5, 20),
                    child: Text(
                      "Average humidity",
                      style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 15,
                          color: Colors.grey
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(5, 8, 0, 20),
                    child: Container(
                      width: 20,
                      height: 5,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(3.0)),
                        color: Colors.purple,
                      ),

                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(5, 8, 5, 20),
                    child: Text(
                      "Temperature",
                      style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 15,
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
                  padding: const EdgeInsets.fromLTRB(40, 8, 0, 20),
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
                  padding: const EdgeInsets.fromLTRB(5, 8, 10, 20),
                  child: Text(
                    "Humidity",
                    style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 15,
                        color: Colors.grey
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 8, 0, 20),
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
                  padding: const EdgeInsets.fromLTRB(5, 8, 10, 20),
                  child: Text(
                    "Temperature",
                    style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 15,
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