// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);

import 'dart:convert';

List<BadgeModel> badgeModelFromJson(String str) => List<BadgeModel>.from(json.decode(str).map((x) => BadgeModel.fromJson(x)));

String badgeModelToJson(List<BadgeModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class BadgeModel {
  BadgeModel({
    this.kodeToko,
    this.kodePembeli,
    this.totalQty
  });


  String kodeToko;
  String kodePembeli;
  int totalQty;

  factory BadgeModel.fromJson(Map<String, dynamic> json) => BadgeModel(
    kodeToko: json["kode_toko"],
    kodePembeli: json["kode_pembeli"],
    totalQty: json["total_qty"],
  );

  Map<String, dynamic> toJson() => {
    "kode_toko": kodeToko,
    "kode_pembeli": kodePembeli,
    "total_qty": totalQty,
  };
}
