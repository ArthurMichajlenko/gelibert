import 'dart:convert';

List<GeneralData> generalDataFromJson(String str) {
  final jsonData = json.decode(str);
  return List<GeneralData>.from(jsonData.map((x) => GeneralData.fromJson(x)));
}

String generalDataToJson(List<GeneralData> data) {
  final dyn = List<dynamic>.from(data.map((x) => x.toJson()));
  return json.encode(dyn);
}

class GeneralData {
  String id;
  String orderRoutlist;
  String orderDate;
  String courierId;
  String clientId;
  String paymentMethod;
  List<Consist> consists;
  double orderCost;
  int delivered;
  int deliveryDelay;
  String dateStart;
  String dateFinish;
  String timestamp;
  String address;

  GeneralData({
    this.id,
    this.orderRoutlist,
    this.orderDate,
    this.courierId,
    this.clientId,
    this.paymentMethod,
    this.consists,
    this.orderCost,
    this.delivered,
    this.deliveryDelay,
    this.dateStart,
    this.dateFinish,
    this.timestamp,
    this.address,
  });

  factory GeneralData.fromJson(Map<String, dynamic> json) => GeneralData(
    id: json["id"],
    orderRoutlist: json["order_routlist"],
    orderDate: json["order_date"],
    courierId: json["courier_id"],
    clientId: json["client_id"],
    paymentMethod: json["payment_method"],
    consists: List<Consist>.from(json["consists"].map((x) => Consist.fromJson(x))),
    orderCost: json["order_cost"].toDouble(),
    delivered: json["delivered"],
    deliveryDelay: json["delivery_delay"],
    dateStart: json["date_start"],
    dateFinish: json["date_finish"],
    timestamp: json["timestamp"],
    address: json["address"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "order_routlist": orderRoutlist,
    "order_date": orderDate,
    "courier_id": courierId,
    "client_id": clientId,
    "payment_method": paymentMethod,
    "consists": List<dynamic>.from(consists.map((x) => x.toJson())),
    "order_cost": orderCost,
    "delivered": delivered,
    "delivery_delay": deliveryDelay,
    "date_start": dateStart,
    "date_finish": dateFinish,
    "timestamp": timestamp,
    "address": address,
  };
}

class Consist {
  int id;
  String product;
  int quantity;
  double price;
  String extInfo;
  int direction;
  String ordersId;

  Consist({
    this.id,
    this.product,
    this.quantity,
    this.price,
    this.extInfo,
    this.direction,
    this.ordersId,
  });

  factory Consist.fromJson(Map<String, dynamic> json) => Consist(
    id: json["id"],
    product: json["product"],
    quantity: json["quantity"],
    price: json["price"].toDouble(),
    extInfo: json["ext_info"],
    direction: json["direction"],
    ordersId: json["orders_id"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "product": product,
    "quantity": quantity,
    "price": price,
    "ext_info": extInfo,
    "direction": direction,
    "orders_id": ordersId,
  };
}
