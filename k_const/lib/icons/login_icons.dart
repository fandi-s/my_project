import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LoginIcons extends StatefulWidget{
  @override
  LoginIconsState createState() => LoginIconsState();
}

class LoginIconsState extends State<LoginIcons> with SingleTickerProviderStateMixin {

  ProgressDialog pr;

  TextEditingController username = new TextEditingController();
  TextEditingController password = new TextEditingController();

  String msg = '';
  bool _showPassword = false;

  var f = new DateFormat('yyyy');
  var now = new DateTime.now();

  void _togglevisibility(){
    setState(() {
      _showPassword = !_showPassword;
    });
  }

  Future<List> login() async{
    var url = "http://i_cons.bpjt.pu.go.id/json/login";
    final response = await http.post(url, body: {
      "param":"login",
      "username":username.text,
      "password":password.text
    });

    var dataUser = json.decode(response.body);
    if(dataUser.length!=0){
      String status = dataUser['status'];
      if(status=='fail'){
        setState(() {
          msg = dataUser['error_msg'];
        });
      }else{
        if(dataUser['status_user']=='3'){
          setState(() async {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            prefs.setString('username_icons', dataUser['username']);
            prefs.setString('islogin_icons', 'yes');
            prefs.setString('status_icons', dataUser['status_user']);
            Navigator.pushReplacementNamed(context, '/icons/BerandaIcons');
          });
        }else if (dataUser['status_user']=='1'){
          setState(() async {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            prefs.setString('username_icons', dataUser['username']);
            prefs.setString('islogin_icons', 'yes');
            prefs.setString('status_icons', dataUser['status_user']);
            prefs.setString('id_ruas_icons', dataUser['id_ruas']);
            Navigator.pushReplacementNamed(context, '/icons/BerandaIconsAdmin');
          });
        }
      }

      print(msg);
    }
  }

  @override
  Widget build(BuildContext context) {

    pr = new ProgressDialog(context, showLogs: true);
    pr.style(message: 'Please wait...');

    // TODO: implement build
    return Scaffold(
      body: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.yellow[200],
                  Colors.white60,
                  Colors.white,
                ],
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
              )
          ),
          padding: EdgeInsets.only(left: 40.0, right: 40.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset('assets/images/logo_bpjt.png', scale: 3,),
                Padding(padding: EdgeInsets.only(bottom: 50.0),),
                Text("Login I-cons", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blueGrey),),
                Padding(padding: EdgeInsets.only(bottom: 30.0),),
                TextFormField(
                  controller: username,
                  decoration: InputDecoration(
                      prefixIcon: Icon(Icons.account_circle),
                      labelText: 'Username',
                      border: OutlineInputBorder()
                  ),
                ),
                Padding(padding: EdgeInsets.only(top: 5.0),),
                TextFormField(
                  controller: password,
                  obscureText: !_showPassword,
                  decoration: InputDecoration(
                      labelText: 'Password',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.vpn_key),
                      suffixIcon: GestureDetector(
                        onTap: (){
                          _togglevisibility();
                        },
                        child: Icon(
                          _showPassword ? Icons.visibility : Icons.visibility_off, color: Colors.blue,
                        ),
                      )
                  ),
                ),
                Padding(padding: EdgeInsets.only(top: 15.0),),
                Container(
                  alignment: Alignment.centerRight,
                  child: Text("Forgot Password?", style: TextStyle(color: Colors.blue, fontSize: 11.0),),
                ),
                Padding(padding: EdgeInsets.only(top: 22.0),),
                SizedBox(
                  width: double.infinity,
                  height: 50.0,
                  child: RaisedButton(
                    child: Text("Login", style: TextStyle(color: Colors.white),),
                    color: Color.fromRGBO(10, 102, 204, 100),
                    onPressed: (){
                      if(username.text == ""){
                        setState(() {
                          msg = "Username harus di isi.";
                        });
                      }else if(password.text == ""){
                        setState(() {
                          msg = "Password harus di isi.";
                        });
                      }else{
                        pr.show();
                        Future.delayed(Duration(seconds: 3)).then((value){
                          pr.hide().whenComplete((){
                            login();
                          });
                        });
                      }
                    },
                  ),
                ),
                Padding(padding: EdgeInsets.only(top: 10.0),),
                Text(msg, style: TextStyle(fontSize: 11.0, color: Colors.red),),
                Padding(padding: EdgeInsets.only(top: 20.0),),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text("Don't have account?", style: TextStyle(fontSize: 11),),
                    FlatButton(
                      onPressed: (){},
                      child: Text("contact admin to create account", style: TextStyle(color: Colors.blue, fontSize: 11),),
                    )
                  ],
                ),
                Padding(padding: EdgeInsets.only(top: 20),),
                Center(
                  child: Text("Copyright " + f.format(DateTime.now()) + " \u00a9 i_const - team teknik", style: TextStyle(fontSize: 11, color: Colors.blueGrey)),
                )
              ],
            ),
          )
      ),
    );
  }
}