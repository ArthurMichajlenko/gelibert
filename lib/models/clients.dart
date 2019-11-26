import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

List<Clients> clientsFromJson(String str) {
  final jsonData = json.decode(str);
  return new List<Clients>.from(jsonData.map((x) => Clients.fromJson(x)));
}

String clientsToJson(List<Clients> data) {
  final dyn = new List<dynamic>.from(data.map((x) => x.toJson()));
  return json.encode(dyn);
}

Future<Clients> getClient(Database db, int orderId) async {
  List<Map<String, dynamic>> sqlDataClients =
      await db.query('clients', where: 'id = ?', whereArgs: [orderId]);
  return List<Clients>.from(sqlDataClients.map((x) => Clients.fromSQL(x)))[0];
}

class Clients {
  int id;
  String name;
  String tel;
  String address;

  Clients({
    this.id,
    this.name,
    this.tel,
    this.address,
  });

  Widget clientData(Database db, int id) {
    return FutureBuilder<Clients>(
      builder: (context, clientSnap) {
        if (clientSnap.connectionState == ConnectionState.none ||
            clientSnap.connectionState == ConnectionState.waiting ||
            clientSnap.hasData == null) {
          return Center(child: CircularProgressIndicator());
        }
        return Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Контрагент',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                  color: Colors.grey,
                ),
              ),
              Text(
                clientSnap.data.name,
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              Text(
                'Адрес',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                  color: Colors.grey,
                ),
              ),
              Text(
                clientSnap.data.address,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        );
      },
      future: getClient(db, id),
    );
  }

  factory Clients.fromJson(Map<String, dynamic> json) => new Clients(
        id: json["id"],
        name: json["name"],
        tel: json["tel"],
        address: json["address"],
      );

  factory Clients.fromSQL(Map<String, dynamic> sql) => new Clients(
        id: sql["id"],
        name: sql["name"],
        tel: sql["tel"],
        address: sql["address"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "tel": tel,
        "address": address,
      };
}
