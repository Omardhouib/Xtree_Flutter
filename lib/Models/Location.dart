// To parse this JSON data, do
//
//     final location = locationFromJson(jsonString);
import 'package:meta/meta.dart';
import 'dart:convert';

List<Location> locationFromJson(String str) => List<Location>.from(json.decode(str).map((x) => Location.fromJson(x)));

String locationToJson(List<Location> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Location {
  Location({
    this.automaticIrrigation,
    @required this.coordinates,
    this.createdDate,
    this.sensorIds,
    this.id,
    @required this.siteName,
    @required this.description,
    this.v,
  });

  bool automaticIrrigation;
  List<double> coordinates;
  DateTime createdDate;
  List<String> sensorIds;
  String id;
  String siteName;
  String description;
  int v;

  factory Location.fromJson(Map<String, dynamic> json) => Location(
    automaticIrrigation: json["AutomaticIrrigation"],
    coordinates: List<double>.from(json["Coordinates"].map((x) => x.toDouble())),
    createdDate: DateTime.parse(json["Created_date"]),
    sensorIds: List<String>.from(json["Sensor_ids"].map((x) => x)),
    id: json["_id"],
    siteName: json["SiteName"],
    description: json["Description"],
    v: json["__v"],
  );

  Map<String, dynamic> toJson() => {
    "AutomaticIrrigation": automaticIrrigation,
    "Coordinates": List<dynamic>.from(coordinates.map((x) => x)),
    "Created_date": createdDate,
    "Sensor_ids": List<dynamic>.from(sensorIds.map((x) => x)),
    "_id": id,
    "SiteName": siteName,
    "Description": description,
    "__v": v,
  };
}