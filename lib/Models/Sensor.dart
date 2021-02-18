// To parse this JSON data, do
//
//     final sensor = sensorFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

List<Sensor> sensorFromJson(String str) => List<Sensor>.from(json.decode(str).map((x) => Sensor.fromJson(x)));

String sensorToJson(List<Sensor> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Sensor {
  Sensor({
    @required this.sensorCoordinates,
    @required this.createdDate,
    @required this.status,
    @required this.id,
    @required this.rules,
    @required this.sensorIdentifier,
    @required this.sensorType,
    @required this.v,
    @required this.description,
    @required this.name,
    @required this.uv,
  });

  List<double> sensorCoordinates;
  DateTime createdDate;
  bool status;
  String id;
  List<dynamic> rules;
  String sensorIdentifier;
  String sensorType;
  int v;
  String description;
  String name;
  double uv;

  factory Sensor.fromJson(Map<String, dynamic> json) => Sensor(
    sensorCoordinates: List<double>.from(json["SensorCoordinates"].map((x) => x.toDouble())),
    createdDate: DateTime.parse(json["Created_date"]),
    status: json["status"],
    id: json["_id"],
    rules: List<dynamic>.from(json["Rules"].map((x) => x)),
    sensorIdentifier: json["SensorIdentifier"],
    sensorType: json["SensorType"],
    v: json["__v"],
    description: json["Description"],
    name: json["name"],
    uv: json["uv"].toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "SensorCoordinates": List<dynamic>.from(sensorCoordinates.map((x) => x)),
    "Created_date": createdDate.toIso8601String(),
    "status": status,
    "_id": id,
    "Rules": List<dynamic>.from(rules.map((x) => x)),
    "SensorIdentifier": sensorIdentifier,
    "SensorType": sensorType,
    "__v": v,
    "Description": description,
    "name": name,
    "uv": uv,
  };
}
