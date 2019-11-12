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
  String productTo;
  String productFrom;
  String paymentMethod;
  double quantityTo;
  double quantityFrom;
  double orderCost;
  int orderStatus;
  int deliveryDelay;
  String dateStart;
  String dateFinish;

  Orders({
    this.id,
    this.courierId,
    this.clientId,
    this.productTo,
    this.productFrom,
    this.paymentMethod,
    this.quantityTo,
    this.quantityFrom,
    this.orderCost,
    this.orderStatus,
    this.deliveryDelay,
    this.dateStart,
    this.dateFinish,
  });

  factory Orders.fromJson(Map<String, dynamic> json) => new Orders(
        id: json["id"],
        courierId: json["courier_id"],
        clientId: json["client_id"],
        productTo: json["product_to"],
        productFrom: json["product_from"],
        paymentMethod: json["payment_method"],
        quantityTo: json["quantity_to"].toDouble(),
        quantityFrom: json["quantity_from"].toDouble(),
        orderCost: json["order_cost"].toDouble(),
        orderStatus: json["order_status"],
        deliveryDelay: json["delivery_delay"],
        dateStart: json["date_start"],
        dateFinish: json["date_finish"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "courier_id": courierId,
        "client_id": clientId,
        "product_to": productTo,
        "product_from": productFrom,
        "payment_method": paymentMethod,
        "quantity_to": quantityTo,
        "quantity_from": quantityFrom,
        "order_cost": orderCost,
        "order_status": orderStatus,
        "delivery_delay": deliveryDelay,
        "date_start": dateStart,
        "date_finish": dateFinish,
      };
}
