// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);

// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);

import 'dart:convert';

List<TokoTransaksiModel> tokoTransaksiModelFromJson(String str) => List<TokoTransaksiModel>.from(json.decode(str).map((x) => TokoTransaksiModel.fromJson(x)));

String tokoTransaksiModelToJson(List<TokoTransaksiModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class TokoTransaksiModel {
  TokoTransaksiModel({
    this.id,
    this.idTransaksi,
    this.kodePembeli,
    this.kodeToko,
    this.qtyItem,
    this.grandTotal,
    this.pembayaran,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  int id;
  String idTransaksi;
  String kodePembeli;
  String kodeToko;
  int qtyItem;
  int grandTotal;
  String pembayaran;
  String status;
  DateTime createdAt;
  DateTime updatedAt;

  factory TokoTransaksiModel.fromJson(Map<String, dynamic> json) => TokoTransaksiModel(
    id: json["id"],
    idTransaksi: json["id_transaksi"],
    kodePembeli: json["kode_pembeli"],
    kodeToko: json["kode_toko"],
    qtyItem: json["qty_item"],
    grandTotal: json["grand_total"],
    pembayaran: json["pembayaran"],
    status: json["status"],
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "id_transaksi": kodeToko,
    "kode_pembeli": kodePembeli,
    "kode_toko": kodeToko,
    "qty_item": qtyItem,
    "grand_total": grandTotal,
    "pembayaran": pembayaran,
    "status": status,
    "createdAt": createdAt.toIso8601String(),
    "updatedAt": updatedAt.toIso8601String(),
  };
}

