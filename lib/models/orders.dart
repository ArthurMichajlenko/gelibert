import 'dart:convert';

List<Orders> ordersFromJson(String str) {
  final jsonData = json.decode(str);
  return new List<Orders>.from(jsonData.map((x) => Orders.fromJson(x)));
}

String ordersToJson(List<Orders> data) {
  final dyn = new List<dynamic>.from(data.map((x) => x.toJson()));
  return json.encode(dyn);
}

class Orders {
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
    consists: new List<Consist>.from(json["consists"].map((x) => Consist.fromJson(x))),
    orderCost: json["order_cost"].toDouble(),
    delivered: json["delivered"],
    deliveryDelay: json["delivery_delay"],
    dateStart: json["date_start"],
    dateFinish: json["date_finish"],
  );

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
}

class Consist {
  String product;
  double quantity;
  bool delivery;

  Consist({
    this.product,
    this.quantity,
    this.delivery,
  });

  factory Consist.fromJson(Map<String, dynamic> json) => new Consist(
    product: json["product"],
    quantity: json["quantity"].toDouble(),
    delivery: json["delivery"],
  );

  Map<String, dynamic> toJson() => {
    "product": product,
    "quantity": quantity,
    "delivery": delivery,
  };
}
