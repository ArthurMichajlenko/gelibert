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
  List<Map<String, dynamic>> sqlDataCouriers = await db.query('couriers', where: 'mac_address = ?', whereArgs: [macAddress]);
  return List<Couriers>.from(sqlDataCouriers.map((x) => Couriers.fromSQL(x)))[0];
}

class Couriers {
  String id;
  String macAddress;
  String tel;
  String name;
  String carNumber;
  String timestamp;

  Couriers({
    this.id,
    this.macAddress,
    this.tel,
    this.name,
    this.carNumber,
    this.timestamp,
  });

  Widget courierName(Database db, String macAddress) {
    return FutureBuilder<Couriers>(
      builder: (context, snap) {
        if (snap.connectionState == ConnectionState.none || snap.connectionState == ConnectionState.waiting || snap.hasData == null) {
          return Center(child: CircularProgressIndicator());
        }
        return Text(
          snap.data.name,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        );
      },
      future: getCourier(db, macAddress),
    );
  }

  Widget courierCarNumber(Database db, String macAddress) {
    return FutureBuilder<Couriers>(
      builder: (context, snap) {
        if (snap.connectionState == ConnectionState.none || snap.connectionState == ConnectionState.waiting || snap.hasData == null) {
          return Center(child: CircularProgressIndicator());
        }
        return Text(
          snap.data.carNumber,
          style: TextStyle(
            fontSize: 24,
          ),
        );
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
        timestamp: json["timestamp"],
      );

  factory Couriers.fromSQL(Map<String, dynamic> sql) => new Couriers(
        id: sql["id"],
        macAddress: sql["mac_address"],
        tel: sql["tel"],
        name: sql["name"],
        carNumber: sql["car_number"],
        timestamp: sql["timestamp"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "mac_address": macAddress,
        "tel": tel,
        "name": name,
        "car_number": carNumber,
        "timestamp": timestamp,
      };

  Map<String, dynamic> toSQL() => {
        "id": id,
        "mac_address": macAddress,
        "tel": tel,
        "name": name,
        "car_number": carNumber,
        "timestamp": timestamp,
      };
}
