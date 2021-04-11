// To parse this JSON data, do
//
//     final sensor = sensorFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

Sensor sensorFromJson(String str) => Sensor.fromJson(json.decode(str));

String sensorToJson(Sensor data) => json.encode(data.toJson());

class Sensor {
  Sensor({
    this.sensorCoordinates,
    this.createdDate,
    this.status,
    this.id,
    this.rules,
    this.sensorIdentifier,
    this.sensorType,
    this.v,
    this.description,
    this.name,
    this.uv,
  });

  List<double> sensorCoordinates;
  DateTime createdDate;
  bool status;
  String id;
  List<Rule> rules;
  String sensorIdentifier;
  String sensorType;
  int v;
  String description;
  String name;
  double uv;

  factory Sensor.fromJson(Map<String, dynamic> json) => Sensor(
    sensorCoordinates: json["SensorCoordinates"] == null ? null : List<double>.from(json["SensorCoordinates"].map((x) => x.toDouble())),
    createdDate: json["Created_date"] == null ? null : DateTime.parse(json["Created_date"]),
    status: json["status"] == null ? null : json["status"],
    id: json["_id"] == null ? null : json["_id"],
    rules: json["Rules"] == null ? null : List<Rule>.from(json["Rules"].map((x) => Rule.fromJson(x))),
    sensorIdentifier: json["SensorIdentifier"] == null ? null : json["SensorIdentifier"],
    sensorType: json["SensorType"] == null ? null : json["SensorType"],
    v: json["__v"] == null ? null : json["__v"],
    description: json["Description"] == null ? null : json["Description"],
    name: json["name"] == null ? null : json["name"],
    uv: json["uv"] == null ? null : json["uv"],
  );

  Map<String, dynamic> toJson() => {
    "SensorCoordinates": List<dynamic>.from(sensorCoordinates.map((x) => x)),
    "Created_date": createdDate.toIso8601String(),
    "status": status,
    "_id": id,
    "Rules": List<dynamic>.from(rules.map((x) => x.toJson())),
    "SensorIdentifier": sensorIdentifier,
    "SensorType": sensorType,
    "__v": v,
    "Description": description,
    "name": name,
    "uv": uv,
  };

  @override
  String toString() {
    return 'Sensor{sensorCoordinates: $sensorCoordinates, createdDate: $createdDate, status: $status, id: $id, rules: $rules, sensorIdentifier: $sensorIdentifier, sensorType: $sensorType, v: $v, description: $description, name: $name, uv: $uv}';
  }
}

class Rule {
  Rule({
    @required this.notifications,
    @required this.status,
    @required this.realyIds,
    @required this.id,
    @required this.startTime,
    @required this.tmax,
    @required this.tmin,
  });

  Notifications notifications;
  bool status;
  List<RealyId> realyIds;
  String id;
  int startTime;
  int tmax;
  int tmin;

  factory Rule.fromJson(Map<String, dynamic> json) => Rule(
    notifications: json["Notifications"] == null ? null : Notifications.fromJson(json["Notifications"]),
    status: json["Status"] == null ? null : json["Status"],
    realyIds: json["Realy_ids"] == null ? null : List<RealyId>.from(json["Realy_ids"].map((x) => RealyId.fromJson(x))),
    id: json["_id"] == null ? null : json["_id"],
    startTime: json["StartTime"] == null ? null : json["StartTime"],
    tmax: json["Tmax"] == null ? null : json["Tmax"],
    tmin: json["Tmin"] == null ? null : json["Tmin"],
  );

  Map<String, dynamic> toJson() => {
    "Notifications": notifications.toJson(),
    "Status": status,
    "Realy_ids": List<dynamic>.from(realyIds.map((x) => x.toJson())),
    "_id": id,
    "StartTime": startTime,
    "Tmax": tmax,
    "Tmin": tmin,
  };
}

class Notifications {
  Notifications({
    @required this.sms,
    @required this.email,
    @required this.push,
  });

  bool sms;
  bool email;
  bool push;

  factory Notifications.fromJson(Map<String, dynamic> json) => Notifications(
    sms: json["SMS"] == null ? null : json["SMS"],
    email: json["Email"] == null ? null : json["Email"],
    push: json["Push"] == null ? null : json["Push"],

  );

  Map<String, dynamic> toJson() => {
    "SMS": sms,
    "Email": email,
    "Push": push,
  };
}

class RealyId {
  RealyId({
    @required this.itemId,
    @required this.itemText,
  });

  String itemId;
  String itemText;

  factory RealyId.fromJson(Map<String, dynamic> json) => RealyId(
    itemId: json["item_id"] == null ? null : json["item_id"],
    itemText: json["item_text"] == null ? null : json["item_text"],
  );

  Map<String, dynamic> toJson() => {
    "item_id": itemId,
    "item_text": itemText,
  };
}
