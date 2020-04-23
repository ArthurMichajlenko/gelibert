import 'dart:convert';
// import 'dart:js';

import 'package:flutter/material.dart';
import 'package:sqflite/sqlite_api.dart';

List<Couriers> couriersFromJson(String str) {
  final jsonData = json.decode(str);
  return new List<Couriers>.from(jsonData.map((x) => Couriers.fromJson(x)));
}

String couriersToJson(List<Couriers> data) {
  final dyn = new List<dynamic>.from(data.map((x) => x.toJson()));
  return json.encode(dyn);
}

Future<Couriers> getCourier(Database db, int imei) async {
  List<Map<String, dynamic>> sqlDataCouriers =
      await db.query('couriers', where: 'imei = ?', whereArgs: [imei]);
  return List<Couriers>.from(
      sqlDataCouriers.map((x) => Couriers.fromSQL(x)))[0];
}

class Couriers {
  int id;
  int imei;
  String tel;
  String name;
  String carNumber;
  double latitude;
  double longitude;
  String address;
  String timestamp;

  Couriers({
    this.id,
    this.imei,
    this.tel,
    this.name,
    this.carNumber,
    this.latitude,
    this.longitude,
    this.address,
    this.timestamp,
  });

  Widget courierName(Database db, int imei) {
    return FutureBuilder<Couriers>(
      builder: (context, snap) {
        if (snap.connectionState == ConnectionState.none ||
            snap.connectionState == ConnectionState.waiting ||
            snap.hasData == null) {
          return Center(child: CircularProgressIndicator());
        }
        return Text(snap.data.name);
      },
      future: getCourier(db, imei),
    );
  }

  Widget courierCarNumber(Database db, int imei) {
    return FutureBuilder<Couriers>(
      builder: (context, snap) {
        if (snap.connectionState == ConnectionState.none ||
            snap.connectionState == ConnectionState.waiting ||
            snap.hasData == null) {
          return Center(child: CircularProgressIndicator());
        }
        return Text(snap.data.carNumber);
      },
      future: getCourier(db, imei),
    );
  }

  factory Couriers.fromJson(Map<String, dynamic> json) => new Couriers(
        id: json["id"],
        imei: json["imei"],
        tel: json["tel"],
        name: json["name"],
        carNumber: json["car_number"],
        latitude: json["latitude"].toDouble(),
        longitude: json["longitude"].toDouble(),
        address: json["address"],
        timestamp: json["timestamp"],
      );

  factory Couriers.fromSQL(Map<String, dynamic> sql) => new Couriers(
        id: sql["id"],
        imei: sql["imei"],
        tel: sql["tel"],
        name: sql["name"],
        carNumber: sql["car_number"],
        latitude: sql["latitude"],
        longitude: sql["longitude"],
        address: sql["address"],
        timestamp: sql["timestamp"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "imei": imei,
        "tel": tel,
        "name": name,
        "car_number": carNumber,
        "latitude": latitude,
        "longitude": longitude,
        "address": address,
        "timestamp": timestamp,
      };

  Map<String, dynamic> toSQL() => {
        "id": id,
        "imei": imei,
        "tel": tel,
        "name": name,
        "car_number": carNumber,
        "latitude": latitude,
        "longitude": longitude,
        "address": address,
        "timestamp": timestamp,
      };
}
