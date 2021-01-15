import 'dart:convert';
import 'package:sqflite/sqflite.dart';

List<Geodata> geodataFromJson(String str) {
  final jsonData = json.decode(str);
  return new List<Geodata>.from(jsonData.map((x) => Geodata.fromJson(x)));
}

String geodataToJson(List<Geodata> data) {
  final dyn = new List<dynamic>.from(data.map((x) => x.toJson()));
  return json.encode(dyn);
}

Future<List<Geodata>> getGeodata(Database db) async {
  List<Map<String, dynamic>> sqlGeoData = await db.query('geodata');
  return List<Geodata>.from(sqlGeoData.map((x) => Geodata.fromSQL(x)));
}

class Geodata {
  int id;
  double latitude;
  double longitude;
  String timestamp;

  Geodata({
    this.id,
    this.latitude,
    this.longitude,
    this.timestamp,
  });

  factory Geodata.fromJson(Map<String, dynamic> json) => new Geodata(
        id: json["id"],
        latitude: json["latitude"].toDouble(),
        longitude: json["longitude"].toDouble(),
        timestamp: json["timestamp"],
      );

  factory Geodata.fromSQL(Map<String, dynamic> sql) => new Geodata(
        id: sql["id"],
        latitude: sql["latitude"].toDouble(),
        longitude: sql["longitude"].toDouble(),
        timestamp: sql["timestamp"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "latitude": latitude,
        "longitude": longitude,
        "timestamp": timestamp,
      };

  Map<String, dynamic> toSQL() => {
        "id": id,
        "latitude": latitude,
        "longitude": longitude,
        "timestamp": timestamp,
      };
}
