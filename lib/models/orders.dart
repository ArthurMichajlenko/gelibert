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
  bool delivered;
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
    bool _delivered = sqlOrders["delivered"] == 0 ? false : true;
    return new Orders(
      id: sqlOrders["id"],
      courierId: sqlOrders["courier_id"],
      clientId: sqlOrders["client_id"],
      paymentMethod: sqlOrders["payment_method"],
      consists: List<Consist>(),
      orderCost: sqlOrders["order_cost"],
      delivered: _delivered,
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
                  // child: Icon(Icons.shopping_basket),
                  child: Text(ordersSnap.data[index].id.toString()),
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
  // await Future.delayed(Duration(seconds: 3));
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
  // return ordersFromJson(
  //     '[{"id":0,"courier_id":0,"client_id":0,"payment_method":"Cash","consists":[{"product":"ProductTo_0/0","quantity":1,"delivery":true},{"product":"ProductFrom_0/1","quantity":2,"delivery":false},{"product":"ProductTo_0/2","quantity":3,"delivery":true},{"product":"ProductFrom_0/3","quantity":4,"delivery":false}],"order_cost":5,"delivered":false,"delivery_delay":0,"date_start":"2019-11-15 12:46:20","date_finish":""},{"id":1,"courier_id":1,"client_id":1,"payment_method":"Cash","consists":[{"product":"ProductTo_1/0","quantity":1,"delivery":true},{"product":"ProductFrom_1/1","quantity":2,"delivery":false},{"product":"ProductTo_1/2","quantity":3,"delivery":true},{"product":"ProductFrom_1/3","quantity":4,"delivery":false}],"order_cost":15,"delivered":false,"delivery_delay":0,"date_start":"2019-11-15 12:46:20","date_finish":""},{"id":2,"courier_id":2,"client_id":2,"payment_method":"Cash","consists":[{"product":"ProductTo_2/0","quantity":1,"delivery":true},{"product":"ProductFrom_2/1","quantity":2,"delivery":false},{"product":"ProductTo_2/2","quantity":3,"delivery":true},{"product":"ProductFrom_2/3","quantity":4,"delivery":false}],"order_cost":25,"delivered":false,"delivery_delay":0,"date_start":"2019-11-15 12:46:20","date_finish":""},{"id":3,"courier_id":3,"client_id":3,"payment_method":"Cash","consists":[{"product":"ProductTo_3/0","quantity":1,"delivery":true},{"product":"ProductFrom_3/1","quantity":2,"delivery":false},{"product":"ProductTo_3/2","quantity":3,"delivery":true},{"product":"ProductFrom_3/3","quantity":4,"delivery":false}],"order_cost":35,"delivered":false,"delivery_delay":0,"date_start":"2019-11-15 12:46:20","date_finish":""},{"id":4,"courier_id":4,"client_id":4,"payment_method":"Cash","consists":[{"product":"ProductTo_4/0","quantity":1,"delivery":true},{"product":"ProductFrom_4/1","quantity":2,"delivery":false},{"product":"ProductTo_4/2","quantity":3,"delivery":true},{"product":"ProductFrom_4/3","quantity":4,"delivery":false}],"order_cost":45,"delivered":false,"delivery_delay":0,"date_start":"2019-11-15 12:46:20","date_finish":""},{"id":5,"courier_id":5,"client_id":5,"payment_method":"Cash","consists":[{"product":"ProductTo_5/0","quantity":1,"delivery":true},{"product":"ProductFrom_5/1","quantity":2,"delivery":false},{"product":"ProductTo_5/2","quantity":3,"delivery":true},{"product":"ProductFrom_5/3","quantity":4,"delivery":false}],"order_cost":55,"delivered":false,"delivery_delay":0,"date_start":"2019-11-15 12:46:20","date_finish":""},{"id":6,"courier_id":6,"client_id":6,"payment_method":"Cash","consists":[{"product":"ProductTo_6/0","quantity":1,"delivery":true},{"product":"ProductFrom_6/1","quantity":2,"delivery":false},{"product":"ProductTo_6/2","quantity":3,"delivery":true},{"product":"ProductFrom_6/3","quantity":4,"delivery":false}],"order_cost":65,"delivered":false,"delivery_delay":0,"date_start":"2019-11-15 12:46:20","date_finish":""},{"id":7,"courier_id":7,"client_id":7,"payment_method":"Cash","consists":[{"product":"ProductTo_7/0","quantity":1,"delivery":true},{"product":"ProductFrom_7/1","quantity":2,"delivery":false},{"product":"ProductTo_7/2","quantity":3,"delivery":true},{"product":"ProductFrom_7/3","quantity":4,"delivery":false}],"order_cost":75,"delivered":false,"delivery_delay":0,"date_start":"2019-11-15 12:46:20","date_finish":""},{"id":8,"courier_id":8,"client_id":8,"payment_method":"Cash","consists":[{"product":"ProductTo_8/0","quantity":1,"delivery":true},{"product":"ProductFrom_8/1","quantity":2,"delivery":false},{"product":"ProductTo_8/2","quantity":3,"delivery":true},{"product":"ProductFrom_8/3","quantity":4,"delivery":false}],"order_cost":85,"delivered":false,"delivery_delay":0,"date_start":"2019-11-15 12:46:20","date_finish":""},{"id":9,"courier_id":9,"client_id":9,"payment_method":"Cash","consists":[{"product":"ProductTo_9/0","quantity":1,"delivery":true},{"product":"ProductFrom_9/1","quantity":2,"delivery":false},{"product":"ProductTo_9/2","quantity":3,"delivery":true},{"product":"ProductFrom_9/3","quantity":4,"delivery":false}],"order_cost":95,"delivered":false,"delivery_delay":0,"date_start":"2019-11-15 12:46:20","date_finish":""},{"id":10,"courier_id":10,"client_id":10,"payment_method":"Cash","consists":[{"product":"ProductTo_10/0","quantity":1,"delivery":true},{"product":"ProductFrom_10/1","quantity":2,"delivery":false},{"product":"ProductTo_10/2","quantity":3,"delivery":true},{"product":"ProductFrom_10/3","quantity":4,"delivery":false}],"order_cost":105,"delivered":false,"delivery_delay":0,"date_start":"2019-11-15 12:46:20","date_finish":""},{"id":11,"courier_id":11,"client_id":11,"payment_method":"Cash","consists":[{"product":"ProductTo_11/0","quantity":1,"delivery":true},{"product":"ProductFrom_11/1","quantity":2,"delivery":false},{"product":"ProductTo_11/2","quantity":3,"delivery":true},{"product":"ProductFrom_11/3","quantity":4,"delivery":false}],"order_cost":115,"delivered":false,"delivery_delay":0,"date_start":"2019-11-15 12:46:20","date_finish":""},{"id":12,"courier_id":12,"client_id":12,"payment_method":"Cash","consists":[{"product":"ProductTo_12/0","quantity":1,"delivery":true},{"product":"ProductFrom_12/1","quantity":2,"delivery":false},{"product":"ProductTo_12/2","quantity":3,"delivery":true},{"product":"ProductFrom_12/3","quantity":4,"delivery":false}],"order_cost":125,"delivered":false,"delivery_delay":0,"date_start":"2019-11-15 12:46:20","date_finish":""},{"id":13,"courier_id":13,"client_id":13,"payment_method":"Cash","consists":[{"product":"ProductTo_13/0","quantity":1,"delivery":true},{"product":"ProductFrom_13/1","quantity":2,"delivery":false},{"product":"ProductTo_13/2","quantity":3,"delivery":true},{"product":"ProductFrom_13/3","quantity":4,"delivery":false}],"order_cost":135,"delivered":false,"delivery_delay":0,"date_start":"2019-11-15 12:46:20","date_finish":""},{"id":14,"courier_id":14,"client_id":14,"payment_method":"Cash","consists":[{"product":"ProductTo_14/0","quantity":1,"delivery":true},{"product":"ProductFrom_14/1","quantity":2,"delivery":false},{"product":"ProductTo_14/2","quantity":3,"delivery":true},{"product":"ProductFrom_14/3","quantity":4,"delivery":false}],"order_cost":145,"delivered":false,"delivery_delay":0,"date_start":"2019-11-15 12:46:20","date_finish":""},{"id":15,"courier_id":15,"client_id":15,"payment_method":"Cash","consists":[{"product":"ProductTo_15/0","quantity":1,"delivery":true},{"product":"ProductFrom_15/1","quantity":2,"delivery":false},{"product":"ProductTo_15/2","quantity":3,"delivery":true},{"product":"ProductFrom_15/3","quantity":4,"delivery":false}],"order_cost":155,"delivered":false,"delivery_delay":0,"date_start":"2019-11-15 12:46:20","date_finish":""},{"id":16,"courier_id":16,"client_id":16,"payment_method":"Cash","consists":[{"product":"ProductTo_16/0","quantity":1,"delivery":true},{"product":"ProductFrom_16/1","quantity":2,"delivery":false},{"product":"ProductTo_16/2","quantity":3,"delivery":true},{"product":"ProductFrom_16/3","quantity":4,"delivery":false}],"order_cost":165,"delivered":false,"delivery_delay":0,"date_start":"2019-11-15 12:46:20","date_finish":""},{"id":17,"courier_id":17,"client_id":17,"payment_method":"Cash","consists":[{"product":"ProductTo_17/0","quantity":1,"delivery":true},{"product":"ProductFrom_17/1","quantity":2,"delivery":false},{"product":"ProductTo_17/2","quantity":3,"delivery":true},{"product":"ProductFrom_17/3","quantity":4,"delivery":false}],"order_cost":175,"delivered":false,"delivery_delay":0,"date_start":"2019-11-15 12:46:20","date_finish":""},{"id":18,"courier_id":18,"client_id":18,"payment_method":"Cash","consists":[{"product":"ProductTo_18/0","quantity":1,"delivery":true},{"product":"ProductFrom_18/1","quantity":2,"delivery":false},{"product":"ProductTo_18/2","quantity":3,"delivery":true},{"product":"ProductFrom_18/3","quantity":4,"delivery":false}],"order_cost":185,"delivered":false,"delivery_delay":0,"date_start":"2019-11-15 12:46:20","date_finish":""},{"id":19,"courier_id":19,"client_id":19,"payment_method":"Cash","consists":[{"product":"ProductTo_19/0","quantity":1,"delivery":true},{"product":"ProductFrom_19/1","quantity":2,"delivery":false},{"product":"ProductTo_19/2","quantity":3,"delivery":true},{"product":"ProductFrom_19/3","quantity":4,"delivery":false}],"order_cost":195,"delivered":false,"delivery_delay":0,"date_start":"2019-11-15 12:46:20","date_finish":""}]');
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
