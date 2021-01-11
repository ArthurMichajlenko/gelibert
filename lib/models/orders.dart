import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gilebert/main.dart';
import 'package:gilebert/models/clients.dart';
// import 'package:gilebert/temp.dart';
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

int countAll;
int countInWork;
int countComplete;
int countDeffered;
bool isOrdersEmpty;

class Orders {
  var _client = Clients();

  String id;
  String courierId;
  String clientId;
  String paymentMethod;
  List<Consist> consists;
  double orderCost;
  int delivered;
  int deliveryDelay;
  String dateStart;
  String dateFinish;
  String address;
  // String timestamp;

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
    this.address,
    // this.timestamp,
  });

  factory Orders.fromJson(Map<String, dynamic> json) => new Orders(
        id: json["id"],
        courierId: json["courier_id"],
        clientId: json["client_id"],
        paymentMethod: json["payment_method"],
        consists: new List<Consist>.from(json["consists"].map((x) => Consist.fromJson(x))),
        orderCost: json["order_cost"].toDouble(),
        delivered: json["delivered"],
        deliveryDelay: json["delivery_delay"],
        dateStart: json["date_start"],
        dateFinish: json["date_finish"],
        address: json["address"],
        // timestamp: json["timestamp"],
      );

  factory Orders.fromSQL(Map<String, dynamic> sqlOrders) {
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
      address: sqlOrders["address"],
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
        "address": address,
        // "timestamp": timestamp,
      };

  Map<String, dynamic> toSQL() => {
        "id": id,
        "courier_id": courierId,
        "client_id": clientId,
        "payment_method": paymentMethod,
        "order_cost": orderCost,
        "delivered": delivered,
        "delivery_delay": deliveryDelay,
        "date_start": dateStart,
        "date_finish": dateFinish,
        "address": address,
        // "timestamp": timestamp,
      };

  Widget ordersListWidget(Database db, int delivered) {
    if (isOrdersEmpty) {
      countAll = 0;
      countInWork = 0;
      countComplete = 0;
      countDeffered = 0;
      countTitle = 0;
      return Center(
        child: Text(
          'Список заказов пуст.',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.red,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      );
    }
    return FutureBuilder<List<Orders>>(
      builder: (context, ordersSnap) {
        if (ordersSnap.connectionState == ConnectionState.none || ordersSnap.connectionState == ConnectionState.waiting || ordersSnap.hasData == null) {
          return Center(child: CircularProgressIndicator());
        }
        return ListView.builder(
          // shrinkWrap: true,
          itemCount: ordersSnap.data.length,
          itemBuilder: (context, index) {
            return Card(
              child: ListTile(
                dense: true,
                // leading: Column(
                //   children: <Widget>[
                //     if (ordersSnap.data[index].delivered == -1)
                //       CircleAvatar(
                //         child: Text(ordersSnap.data[index].id.toString()),
                //         backgroundColor: Colors.red,
                //       ),
                //     if (ordersSnap.data[index].delivered == 1)
                //       CircleAvatar(
                //         child: Text(ordersSnap.data[index].id.toString()),
                //         backgroundColor: Colors.green,
                //       ),
                //     if (ordersSnap.data[index].delivered == 0)
                //       CircleAvatar(
                //         child: Text(ordersSnap.data[index].id.toString()),
                //         backgroundColor: Colors.blue,
                //       ),
                //   ],
                // ),
                isThreeLine: true,
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (ordersSnap.data[index].delivered == -1)
                      Text(
                        ordersSnap.data[index].id,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.red,
                        ),
                      ),
                    if (ordersSnap.data[index].delivered == 1)
                      Text(
                        ordersSnap.data[index].id,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.green,
                        ),
                      ),
                    if (ordersSnap.data[index].delivered == 0)
                      Text(
                        ordersSnap.data[index].id,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.blue,
                        ),
                      ),
                    _client.clientData(db, ordersSnap.data[index].clientId),
                    Text('Адрес'),
                    Text(
                      ordersSnap.data[index].address,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                subtitle: Row(
                  children: <Widget>[
                    Text(ordersSnap.data[index].paymentMethod),
                  ],
                ),
                // trailing: Column(
                //   crossAxisAlignment: CrossAxisAlignment.end,
                //   children: <Widget>[
                //     Text(ordersSnap.data[index].consists[0].product),
                //     Text(
                //         ordersSnap.data[index].consists[0].quantity.toString()),
                //     Text(ordersSnap.data[index].orderCost.toString() + ' Lei'),
                //   ],
                // ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => OrderDetail(order: ordersSnap.data[index]),
                    ),
                  );
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

  countAll = Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM orders'));
  countInWork = Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM orders WHERE delivered = 0'));
  countComplete = Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM orders WHERE delivered = 1'));
  countDeffered = Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM orders WHERE delivered = -1'));

  switch (delivered) {
    case -1:
    case 0:
    case 1:
      sqlDataOrders = await db.query('orders', where: 'delivered=?', whereArgs: [delivered]);
      break;
    default:
      sqlDataOrders = await db.query('orders');
  }
  List<Map<String, dynamic>> sqlDataConsists = await db.query('consists');
  var consists = List<Consist>.from(sqlDataConsists.map((x) => Consist.fromSQL(x)));
  var orders = List<Orders>.from(sqlDataOrders.map((x) {
    var result = Orders.fromSQL(x);
    consists.forEach((y) {
      if (y.ordersID == result.id) {
        result.consists.add(y);
      }
    });
    return result;
  }));
  return orders;
}

class Consist {
  int id;
  String ordersID;
  String product;
  double quantity;
  double price;
  String extInfo;
  int direction;

  Consist({
    this.id,
    this.ordersID,
    this.product,
    this.quantity,
    this.price,
    this.extInfo,
    this.direction,
  });

  factory Consist.fromJson(Map<String, dynamic> json) => new Consist(
        id: json["id"],
        ordersID: json["orders_id"],
        product: json["product"],
        quantity: json["quantity"].toDouble(),
        price: json["price"].toDouble(),
        extInfo: json["ext_info"],
        direction: json["direction"],
      );

  factory Consist.fromSQL(Map<String, dynamic> sql) {
    return new Consist(
      id: sql["id"],
      ordersID: sql["orders_id"],
      product: sql["product"],
      quantity: sql["quantity"],
      price: sql["price"],
      extInfo: sql["ext_info"],
      direction: sql["direction"],
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "orders_id": ordersID,
        "product": product,
        "quantity": quantity,
        "price": price,
        "ext_info": extInfo,
        "direction": direction,
      };

  Map<String, dynamic> toSQL() => {
        "id": id,
        "orders_id": ordersID,
        "product": product,
        "quantity": quantity,
        "price": price,
        "ext_info": extInfo,
        "direction": direction,
      };
}
