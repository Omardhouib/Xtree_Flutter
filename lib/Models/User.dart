// To parse this JSON data, do
//
//     final user = userFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

User userFromJson(String str) => User.fromJson(json.decode(str));

String userToJson(User data) => json.encode(data.toJson());

class User {
  User({
    @required this.notifications,
    @required this.createdDate,
    @required this.locationIds,
    @required this.jobIds,
    @required this.id,
    @required this.firstName,
    @required this.lastName,
    @required this.email,
    @required this.password,
    @required this.enabled,
    @required this.v,
  });

  Notifications notifications;
  DateTime createdDate;
  List<String> locationIds;
  List<dynamic> jobIds;
  String id;
  String firstName;
  String lastName;
  String email;
  String password;
  int enabled;
  int v;

  factory User.fromJson(Map<String, dynamic> json) => User(
    notifications: json["Notifications"] == null ? null : Notifications.fromJson(json["Notifications"]),
    createdDate: json["Created_date"] == null ? null : DateTime.parse(json["Created_date"]),
    locationIds: json["Location_ids"] == null ? null : List<String>.from(json["Location_ids"].map((x) => x)),
    jobIds: json["Job_ids"] == null ? null : List<dynamic>.from(json["Job_ids"].map((x) => x)),
    id: json["_id"] == null ? null : json["_id"],
    firstName: json["FirstName"] == null ? null : json["FirstName"],
    lastName: json["LastName"] == null ? null : json["LastName"],
    email: json["email"] == null ? null : json["email"],
    password: json["password"] == null ? null : json["password"],
    enabled: json["enabled"] == null ? null : json["enabled"],
    v: json["__v"] == null ? null : json["__v"],
  );

  Map<String, dynamic> toJson() => {
    "Notifications": notifications.toJson(),
    "Created_date": createdDate.toIso8601String(),
    "Location_ids": List<dynamic>.from(locationIds.map((x) => x)),
    "Job_ids": List<dynamic>.from(jobIds.map((x) => x)),
    "_id": id,
    "FirstName": firstName,
    "LastName": lastName,
    "email": email,
    "password": password,
    "enabled": enabled,
    "__v": v,
  };
}

class Notifications {
  Notifications({
    @required this.email,
    @required this.push,
    @required this.sms,
  });

  bool email;
  bool push;
  bool sms;

  factory Notifications.fromJson(Map<String, dynamic> json) => Notifications(
    email: json["Email"] == null ? null : json["Email"],
    push: json["Push"] == null ? null : json["Push"],
    sms: json["SMS"] == null ? null : json["SMS"],
  );

  Map<String, dynamic> toJson() => {
    "Email": email,
    "Push": push,
    "SMS": sms,
  };
}
