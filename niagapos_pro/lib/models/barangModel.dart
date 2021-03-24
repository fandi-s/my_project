// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);

import 'dart:convert';

List<BarangModel> barangModelFromJson(String str) => List<BarangModel>.from(json.decode(str).map((x) => BarangModel.fromJson(x)));

String barangModelToJson(List<BarangModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class BarangModel {
  BarangModel({
    this.kode,
    this.namaBarang,
    this.unitSatuan,
    this.qty,
    this.harga,
    this.createdAt,
    this.updatedAt,
  });

  String kode;
  String namaBarang;
  String unitSatuan;
  String qty;
  String harga;
  String createdAt;
  DateTime updatedAt;

  factory BarangModel.fromJson(Map<String, dynamic> json) => BarangModel(
    kode: json["kode"],
    namaBarang: json["nama_barang"],
    unitSatuan: json["unit_satuan"],
    qty: json["qty"],
    harga: json["harga"],
    createdAt: json["created_at"],
    updatedAt: DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "kode": kode,
    "nama_barang": namaBarang,
    "unit_satuan": unitSatuan,
    "qty": qty,
    "harga": harga,
    "created_at": createdAt,
    "updated_at": updatedAt.toIso8601String(),
  };
}
