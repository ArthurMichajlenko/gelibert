import 'dart:convert';

List<Couriers> couriersFromJson(String str) {
  final jsonData = json.decode(str);
  return new List<Couriers>.from(jsonData.map((x) => Couriers.fromJson(x)));
}

String couriersToJson(List<Couriers> data) {
  final dyn = new List<dynamic>.from(data.map((x) => x.toJson()));
  return json.encode(dyn);
}

class Couriers {
  int id;
  int imei;
  String tel;
  String name;
  String carNumber;
  double latitude;
  double longitude;
  String address;

  Couriers({
    this.id,
    this.imei,
    this.tel,
    this.name,
    this.carNumber,
    this.latitude,
    this.longitude,
    this.address,
  });

  factory Couriers.fromJson(Map<String, dynamic> json) => new Couriers(
    id: json["id"],
    imei: json["imei"],
    tel: json["tel"],
    name: json["name"],
    carNumber: json["car_number"],
    latitude: json["latitude"].toDouble(),
    longitude: json["longitude"].toDouble(),
    address: json["address"],
  );

  factory Couriers.fromSQL(Map<String, dynamic> sql) => new Couriers(
    id: sql["id"],
    imei: sql["imei"],
    tel: sql["tel"],
    name: sql["name"],
    carNumber: sql["car_number"],
    latitude: sql["latitude"],
    longitude: sql["longitude"],
    address: sql["address"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "imei": imei,
    "tel": tel,
    "name": name,
    "car_number": carNumber,
    "latitude": latitude,
    "longitude": longitude,
    "address": address,
  };
}

