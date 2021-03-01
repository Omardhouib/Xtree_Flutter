import 'package:flutter/material.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:sidebar_animation/Models/Sensor.dart';
import 'package:sidebar_animation/Services/DataHelpers.dart';
import 'package:sidebar_animation/pages/Device/UpdateSens.dart';
import '../../bloc.navigation_bloc/navigation_bloc.dart';
import 'dart:async';
import 'package:sidebar_animation/graphic.dart' as graphic;

class deviceDetails extends StatefulWidget with NavigationStates {
  List list;
  int index;
  String identifier;
  deviceDetails({this.list, this.identifier, this.index});

  @override
  _deviceDetailsState createState() => _deviceDetailsState();
}

class _deviceDetailsState extends State<deviceDetails> {
  DatabaseHelper2 databaseHelper2 = new DatabaseHelper2();

  final RoundedLoadingButtonController _btndeleteController =
  new RoundedLoadingButtonController();

  void _onValueChange(String value) {
    setState(() {
      _selectedId = value;
    });
  }

  String _selectedId;

  @override
  Widget build(BuildContext context) {
    print(widget.identifier);
    var hum1 = [];
    var hum2 = [];
    var hum3 = [];
    var humTotal = [];
    var humAir = [];
    var tempSol = [];
    var tempAir = [];
    var batterie = [];
    var time = [];
    var adjustData = [
      {"type": "humdity1", "index": "3", "value": hum1},
      {"type": "humdity2", "index": "3", "value": hum2},
      {"type": "humdity3", "index": "3", "value": hum3},
      {"type": "temperatureSol", "index": "4", "value": tempSol},
    ];
    String type = widget.list[widget.index]["SensorType"].toString();
    print(identical(type, type));
    /* var long2 = int.tryParse(t);
    var date = DateTime.fromMillisecondsSinceEpoch(long2);*/
    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            height: 20,
          ),
          Text(
            //                         list[i].toString() ?? '',
            widget.list[widget.index]["name"].toString(),

            style: TextStyle(height: 5, fontSize: 10),
          ),
          Text(
            //                         list[i].toString() ?? '',
            widget.list[widget.index]["SensorType"].toString(),
            style: TextStyle(height: 5, fontSize: 10),
          ),
          Padding(
            child:
                Text('Multi Line (No Stack)', style: TextStyle(fontSize: 20)),
            padding: EdgeInsets.fromLTRB(0, 40, 0, 0),
          ),
          FutureBuilder(
//                future: databaseHelper.getData(),
              future: databaseHelper2.getDeviceByID(widget.identifier),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  print(snapshot.error);
                  print("mochkla lenaa *");
                }
                return snapshot.hasData
                    ? chart(snapshot.data, type)
                    : Center(
                        child: CircularProgressIndicator(),
                      );
              }),
          Row(
            children: [
              Container(
                height: 50,
                width: 100,
                child: AspectRatio(
                  child: FlatButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    color: Colors.greenAccent,
                    child: Text("Update location",
                        style: TextStyle(color: Colors.white)),
                    onPressed: () {
                      showDialog(
                          context: context,
                          child: UpdateSens(
                            onValueChange: _onValueChange,
                            initialValue: _selectedId,
                            identifier: widget.identifier,
                          ));
                    },
                  ),
                  aspectRatio: 8,
                ),
              ),
              Container(
                height: 50,
                width: 100,
                child: AspectRatio(
                  child: RoundedLoadingButton(
                    color: Colors.redAccent,
                    child: Text("Delete location",
                        style: TextStyle(color: Colors.white)),
                    onPressed: () {},
                    controller: _btndeleteController,
                  ),
                  aspectRatio: 8,
                ),
              ),
            ],
          ),
        ],
      ),
    );
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
