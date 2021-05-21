import 'package:sqflite/sqflite.dart';

import 'package:gilebert/main.dart';
import 'package:gilebert/models/general.dart';

import 'models/clients.dart';
import 'models/couriers.dart';
import 'models/orders.dart';

Future<void> fetchDataToSQL(Database db, String json) async {
  List<Orders> orders = [];
  Couriers couriers = Couriers();
  List<Clients> clients = [];
  List<GeneralData> data = generalDataFromJson(json);
  //Fetch couriers
  couriers.id = data[0].courierId;
  couriers.macAddress = data[0].courierImei;
  couriers.name = data[0].courierName;
  couriers.tel = data[0].courierTel;
  couriers.carNumber = data[0].courierCarNumber;
  await db.insert('couriers', couriers.toSQL(), conflictAlgorithm: ConflictAlgorithm.replace);
  //Fetch clients
  data[0].clients.forEach((cl) {
    clients.add(Clients(id: cl.clientId, name: cl.clientName, tel: cl.clientName));
    orders.add(Orders(
      id: cl.orderId,
      courierId: data[0].courierId,
      clientId: cl.clientId,
      paymentMethod: cl.paymentMethod,
      orderCost: cl.orderCost,
      delivered: cl.delivered,
      deliveryDelay: cl.deliveryDelay,
      dateStart: cl.dateStart,
      dateFinish: cl.dateFinish,
      address: cl.address,
      orderRoutlist: cl.orderRoutlist,
      orderDate: cl.orderDate,
    ));
  });
  clients.forEach((x) async {
    await db.insert('clients', x.toSQL(), conflictAlgorithm: ConflictAlgorithm.replace);
    return;
  });
  // Fetch orders
  routLists.clear();
  connected = true;
  isOrdersEmpty = false;
  orders.forEach((x) async {
    routLists.add(x.orderRoutlist);
    await db.insert('orders', x.toSQL(), conflictAlgorithm: ConflictAlgorithm.replace);
    // x.consists.forEach((y) async {
    //   return await db.insert('consists', y.toSQL(), conflictAlgorithm: ConflictAlgorithm.replace);
    // });
    return;
  });
  data[0].consists.forEach((consist) async {
    await db.insert('consists', consist.toSQL(), conflictAlgorithm: ConflictAlgorithm.replace);
  });
}
