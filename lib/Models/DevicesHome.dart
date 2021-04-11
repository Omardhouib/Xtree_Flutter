// To parse this JSON data, do
//
//     final devicesHome = devicesHomeFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

import 'package:sidebar_animation/Models/Sensor.dart';

DevicesHome devicesHomeFromJson(String str) => DevicesHome.fromJson(json.decode(str));

String devicesHomeToJson(DevicesHome data) => json.encode(data.toJson());

class DevicesHome {
  DevicesHome({
    @required this.sensors,
    @required this.electro,
  });

  List<Sensor> sensors;
  List<Sensor> electro;

  factory DevicesHome.fromJson(Map<String, dynamic> json) => DevicesHome(
    sensors: json["Sensors"] == null ? null : List<Sensor>.from(json["Sensors"].map((x) => Sensor.fromJson(x))),
    electro: json["Electro"] == null ? null : List<Sensor>.from(json["Electro"].map((x) => Sensor.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "Sensors": List<dynamic>.from(sensors.map((x) => x.toJson())),
    "Electro": List<dynamic>.from(electro.map((x) => x.toJson())),
  };
}

