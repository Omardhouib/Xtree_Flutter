// To parse this JSON data, do
//
//     final user = userFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

User userFromJson(String str) => User.fromJson(json.decode(str));

String userToJson(User data) => json.encode(data.toJson());

class User {
  User({
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

  DateTime createdDate;
  List<dynamic> locationIds;
  List<dynamic> jobIds;
  String id;
  String firstName;
  String lastName;
  String email;
  String password;
  int enabled;
  int v;

  factory User.fromJson(Map<String, dynamic> json) => User(
    createdDate: DateTime.parse(json["Created_date"]),
    locationIds: List<dynamic>.from(json["Location_ids"].map((x) => x)),
    jobIds: List<dynamic>.from(json["Job_ids"].map((x) => x)),
    id: json["_id"],
    firstName: json["FirstName"],
    lastName: json["LastName"],
    email: json["email"],
    password: json["password"],
    enabled: json["enabled"],
    v: json["__v"],
  );

  Map<String, dynamic> toJson() => {
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
