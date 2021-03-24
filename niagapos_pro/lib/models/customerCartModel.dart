// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);

import 'dart:convert';

List<CustomerCartModel> customerCartModelFromJson(String str) => List<CustomerCartModel>.from(json.decode(str).map((x) => CustomerCartModel.fromJson(x)));

String customerCartModelToJson(List<CustomerCartModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CustomerCartModel {
  CustomerCartModel({
    this.id,
    this.kodePembeli,
    this.kodeToko,
    this.kodeBarang,
    this.barcodeBarang,
    this.namaBarang,
    this.satuan,
    this.klpBarang,
    this.hargaJual,
    this.kodeSatuan,
    this.qty,
    this.hargaTotal,
    this.createdAt,
    this.updatedAt,
  });

  int id;
  String kodePembeli;
  String kodeToko;
  String kodeBarang;
  String barcodeBarang;
  String namaBarang;
  String satuan;
  String klpBarang;
  int hargaJual;
  String kodeSatuan;
  int qty;
  int hargaTotal;
  DateTime createdAt;
  DateTime updatedAt;

  factory CustomerCartModel.fromJson(Map<String, dynamic> json) => CustomerCartModel(
    id: json["id"],
    kodePembeli: json["kode_pembeli"],
    kodeToko: json["kode_toko"],
    kodeBarang: json["kode_barang"],
    barcodeBarang: json["barcode_barang"],
    namaBarang: json["nama_barang"],
    satuan: json["satuan"],
    klpBarang: json["klp_barang"],
    hargaJual: json["harga_jual"],
    kodeSatuan: json["kode_satuan"],
    qty: json["qty"],
    hargaTotal: json["harga_total"],
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "kode_pembeli": kodePembeli,
    "kode_toko": kodeToko,
    "kode_barang": kodeBarang,
    "barcode_barang": barcodeBarang,
    "nama_barang": namaBarang,
    "satuan": satuan,
    "klp_barang": klpBarang,
    "harga_jual": hargaJual,
    "kode_satuan": kodeSatuan,
    "qty": qty,
    "harga_total": hargaTotal,
    "createdAt": createdAt.toIso8601String(),
    "updatedAt": updatedAt.toIso8601String(),
  };
}
