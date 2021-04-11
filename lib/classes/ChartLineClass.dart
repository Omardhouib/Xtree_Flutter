import 'package:flutter/material.dart';
import 'package:sidebar_animation/graphic.dart' as graphic;

class ChartLineClass extends StatefulWidget {

  dynamic data;
  String type;
  ChartLineClass({this.data, this.type});

  @override
  _ChartLineClassState createState() => _ChartLineClassState();
}

class _ChartLineClassState extends State<ChartLineClass> {
  @override
  Widget build(BuildContext context) {
    List<dynamic> adjustData = [];
    if (widget.data.isNotEmpty) {
      if (widget.type == "CarteDeSol" && widget.data.length == 0) {
        return Container(
          child: Text(
            "There is no data to display !",
            style: TextStyle(
                fontSize: 18, fontWeight: FontWeight.w400, color: Colors.grey),
          ),
        );
      } else if (widget.type == "CarteDeSol" && widget.data.length <= 10) {
        print(' data is not empty');
        print(widget.data.length);

        widget.data.forEach((element) {
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
      } else if (widget.type == "CarteDeSol" && widget.data.length > 10) {
        print(' data is not empty');
        widget.data = widget.data.sublist(widget.data.length - 10, widget.data.length);
        print(widget.data.length);

        widget.data.forEach((element) {
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
      } else if (widget.type == "temperature" && widget.data.length == 0) {
        return Container(
          child: Text(
            "There is no data to display !",
            style: TextStyle(
                fontSize: 18, fontWeight: FontWeight.w400, color: Colors.grey),
          ),
        );
      } else if (widget.type == "temperature" && widget.data.length <= 10) {
        print(widget.data.length);

        widget.data.forEach((element) {
          var hour = DateTime.fromMillisecondsSinceEpoch(element['time'])
              .hour
              .toString();
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
      } else if (widget.type == "temperature" && widget.data.length > 10) {
        widget.data = widget.data.sublist(widget.data.length - 10, widget.data.length);
        print(widget.data.length);

        widget.data.forEach((element) {
          var hour = DateTime.fromMillisecondsSinceEpoch(element['time'])
              .hour
              .toString();
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
    } else
      return Container(
        child: Text(
          "There is no data to display !",
          style: TextStyle(
              fontSize: 18, fontWeight: FontWeight.w400, color: Colors.grey),
        ),
      );
  }
}
