// To parse this JSON data, do
//
//     final relay = relayFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';



class Relay {
  Relay({
    @required this.itemId,
    @required this.itemText,
  });

  String itemId;
  String itemText;

  factory Relay.fromJson(Map<String, dynamic> json) => Relay(
    itemId: json["item_id"] == null ? null : json["item_id"],
    itemText: json["item_text"] == null ? null : json["item_text"],
  );

  Map<String, dynamic> toJson() => {
    "item_id": itemId,
    "item_text": itemText,
  };

  static  List<Relay> relayFromJson(String str) => List<Relay>.from(json.decode(str).map((x) => Relay.fromJson(x)));

  static String relayToJson(List<Relay> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

  @override
  String toString() {
    return '{item_id: $itemId, item_text: $itemText}';
  }
}