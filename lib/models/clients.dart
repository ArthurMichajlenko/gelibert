import 'dart:convert';

List<Clients> clientsFromJson(String str) {
  final jsonData = json.decode(str);
  return new List<Clients>.from(jsonData.map((x) => Clients.fromJson(x)));
}

String clientsToJson(List<Clients> data) {
  final dyn = new List<dynamic>.from(data.map((x) => x.toJson()));
  return json.encode(dyn);
}

class Clients {
  int id;
  String name;
  String tel;
  String address;

  Clients({
    this.id,
    this.name,
    this.tel,
    this.address,
  });

  factory Clients.fromJson(Map<String, dynamic> json) => new Clients(
    id: json["id"],
    name: json["name"],
    tel: json["tel"],
    address: json["address"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "tel": tel,
    "address": address,
  };
}

