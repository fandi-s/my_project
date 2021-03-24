import 'dart:convert';

class LoginPenjualModel {
  final int status;
  final String msg;
  final List<Data> data;

  LoginPenjualModel({this.status, this.msg, this.data});

  factory LoginPenjualModel.fromJson(Map<String, dynamic> parsedJson){

    var list = parsedJson['data'] as List;
    print(list.runtimeType);
    List<Data> dataList = list.map((i) => Data.fromJson(i)).toList();

    return LoginPenjualModel(
        status: parsedJson['status'],
        msg: parsedJson['msg'],
        data: dataList
    );
  }

}


class Data {
  final int id;
  final String kodeToko;
  final String namaToko;
  final String noTelp;
  final DateTime createdAt;
  final DateTime updatedAt;

  Data({this.id, this.kodeToko, this.namaToko, this.noTelp, this.createdAt, this.updatedAt});

  factory Data.fromJson(Map<String, dynamic> parsedJson){

    return Data(
      id: parsedJson["id"],
      kodeToko: parsedJson["kode_toko"],
      namaToko: parsedJson["nama_toko"],
      noTelp: parsedJson["no_telp"],
      createdAt: DateTime.parse(parsedJson["createdAt"]),
      updatedAt: DateTime.parse(parsedJson["updatedAt"]),
    );
  }

}