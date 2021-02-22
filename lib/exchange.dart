import 'dart:io';

import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:http/http.dart' as http;

import 'models/orders.dart';
import 'models/couriers.dart';
import 'models/clients.dart';
import 'package:gilebert/main.dart';

Future<void> fetchDataToSQL(Database db, String url) async {
  http.Response response;
  List<Orders> orders;
  Couriers couriers;
  List<Clients> clients;
  try {
    //Fetch couriers
    response = await http.get(url + "/data/couriers", headers: {HttpHeaders.authorizationHeader: "Bearer " + token});
    if (response.statusCode != 200) {
      connected = false;
      return;
    } else {
      connected = true;
      couriers = couriersFromJson(response.body);
      await db.insert('couriers', couriers.toSQL(), conflictAlgorithm: ConflictAlgorithm.replace);
    }
    //Fetch clients
    response = await http.get(url + "/data/clients", headers: {HttpHeaders.authorizationHeader: "Bearer " + token});
    if (response.statusCode != 200) {
      connected = false;
      return;
    } else {
      connected = true;
      clients = clientsFromJson(response.body);
      clients.forEach((x) async {
        await db.insert('clients', x.toSQL(), conflictAlgorithm: ConflictAlgorithm.replace);
        return;
      });
    }
    // Fetch orders
    response = await http.get(url + "/data/orders", headers: {HttpHeaders.authorizationHeader: "Bearer " + token});
    routLists.clear();
    switch (response.statusCode) {
      case 200:
        connected = true;
        isOrdersEmpty = false;
        orders = ordersFromJson(response.body);
        var sqlRes = await db.query('orders');
        if (sqlRes.isNotEmpty) {
          await db.delete('orders', where: "date_start <= date('now', '-1 day')");
        }
        orders.forEach((x) async {
          routLists.add(x.orderRoutlist);
          await db.insert('orders', x.toSQL(), conflictAlgorithm: ConflictAlgorithm.replace);
          x.consists.forEach((y) async {
            return await db.insert('consists', y.toSQL(), conflictAlgorithm: ConflictAlgorithm.replace);
          });
          return;
        });
        break;
      case 204:
        isOrdersEmpty = true;
        var sqlRes = await db.query('orders');
        if (sqlRes.isNotEmpty) {
          await db.delete('orders', where: "date_start <= date('now', '-1 day')");
        }
        break;
      default:
        (Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM orders')) == 0) ? isOrdersEmpty = true : isOrdersEmpty = false;
        connected = false;
        return;
    }
  } catch (e) {
    print(e);
    (Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM orders')) == 0) ? isOrdersEmpty = true : isOrdersEmpty = false;
    connected = false;
    return;
  }
}

Future<void> sendToServer(Database db, String url, {@required List<String> id}) async {
  List<Orders> orders = [];
  List<Consist> consists = [];
  id.forEach((orderId) async {
    await db.query(
      'consists',
      where: 'orders_id = ?',
      whereArgs: [orderId],
    ).then((sql) => sql.forEach((sqlConsists) => consists.add(Consist.fromSQL(sqlConsists))));
    await db.query(
      'orders',
      where: 'id = ?',
      whereArgs: [orderId],
    ).then((sql) => sql.forEach((sqlOrders) => orders.add(Orders.fromSQL(sqlOrders))));
    orders[0].consists = consists;
    print(orders[0].consists[1].extInfo);
    print(ordersToJson(orders));
    print(url);
  });
}
