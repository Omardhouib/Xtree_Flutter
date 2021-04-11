// To parse this JSON data, do
//
//     final locationdetails = locationdetailsFromJson(jsonString);

import 'package:meta/meta.dart';
import 'package:sidebar_animation/Models/Location.dart';
import 'dart:convert';

import 'package:sidebar_animation/Models/Sensor.dart';

Locationdetails locationdetailsFromJson(String str) => Locationdetails.fromJson(json.decode(str));

String locationdetailsToJson(Locationdetails data) => json.encode(data.toJson());

class Locationdetails {
  Locationdetails({
     this.location,
     this.sensData,
     this.electro,

  });

  Location location;
  List<Sensor> sensData;
  List<Sensor> electro;


  factory Locationdetails.fromJson(Map<String, dynamic> json) => Locationdetails(
    location: json["location"] == null ? null : Location.fromJson(json["location"]),
    sensData: json["sensData"] == null ? null : List<Sensor>.from(json["sensData"].map((x) => Sensor.fromJson(x))),
    electro: json["electro"] == null ? null : List<Sensor>.from(json["electro"].map((x) => Sensor.fromJson(x))),

  );

  Map<String, dynamic> toJson() => {
    "location": location.toJson(),
    "sensData": List<dynamic>.from(sensData.map((x) => x.toJson())),
    "electro": List<dynamic>.from(electro.map((x) => x.toJson())),

  };
}
