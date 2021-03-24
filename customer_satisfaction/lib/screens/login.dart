import 'dart:convert';

import 'package:customer_satisfaction/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {

  SharedPreferences prefs;
  TextEditingController username = new TextEditingController();
  TextEditingController password = new TextEditingController();

  ProgressDialog pr;
  String msg = '';
  bool _showPassword = false;
  void _togglevisibility(){
    setState(() {
      _showPassword = !_showPassword;
    });
  }

  Future<List> login() async {

    var url = Constant.LOGIN;
    final response = await http.post(
      url,
      body: {
        "username":username.text,
        "password":password.text
      },
      headers: {"Accept": "application/json"}
    );

    var dataUser = json.decode(response.body);
    if(dataUser.length!=0){
      if(dataUser['status']=="fail"){
        setState(() {
          msg = "Username atau password salah";
        });
      }else{
        if(dataUser['id_kategori']=='4'){
          setState(() async {
            prefs = await SharedPreferences.getInstance();
            prefs.setString('id_user_tempat', dataUser['id_user_tempat']);
            prefs.setString('nama', dataUser['nama']);
            prefs.setString('lokasi', dataUser['lokasi']);
            prefs.setString('nama', dataUser['nama']);
            prefs.setString('id_kategori', dataUser['id_kategori']);
            prefs.setString('nama_kategori', dataUser['nama_kategori']);
            prefs.setString('islogin', 'yes');
            prefs.setString('admin', 'yes');
            Navigator.pushReplacementNamed(context, '/screens/admin/home_admin');
          });
        }else{
          setState(() async {
            prefs = await SharedPreferences.getInstance();
            prefs.setString('id_user_tempat', dataUser['id_user_tempat']);
            prefs.setString('nama', dataUser['nama']);
            prefs.setString('lokasi', dataUser['lokasi']);
            prefs.setString('nama', dataUser['nama']);
            prefs.setString('id_kategori', dataUser['id_kategori']);
            prefs.setString('nama_kategori', dataUser['nama_kategori']);
            prefs.setString('islogin', 'yes');
            prefs.setString('admin', 'no');
            Navigator.pushReplacementNamed(context, '/screens/choice_rate');
          });
        }
      }
    }else{
      setState(() {
        msg = "Ada Kesalahan Sistem.";
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPrefs();
  }

  @override
  Widget build(BuildContext context) {

    pr = new ProgressDialog(context, showLogs: true);
    pr.style(message: 'Please wait...');

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(left: 100, right: 100),
          child: Center(
            child: Column(
              children: [
                Container(
                  width: 400,
                  height: MediaQuery.of(context).size.height*0.8,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset('assets/logo_jmrb.png', width: 170,),
                      Padding(padding: EdgeInsets.only(top: 10)),
                      Text("Customer Satisfaction Login"),
                      Padding(padding: EdgeInsets.only(bottom: 30)),
                      TextFormField(
                        controller: username,
                        decoration: InputDecoration(
                            prefixIcon: Icon(Icons.account_circle),
                            labelText: 'Username',
                            border: OutlineInputBorder()
                        ),
                      ),
                      Padding(padding: EdgeInsets.only(top: 5)),
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
                        child: Text("Forgot Password?", style: TextStyle(color: Colors.deepOrange, fontSize: 11.0),),
                      ),
                      Padding(padding: EdgeInsets.only(top: 22.0),),
                      SizedBox(
                        width: double.infinity,
                        height: 40.0,
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
                              print("ANJINNNNNNNNNGGGG");
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
                    ],
                  ),
                ),
                Container(
                  height: MediaQuery.of(context).size.height*0.1,
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: EdgeInsets.only(bottom: 5, right: 10),
                          child: Text("Powered by", style: TextStyle(color: Colors.black54, fontSize: 10),),
                        ),
                        Image.asset('assets/logo_ngs.png', height: 20,)
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void getPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if(prefs.getString('islogin')=='yes'){
      if(prefs.getString('admin')=='yes'){
        Navigator.pushReplacementNamed(context, '/screens/admin/home_admin');
      }else{
        Navigator.pushReplacementNamed(context, '/screens/choice_rate');
      }
    }
  }
}
