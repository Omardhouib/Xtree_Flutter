// To parse this JSON data, do
//
//     final weather = weatherFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

List<Weather> weatherFromJson(String str) => List<Weather>.from(json.decode(str).map((x) => Weather.fromJson(x)));

String weatherToJson(List<Weather> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Weather {
  Weather({
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
  List<WeatherElement> weather;
  int clouds;
  double pop;
  double uvi;

  factory Weather.fromJson(Map<String, dynamic> json) => Weather(
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
    weather: List<WeatherElement>.from(json["weather"].map((x) => WeatherElement.fromJson(x))),
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

class WeatherElement {
  WeatherElement({
    @required this.id,
    @required this.main,
    @required this.description,
    @required this.icon,
  });

  int id;
  String main;
  String description;
  String icon;

  factory WeatherElement.fromJson(Map<String, dynamic> json) => WeatherElement(
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
