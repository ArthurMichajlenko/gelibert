import 'dart:convert';

List<GeneralData> generalDataFromJson(String str) {
  final jsonData = json.decode(str);
  return List<GeneralData>.from(jsonData.map((x) => GeneralData.fromJson(x)));
}

String generaldataToJson(List<GeneralData> data) {
  final dyn = new List<dynamic>.from(data.map((x) => x.toJson()));
  return json.encode(dyn);
}

class GeneralData {
  String courierId;
  String courierImei;
  String courierTel;
  String courierName;
  String courierCarNumber;
  String courierTimestamp;
  List<Client> clients;
  List<GeneralConsist> consists;

  GeneralData({
    this.courierId,
    this.courierImei,
    this.courierTel,
    this.courierName,
    this.courierCarNumber,
    this.courierTimestamp,
    this.clients,
    this.consists,
  });

  factory GeneralData.fromJson(Map<String, dynamic> json) => GeneralData(
        courierId: json["courier_id"],
        courierImei: json["courier_imei"],
        courierTel: json["courier_tel"],
        courierName: json["courier_name"],
        courierCarNumber: json["courier_car_number"],
        courierTimestamp: json["courier_timestamp"],
        clients: List<Client>.from(json["Clients"].map((x) => Client.fromJson(x))),
        consists: List<GeneralConsist>.from(json["Consists"].map((x) => GeneralConsist.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "courier_id": courierId,
        "courier_imei": courierImei,
        "courier_tel": courierTel,
        "courier_name": courierName,
        "courier_car_number": courierCarNumber,
        "courier_timestamp": courierTimestamp,
        "Clients": List<dynamic>.from(clients.map((x) => x.toJson())),
        "Consists": List<dynamic>.from(consists.map((x) => x.toJson())),
      };
}

class Client {
  String orderRoutlist;
  String clientId;
  String clientName;
  String clientTel;
  String orderId;
  String orderDate;
  String paymentMethod;
  int orderCost;
  String delivered;
  String deliveryDelay;
  String dateStart;
  String dateFinish;
  String timeStamp;
  String address;

  Client({
    this.orderRoutlist,
    this.clientId,
    this.clientName,
    this.clientTel,
    this.orderId,
    this.orderDate,
    this.paymentMethod,
    this.orderCost,
    this.delivered,
    this.deliveryDelay,
    this.dateStart,
    this.dateFinish,
    this.timeStamp,
    this.address,
  });

  factory Client.fromJson(Map<String, dynamic> json) => Client(
        orderRoutlist: json["order_routlist"],
        clientId: json["client_id"],
        clientName: json["client_name"],
        clientTel: json["client_tel"],
        orderId: json["order_id"],
        orderDate: json["order_date"],
        paymentMethod: json["payment_method"],
        orderCost: json["order_cost"],
        delivered: json["delivered"],
        deliveryDelay: json["delivery_delay"],
        dateStart: json["date_start"],
        dateFinish: json["date_finish"],
        timeStamp: json["time_stamp"],
        address: json["address"],
      );

  Map<String, dynamic> toJson() => {
        "order_routlist": orderRoutlist,
        "client_id": clientId,
        "client_name": clientName,
        "client_tel": clientTel,
        "order_id": orderId,
        "order_date": orderDate,
        "payment_method": paymentMethod,
        "order_cost": orderCost,
        "delivered": delivered,
        "delivery_delay": deliveryDelay,
        "date_start": dateStart,
        "date_finish": dateFinish,
        "time_stamp": timeStamp,
        "address": address,
      };
}

class GeneralConsist {
  String id;
  String product;
  int quantity;
  int price;
  String extInfo;
  String direction;

  GeneralConsist({
    this.id,
    this.product,
    this.quantity,
    this.price,
    this.extInfo,
    this.direction,
  });

  factory GeneralConsist.fromJson(Map<String, dynamic> json) => GeneralConsist(
        id: json["id"],
        product: json["product"],
        quantity: json["quantity"],
        price: json["price"],
        extInfo: json["ext_info"],
        direction: json["direction"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "product": product,
        "quantity": quantity,
        "price": price,
        "ext_info": extInfo,
        "direction": direction,
      };
}
