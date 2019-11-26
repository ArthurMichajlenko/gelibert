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
  List<Consist> consists;
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
    this.consists,
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
        consists: new List<Consist>.from(
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
      consists: List<Consist>(),
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
        "consists": new List<dynamic>.from(consists.map((x) => x.toJson())),
        "order_cost": orderCost,
        "delivered": delivered,
        "delivery_delay": deliveryDelay,
        "date_start": dateStart,
        "date_finish": dateFinish,
      };

  Widget ordersListWidget(Database db) {
    return FutureBuilder<List<Orders>>(
      builder: (context, ordersSnap) {
        if (ordersSnap.connectionState == ConnectionState.none ||
            ordersSnap.connectionState == ConnectionState.waiting ||
            ordersSnap.hasData == null) {
          return Center(child: CircularProgressIndicator());
        }
        return ListView.builder(
          itemCount: ordersSnap.data.length,
          itemBuilder: (context, index) {
            return Card(
              child: ListTile(
                leading: CircleAvatar(
                  child: Text(ordersSnap.data[index].id.toString()),
                  // backgroundColor: Colors.grey,
                  // foregroundColor: Colors.black,
                ),
                isThreeLine: true,
                title: _client.clientData(db, ordersSnap.data[index].clientId),
                subtitle: Text(ordersSnap.data[index].paymentMethod),
                trailing: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Text(ordersSnap.data[index].consists[0].product),
                    Text(
                        ordersSnap.data[index].consists[0].quantity.toString()),
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
      future: getOrdersList(db),
    );
  }
}

Future<List<Orders>> getOrdersList(Database db) async {
  List<Map<String, dynamic>> sqlDataConsists = await db.query('consists');
  var consists =
      List<Consist>.from(sqlDataConsists.map((x) => Consist.fromSQL(x)));
  List<Map<String, dynamic>> sqlDataOrders = await db.query('orders');
  var orders = List<Orders>.from(sqlDataOrders.map((x) {
    var result = Orders.fromSQL(x);
    consists.forEach((y) {
      if (y.id == result.id) {
        result.consists.add(y);
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
  bool delivery;

  Consist({
    this.id,
    this.product,
    this.quantity,
    this.delivery,
  });

  factory Consist.fromJson(Map<String, dynamic> json) => new Consist(
        product: json["product"],
        quantity: json["quantity"].toDouble(),
        delivery: json["delivery"],
      );

  factory Consist.fromSQL(Map<String, dynamic> sql) {
    bool _delivery = sql["delivery"] == 0 ? false : true;
    return new Consist(
        id: sql["id"],
        product: sql["product"],
        quantity: sql["quantity"],
        delivery: _delivery);
  }

  Map<String, dynamic> toJson() => {
        "product": product,
        "quantity": quantity,
        "delivery": delivery,
      };
}
