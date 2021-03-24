import 'dart:async' show Future;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:niagapos_pro/models/loginModel.dart';
import 'package:niagapos_pro/models/loginPenjualModel.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<String> _loadLoginDataPenjual(BuildContext context, String username, String password, ProgressDialog pr, bool statusToggle) async {
  var url = "http://restapi.niagapospro.com/penjual/login";
  final response = await http.post(url, body: {
    "username":username,
    "password":password
  });
  var jsonResponse = json.decode(response.body);
  if(jsonResponse['status']==404){
    //CEK APAKAH DATANYA KOSONG
    print("ANJENG gagal ${jsonResponse['status']}");
    pr.hide();
    _showMyDialog(context);
  }else{
    LoginPenjualModel loginPenjualModel = LoginPenjualModel.fromJson(jsonResponse);
    //CEK APAKAH DATANYA MASUK
    print("ANJENG -- : ${loginPenjualModel.data[0].namaToko}");

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('username', loginPenjualModel.data[0].namaToko);
    prefs.setString('isLogin', 'yes');
    prefs.setString('password', loginPenjualModel.data[0].kodeToko);
    prefs.setString('user', statusToggle.toString());

    pr.hide();
    Navigator.pushReplacementNamed(context, '/halaman/HomePenjualView');
  }
}

Future<void> _showMyDialog(BuildContext context) async {
  return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context){
        return AlertDialog(
          title: Text("Login failed!"),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                Text('Please try again...'),
                Text('Or contact your customer service'),
              ],
            ),
          ),
          actions: [
            TextButton(
                onPressed: (){
                  Navigator.of(context).pop();
                },
                child: Text('Ok')
            )
          ],
        );
      }
  );
}

Future loadResponsePenjual(BuildContext context, String username, String password, ProgressDialog pr, bool statusToggle) async {
  await _loadLoginDataPenjual(context, username, password, pr, statusToggle);
}