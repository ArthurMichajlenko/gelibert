import 'dart:convert';
import 'dart:io';
import 'package:geolocator/geolocator.dart';
import 'package:sqflite/sqflite.dart';
import 'package:http/http.dart' as http;
import 'package:gilebert/main.dart';

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

Future<void> saveGeodata(Database db, String macAddress, String url) async {
  Geodata geodata;
  http.Response response;
  var courierId = await db.query('couriers', columns: ['courier_d'], where: 'mac_address = ?', whereArgs: [macAddress]);
  geodata.courierId = courierId[0]['courier_id'];
  geodata.macAddress = macAddress;
  var position = await Geolocator.getCurrentPosition();
  geodata.latitude = position.latitude;
  geodata.longitude = position.longitude;
  await db.insert('geodata', geodata.toSQL());
  try {
    response = await http.post(
      url + 'data/geodata',
      headers: {
        HttpHeaders.authorizationHeader: "Bearer " + token,
        HttpHeaders.contentTypeHeader: "application/json",
      },
      body: geodata.toJson(),
    );
    if (response.statusCode != HttpStatus.noContent) {
      connected = false;
      return;
    }
  } catch (e) {
    print(e);
  }
}

class Geodata {
  int id;
  double latitude;
  double longitude;
  String timestamp;
  String macAddress;
  String courierId;

  Geodata({
    this.id,
    this.latitude,
    this.longitude,
    this.timestamp,
    this.macAddress,
    this.courierId,
  });

  factory Geodata.fromJson(Map<String, dynamic> json) => new Geodata(
        id: json["id"],
        latitude: json["latitude"].toDouble(),
        longitude: json["longitude"].toDouble(),
        timestamp: json["timestamp"],
        macAddress: json["mac_address"],
        courierId: json["courier_id"],
      );

  factory Geodata.fromSQL(Map<String, dynamic> sql) => new Geodata(
        id: sql["id"],
        latitude: sql["latitude"].toDouble(),
        longitude: sql["longitude"].toDouble(),
        timestamp: sql["timestamp"],
        macAddress: sql["mac_address"],
        courierId: sql["courier_id"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "latitude": latitude,
        "longitude": longitude,
        "timestamp": timestamp,
        "mac_address": macAddress,
        "courier_id": courierId,
      };

  Map<String, dynamic> toSQL() => {
        "id": id,
        "latitude": latitude,
        "longitude": longitude,
        "timestamp": timestamp,
        "mac_address": macAddress,
        "courier_id": courierId,
      };
}
