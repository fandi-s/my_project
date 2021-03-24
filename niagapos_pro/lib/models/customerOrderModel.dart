// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);

import 'dart:convert';

List<CustomerOrderModel> customerOrderModelFromJson(String str) => List<CustomerOrderModel>.from(json.decode(str).map((x) => CustomerOrderModel.fromJson(x)));

String customerOrderModelToJson(List<CustomerOrderModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CustomerOrderModel {
  CustomerOrderModel({
    this.id,
    this.kodeToko,
    this.kodeBarang,
    this.barcodeBarang,
    this.namaBarang,
    this.satuan,
    this.klpBarang,
    this.hargaJual,
    this.kodeSatuan,
    this.createdAt,
    this.updatedAt,
  });

  int id;
  String kodeToko;
  String kodeBarang;
  String barcodeBarang;
  String namaBarang;
  String satuan;
  String klpBarang;
  String hargaJual;
  String kodeSatuan;
  DateTime createdAt;
  DateTime updatedAt;

  factory CustomerOrderModel.fromJson(Map<String, dynamic> json) => CustomerOrderModel(
    id: json["id"],
    kodeToko: json["kode_toko"],
    kodeBarang: json["kode_barang"],
    barcodeBarang: json["barcode_barang"],
    namaBarang: json["nama_barang"],
    satuan: json["satuan"],
    klpBarang: json["klp_barang"],
    hargaJual: json["harga_jual"],
    kodeSatuan: json["kode_satuan"],
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "kode_toko": kodeToko,
    "kode_barang": kodeBarang,
    "barcode_barang": barcodeBarang,
    "nama_barang": namaBarang,
    "satuan": satuan,
    "klp_barang": klpBarang,
    "harga_jual": hargaJual,
    "kode_satuan": kodeSatuan,
    "createdAt": createdAt.toIso8601String(),
    "updatedAt": updatedAt.toIso8601String(),
  };
}
