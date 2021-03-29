// To parse this JSON data, do
//
//     final location = locationFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

Location locationFromJson(String str) => Location.fromJson(json.decode(str));

String locationToJson(Location data) => json.encode(data.toJson());

class Location {
  Location({
    @required this.automaticIrrigation,
    @required this.coordinates,
    @required this.createdDate,
    @required this.sensorIds,
    @required this.id,
    @required this.siteName,
    @required this.description,
    @required this.v,
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
    "Created_date": createdDate.toIso8601String(),
    "Sensor_ids": List<dynamic>.from(sensorIds.map((x) => x)),
    "_id": id,
    "SiteName": siteName,
    "Description": description,
    "__v": v,
  };

  @override
  String toString() {
    return 'Location{automaticIrrigation: $automaticIrrigation, coordinates: $coordinates, createdDate: $createdDate, sensorIds: $sensorIds, id: $id, siteName: $siteName, description: $description, v: $v}';
  }
}
