import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gilebert/models/clients.dart';
import 'package:sqflite/sqflite.dart';
import 'package:gilebert/order_detail.dart';

List<Orders> ordersFromJson(String str) {
  final jsonData = json.decode(str);
  return new List<Orders>.from(jsonData.map((x) => Orders.fromJson(x)));
}

String ordersToJson(List<Orders> data) {
  final dyn = new List<dynamic>.from(data.map((x) => x.toJson()));
  return json.encode(dyn);
}

class Orders {
  var _client = Clients();

  int id;
  int courierId;
  int clientId;
  String paymentMethod;
  List<Consist> consistsTo;
  List<Consist> consistsFrom;
  double orderCost;
  int delivered;
  int deliveryDelay;
  String dateStart;
  String dateFinish;

  Orders({
    this.id,
    this.courierId,
    this.clientId,
    this.paymentMethod,
    this.consistsTo,
    this.consistsFrom,
    this.orderCost,
    this.delivered,
    this.deliveryDelay,
    this.dateStart,
    this.dateFinish,
  });

  factory Orders.fromJson(Map<String, dynamic> json) => new Orders(
        id: json["id"],
        courierId: json["courier_id"],
        clientId: json["client_id"],
        paymentMethod: json["payment_method"],
        consistsTo: new List<Consist>.from(
            json["consists"].map((x) => Consist.fromJson(x))),
        consistsFrom: new List<Consist>.from(
            json["consists"].map((x) => Consist.fromJson(x))),
        orderCost: json["order_cost"].toDouble(),
        delivered: json["delivered"],
        deliveryDelay: json["delivery_delay"],
        dateStart: json["date_start"],
        dateFinish: json["date_finish"],
      );

  factory Orders.fromSQL(Map<String, dynamic> sqlOrders) {
    // bool _delivered = sqlOrders["delivered"] == 0 ? false : true;
    return new Orders(
      id: sqlOrders["id"],
      courierId: sqlOrders["courier_id"],
      clientId: sqlOrders["client_id"],
      paymentMethod: sqlOrders["payment_method"],
      consistsTo: List<Consist>(),
      consistsFrom: List<Consist>(),
      orderCost: sqlOrders["order_cost"],
      delivered: sqlOrders["delivered"],
      deliveryDelay: sqlOrders["delivery_delay"],
      dateStart: sqlOrders["date_start"],
      dateFinish: sqlOrders["date_finish"],
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "courier_id": courierId,
        "client_id": clientId,
        "payment_method": paymentMethod,
        "consists_to":
            new List<dynamic>.from(consistsTo.map((x) => x.toJson())),
        "consists_from":
            new List<dynamic>.from(consistsFrom.map((x) => x.toJson())),
        "order_cost": orderCost,
        "delivered": delivered,
        "delivery_delay": deliveryDelay,
        "date_start": dateStart,
        "date_finish": dateFinish,
      };

  Widget ordersListWidget(Database db, int delivered) {
    return FutureBuilder<List<Orders>>(
      builder: (context, ordersSnap) {
        if (ordersSnap.connectionState == ConnectionState.none ||
            ordersSnap.connectionState == ConnectionState.waiting ||
            ordersSnap.hasData == null) {
          return Center(child: CircularProgressIndicator());
        }
        return ListView.builder(
          // shrinkWrap: true,
          itemCount: ordersSnap.data.length,
          itemBuilder: (context, index) {
            return Card(
              child: ListTile(
                leading: Column(
                  children: <Widget>[
                    if (ordersSnap.data[index].delivered==-1)
                    CircleAvatar(
                      child: Text(ordersSnap.data[index].id.toString()),
                      backgroundColor: Colors.red,
                    ),
                    if (ordersSnap.data[index].delivered==1)
                    CircleAvatar(
                      child: Text(ordersSnap.data[index].id.toString()),
                      backgroundColor: Colors.green,
                      ),
                    if (ordersSnap.data[index].delivered==0)
                    CircleAvatar(
                      child: Text(ordersSnap.data[index].id.toString()),
                      backgroundColor: Colors.blue,
                      ),
                  ],
                ),
                isThreeLine: true,
                title: _client.clientData(db, ordersSnap.data[index].clientId),
                subtitle: Row(
                  children: <Widget>[
                    Text(ordersSnap.data[index].paymentMethod),
                  ],
                ),
                trailing: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Text(ordersSnap.data[index].consistsTo[0].product),
                    Text(ordersSnap.data[index].consistsTo[0].quantity
                        .toString()),
                    Text(ordersSnap.data[index].orderCost.toString() + ' Lei'),
                  ],
                ),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            OrderDetail(order: ordersSnap.data[index]),
                      ));
                },
              ),
            );
          },
        );
      },
      future: getOrdersList(db, delivered),
    );
  }
}

Future<List<Orders>> getOrdersList(Database db, int delivered) async {
  List<Map<String, dynamic>> sqlDataOrders;
  switch (delivered) {
    case -1:
    case 0:
    case 1:
      sqlDataOrders = await db
          .query('orders', where: 'delivered=?', whereArgs: [delivered]);
      break;
    default:
      sqlDataOrders = await db.query('orders');
  }
  List<Map<String, dynamic>> sqlDataConsistsTo = await db.query('consists_to');
  var consistsTo =
      List<Consist>.from(sqlDataConsistsTo.map((x) => Consist.fromSQL(x)));
  List<Map<String, dynamic>> sqlDataConsistsFrom =
      await db.query('consists_from');
  var consistsFrom =
      List<Consist>.from(sqlDataConsistsFrom.map((x) => Consist.fromSQL(x)));
  var orders = List<Orders>.from(sqlDataOrders.map((x) {
    var result = Orders.fromSQL(x);
    consistsTo.forEach((y) {
      if (y.id == result.id) {
        result.consistsTo.add(y);
      }
    });
    consistsFrom.forEach((y) {
      if (y.id == result.id) {
        result.consistsFrom.add(y);
      }
    });
    return result;
  }));
  return orders;
}

class Consist {
  int id;
  String product;
  double quantity;
  double price;

  Consist({
    this.id,
    this.product,
    this.quantity,
    this.price,
  });

  factory Consist.fromJson(Map<String, dynamic> json) => new Consist(
        product: json["product"],
        quantity: json["quantity"].toDouble(),
        price: json["price"],
      );

  factory Consist.fromSQL(Map<String, dynamic> sql) {
    return new Consist(
      id: sql["id"],
      product: sql["product"],
      quantity: sql["quantity"],
      price: sql["price"],
    );
  }

  Map<String, dynamic> toJson() => {
        "product": product,
        "quantity": quantity,
        "price": price,
      };
}
