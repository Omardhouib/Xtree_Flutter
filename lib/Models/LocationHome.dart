// To parse this JSON data, do
//
//     final locationHome = locationHomeFromJson(jsonString);

import 'package:meta/meta.dart';
import 'package:sidebar_animation/Models/Location.dart';
import 'dart:convert';

import 'package:sidebar_animation/Models/Sensor.dart';

LocationHome locationHomeFromJson(String str) => LocationHome.fromJson(json.decode(str));

String locationHomeToJson(LocationHome data) => json.encode(data.toJson());

class LocationHome {
  LocationHome({
    @required this.locations,
    @required this.sensors,
    @required this.electro,
    @required this.sol,
  });

  Location locations;
  List<Sensor> sensors;
  List<Sensor> electro;
  Sensor sol;

  factory LocationHome.fromJson(Map<String, dynamic> json) => LocationHome(
    locations: json["Locations"] == null ? null : Location.fromJson(json["Locations"]),
    sensors: json["Sensors"] == null ? null : List<Sensor>.from(json["Sensors"].map((x) => Sensor.fromJson(x))),
    electro: json["Electro"] == null ? null : List<Sensor>.from(json["Electro"].map((x) => Sensor.fromJson(x))),
    sol: json["Sol"] == null ? null : Sensor.fromJson(json["Sol"]),
  );

  Map<String, dynamic> toJson() => {
    "Locations": locations.toJson(),
    "Sensors": List<dynamic>.from(sensors.map((x) => x.toJson())),
    "Electro": List<dynamic>.from(electro.map((x) => x.toJson())),
    "Sol": sol.toJson(),
  };
}

