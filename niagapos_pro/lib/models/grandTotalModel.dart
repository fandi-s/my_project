// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);

import 'dart:convert';

List<GrandTotalModel> grandTotalModelFromJson(String str) => List<GrandTotalModel>.from(json.decode(str).map((x) => GrandTotalModel.fromJson(x)));

String grandTotalModelToJson(List<GrandTotalModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class GrandTotalModel {
  GrandTotalModel({
    this.kodePembeli,
    this.kodeToko,
    this.hargaTotal,
  });

  String kodePembeli;
  String kodeToko;
  int hargaTotal;

  factory GrandTotalModel.fromJson(Map<String, dynamic> json) => GrandTotalModel(
    kodePembeli: json["kode_pembeli"],
    kodeToko: json["kode_toko"],
    hargaTotal: json["harga_total"],
  );

  Map<String, dynamic> toJson() => {
    "kode_pembeli": kodePembeli,
    "kode_toko": kodeToko,
    "harga_total": hargaTotal,
  };
}
