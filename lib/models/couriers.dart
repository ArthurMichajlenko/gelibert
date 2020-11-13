import 'dart:convert';
// import 'dart:js';

import 'package:flutter/material.dart';
import 'package:sqflite/sqlite_api.dart';
// import 'package:geolocator/geolocator.dart';

Couriers couriersFromJson(String str) {
  final jsonData = json.decode(str);
  return Couriers.fromJson(jsonData);
}

String couriersToJson(Couriers data) {
  final dyn = data.toJson();
  return json.encode(dyn);
}

Future<Couriers> getCourier(Database db, String macAddress) async {
  List<Map<String, dynamic>> sqlDataCouriers = await db
      .query('couriers', where: 'mac_address = ?', whereArgs: [macAddress]);
  return List<Couriers>.from(
      sqlDataCouriers.map((x) => Couriers.fromSQL(x)))[0];
}

class Couriers {
  String id;
  String macAddress;
  String tel;
  String name;
  String carNumber;
  double latitude;
  double longitude;
  String address;
  String timestamp;

  Couriers({
    this.id,
    this.macAddress,
    this.tel,
    this.name,
    this.carNumber,
    this.latitude,
    this.longitude,
    this.address,
    this.timestamp,
  });

  Widget courierName(Database db, String macAddress) {
    return FutureBuilder<Couriers>(
      builder: (context, snap) {
        if (snap.connectionState == ConnectionState.none ||
            snap.connectionState == ConnectionState.waiting ||
            snap.hasData == null) {
          return Center(child: CircularProgressIndicator());
        }
        return Text(snap.data.name);
      },
      future: getCourier(db, macAddress),
    );
  }

  Widget courierCarNumber(Database db, String macAddress) {
    return FutureBuilder<Couriers>(
      builder: (context, snap) {
        if (snap.connectionState == ConnectionState.none ||
            snap.connectionState == ConnectionState.waiting ||
            snap.hasData == null) {
          return Center(child: CircularProgressIndicator());
        }
        return Text(snap.data.carNumber);
      },
      future: getCourier(db, macAddress),
    );
  }

  factory Couriers.fromJson(Map<String, dynamic> json) => new Couriers(
        id: json["id"],
        macAddress: json["mac_address"],
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
        macAddress: sql["mac_address"],
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
        "mac_address": macAddress,
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
        "mac_address": macAddress,
        "tel": tel,
        "name": name,
        "car_number": carNumber,
        "latitude": latitude,
        "longitude": longitude,
        "address": address,
        "timestamp": timestamp,
      };
}
