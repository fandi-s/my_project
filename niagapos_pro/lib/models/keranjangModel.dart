// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);

import 'dart:convert';

List<KeranjangModel> keranjangModelFromJson(String str) => List<KeranjangModel>.from(json.decode(str).map((x) => KeranjangModel.fromJson(x)));

String keranjangModelToJson(List<KeranjangModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class KeranjangModel {
  KeranjangModel({
    this.id,
    this.kodePembeli,
    this.namaCustomer,
    this.kodeToko,
    this.kodeBarang,
    this.barcodeBarang,
    this.namaBarang,
    this.satuan,
    this.klpBarang,
    this.hargaJual,
    this.kodeSatuan,
    this.hargaTotal,
    this.statusBayar,
    this.createdAt,
    this.updatedAt,
  });

  String id;
  String kodePembeli;
  String namaCustomer;
  String kodeToko;
  String kodeBarang;
  String barcodeBarang;
  String namaBarang;
  String satuan;
  String klpBarang;
  String hargaJual;
  String kodeSatuan;
  String hargaTotal;
  String statusBayar;
  DateTime createdAt;
  DateTime updatedAt;

  factory KeranjangModel.fromJson(Map<String, dynamic> json) => KeranjangModel(
    id: json['id'],
    kodePembeli: json['kode_pembeli'],
    namaCustomer: json['nama_customer'],
    kodeToko: json['kode_toko'],
    kodeBarang: json['kode_barang'],
    barcodeBarang: json['barcode_barang'],
    namaBarang: json['nama_barang'],
    satuan: json['satuan'],
    klpBarang: json['klp_barang'],
    hargaJual: json['harga_jual'],
    kodeSatuan: json['kode_satuan'],
    hargaTotal: json['harga_total'],
    statusBayar: json['status_bayar'],
    createdAt: DateTime.parse(json['created_at']),
    updatedAt: DateTime.parse(json['updated_at']),
  );

  Map<String, dynamic> toJson() => {
    'id':id,
    'kode_pembeli':kodePembeli,
    'nama_customer':namaCustomer,
    'kode_toko':kodeToko,
    'kode_barang':kodeBarang,
    'barcode_barang': barcodeBarang,
    'nama_barang': namaBarang,
    'satuan': satuan,
    'klp_barang': klpBarang,
    'harga_jual': hargaJual,
    'kode_satuan': kodeSatuan,
    'harga_total': hargaTotal,
    'status_bayar': statusBayar,
    'created_at': createdAt.toIso8601String(),
    'updated_at': updatedAt.toIso8601String(),
  };
}
