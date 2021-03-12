// To parse this JSON data, do
//
//     final homeLocation = homeLocationFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

import 'package:sidebar_animation/Models/Location.dart';
import 'package:sidebar_animation/Models/Sensor.dart';

HomeLocation homeLocationFromJson(String str) => HomeLocation.fromJson(json.decode(str));

String homeLocationToJson(HomeLocation data) => json.encode(data.toJson());

class HomeLocation {
  HomeLocation({
    @required this.weather,
    @required this.locations,
    @required this.sensors,
    @required this.sensor,
  });


  List<HomeLocationWeather> weather;
  List<Locationn> locations;
  List<Sensor> sensors;
  List<Sensor> sensor;

  factory HomeLocation.fromJson(Map<String, dynamic> json) => HomeLocation(
    weather: List<HomeLocationWeather>.from(json["weather"].map((x) => HomeLocationWeather.fromJson(x))),
    locations: List<Locationn>.from(json["locations"].map((x) => Locationn.fromJson(x))),
    sensors: List<Sensor>.from(json["sensors"].map((x) => Sensor.fromJson(x))),
    sensor: List<Sensor>.from(json["Sensor"].map((x) => Sensor.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "weather": List<dynamic>.from(weather.map((x) => x.toJson())),
    "locations": List<dynamic>.from(locations.map((x) => x.toJson())),
    "sensors": List<dynamic>.from(sensors.map((x) => x.toJson())),
    "Sensor": List<dynamic>.from(sensor.map((x) => x.toJson())),
  };
}
class Locationn {
  Locationn({
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

  factory Locationn.fromJson(Map<String, dynamic> json) => Locationn(
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
}


class HomeLocationWeather {
  HomeLocationWeather({
    @required this.dt,
    @required this.sunrise,
    @required this.sunset,
    @required this.temp,
    @required this.feelsLike,
    @required this.pressure,
    @required this.humidity,
    @required this.dewPoint,
    @required this.windSpeed,
    @required this.windDeg,
    @required this.weather,
    @required this.clouds,
    @required this.pop,
    @required this.uvi,
  });

  int dt;
  int sunrise;
  int sunset;
  Temp temp;
  FeelsLike feelsLike;
  int pressure;
  int humidity;
  double dewPoint;
  double windSpeed;
  int windDeg;
  List<WeatherWeather> weather;
  int clouds;
  double pop;
  double uvi;

  factory HomeLocationWeather.fromJson(Map<String, dynamic> json) => HomeLocationWeather(
    dt: json["dt"],
    sunrise: json["sunrise"],
    sunset: json["sunset"],
    temp: Temp.fromJson(json["temp"]),
    feelsLike: FeelsLike.fromJson(json["feels_like"]),
    pressure: json["pressure"],
    humidity: json["humidity"],
    dewPoint: json["dew_point"].toDouble(),
    windSpeed: json["wind_speed"].toDouble(),
    windDeg: json["wind_deg"],
    weather: List<WeatherWeather>.from(json["weather"].map((x) => WeatherWeather.fromJson(x))),
    clouds: json["clouds"],
    pop: json["pop"].toDouble(),
    uvi: json["uvi"].toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "dt": dt,
    "sunrise": sunrise,
    "sunset": sunset,
    "temp": temp.toJson(),
    "feels_like": feelsLike.toJson(),
    "pressure": pressure,
    "humidity": humidity,
    "dew_point": dewPoint,
    "wind_speed": windSpeed,
    "wind_deg": windDeg,
    "weather": List<dynamic>.from(weather.map((x) => x.toJson())),
    "clouds": clouds,
    "pop": pop,
    "uvi": uvi,
  };
}

class FeelsLike {
  FeelsLike({
    @required this.day,
    @required this.night,
    @required this.eve,
    @required this.morn,
  });

  double day;
  double night;
  double eve;
  double morn;

  factory FeelsLike.fromJson(Map<String, dynamic> json) => FeelsLike(
    day: json["day"].toDouble(),
    night: json["night"].toDouble(),
    eve: json["eve"].toDouble(),
    morn: json["morn"].toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "day": day,
    "night": night,
    "eve": eve,
    "morn": morn,
  };
}

class Temp {
  Temp({
    @required this.day,
    @required this.min,
    @required this.max,
    @required this.night,
    @required this.eve,
    @required this.morn,
  });

  double day;
  double min;
  double max;
  double night;
  double eve;
  double morn;

  factory Temp.fromJson(Map<String, dynamic> json) => Temp(
    day: json["day"].toDouble(),
    min: json["min"].toDouble(),
    max: json["max"].toDouble(),
    night: json["night"].toDouble(),
    eve: json["eve"].toDouble(),
    morn: json["morn"].toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "day": day,
    "min": min,
    "max": max,
    "night": night,
    "eve": eve,
    "morn": morn,
  };
}

class WeatherWeather {
  WeatherWeather({
    @required this.id,
    @required this.main,
    @required this.description,
    @required this.icon,
  });

  int id;
  String main;
  String description;
  String icon;

  factory WeatherWeather.fromJson(Map<String, dynamic> json) => WeatherWeather(
    id: json["id"],
    main: json["main"],
    description: json["description"],
    icon: json["icon"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "main": main,
    "description": description,
    "icon": icon,
  };
}
