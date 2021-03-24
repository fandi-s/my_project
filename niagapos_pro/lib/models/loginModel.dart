
import 'dart:convert';

class LoginModel {
  final int status;
  final String msg;
  final List<Data> data;

  LoginModel({this.status, this.msg, this.data});

  factory LoginModel.fromJson(Map<String, dynamic> parsedJson){

    var list = parsedJson['data'] as List;
    print(list.runtimeType);
    List<Data> dataList = list.map((i) => Data.fromJson(i)).toList();

    return LoginModel(
        status: parsedJson['status'],
        msg: parsedJson['msg'],
        data: dataList
    );
  }
}


class Data {
  final int id;
  final String kodePelanggan;
  final String namaPelanggan;
  final String alamat;
  final String noTelp;
  final String status;
  final String kodeToko;
  final DateTime createdAt;
  final DateTime updatedAt;

  Data({this.id, this.kodePelanggan, this.namaPelanggan, this.alamat, this.noTelp, this.status, this.kodeToko, this.createdAt, this.updatedAt});

  factory Data.fromJson(Map<String, dynamic> parsedJson){

    return Data(
      id: parsedJson["id"],
      kodePelanggan: parsedJson["kode_pelanggan"],
      namaPelanggan: parsedJson["nama_pelanggan"],
      alamat: parsedJson["alamat"],
      noTelp: parsedJson["no_telp"],
      status: parsedJson["status"],
      kodeToko: parsedJson["kode_toko"],
      createdAt: DateTime.parse(parsedJson["createdAt"]),
      updatedAt: DateTime.parse(parsedJson["updatedAt"]),
    );
  }

}