import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:lite_rolling_switch/lite_rolling_switch.dart';
import 'package:niagapos_pro/models/loginModel.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:niagapos_pro/services/loginService.dart';
import 'package:niagapos_pro/services/loginServicePenjual.dart';

class LoginView extends StatefulWidget{
  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {

  ProgressDialog pr;

  TextEditingController username = new TextEditingController();
  TextEditingController password = new TextEditingController();

  bool _showPassword = false;
  bool _statusToggle = false;

  void _toggleVisibility(){
    setState(() {
      _showPassword = !_showPassword;
    });
  }

  String status = "";

  List<LoginModel> dataLogin = new List();
  void getDataLogin(String username, String password, bool statusToggle) {
    if(username==""){
      setState(() {
        status = "Username can't be null";
      });
    }else if(password==""){
      setState(() {
        status = "Password can't be null";
      });
    }else{
      pr.show();
      if(statusToggle==true){
      //  UNTUK PENJUAL
        loadResponsePenjual(context, username, password, pr, statusToggle);
      }else{
      //  UNTUK PEMBELI
        loadResponse(context, username, password, pr, statusToggle);
      }
    }
  }

  @override
  Widget build(BuildContext context) {

    pr = ProgressDialog(
        context,
        type: ProgressDialogType.Download,
        isDismissible: true,
        customBody: LinearProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.greenAccent),
          backgroundColor: Colors.white,
        )
    );
    pr.style(
        message: 'Please wait...',
        borderRadius: 10.0,
        backgroundColor: Colors.white,
        elevation: 10.0,
        insetAnimCurve: Curves.easeInOut,
        progress: 0.0,
        progressWidgetAlignment: Alignment.center,
        maxProgress: 100.0,
        progressTextStyle: TextStyle(
            color: Colors.black45, fontSize: 10, fontWeight: FontWeight.bold
        ),
        messageTextStyle: TextStyle(
            color: Colors.black38, fontSize: 10, fontWeight: FontWeight.bold
        )
    );

    // TODO: implement build
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.8,
                padding: EdgeInsets.only(left: 40.0, right: 40.0, top: 40),
                child: Column(
                  children: [
                    Container(
                      alignment: Alignment.topRight,
                      child: Image.asset('assets/welcomeimage.png', height: 250,),
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      child: Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Text("Niagapos", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25, color: Colors.deepOrange),),
                          ),
                          // Container(
                          //   alignment: Alignment.centerLeft,
                          //   height: 35,
                          //   child: LiteRollingSwitch(
                          //     value: _statusToggle,
                          //     textOn: 'Penjual',
                          //     textOff: 'Pembeli',
                          //     colorOn: Colors.deepOrangeAccent,
                          //     colorOff: Colors.orangeAccent,
                          //     iconOn: Icons.arrow_right,
                          //     iconOff: Icons.arrow_left,
                          //     onChanged: (bool state){
                          //       _statusToggle = state;
                          //       print("ANJENG ${_statusToggle}");
                          //     },
                          //   ),
                          // )
                        ],
                      ),
                    ),
                    Padding(padding: EdgeInsets.only(top: 6)),
                    Container(
                      alignment: Alignment.centerLeft,
                      child: Text("Please sign in to continue"),
                    ),
                    Padding(padding: EdgeInsets.only(top: 32)),
                    TextFormField(
                      controller: username,
                      decoration: InputDecoration(
                          prefixIcon: Icon(Icons.account_circle, color: Colors.greenAccent,),
                          labelText: "Username",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30)
                          )
                      ),
                    ),
                    Padding(padding: EdgeInsets.only(top: 10)),
                    TextFormField(
                      controller: password,
                      obscureText: !_showPassword,
                      decoration: InputDecoration(
                          labelText: "Password",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30)
                          ),
                          prefixIcon: Icon(Icons.vpn_key, color: Colors.greenAccent,),
                          suffixIcon: GestureDetector(
                            onTap: (){
                              _toggleVisibility();
                            },
                            child: Icon(
                              _showPassword ? Icons.visibility : Icons.visibility_off,
                              color: Colors.deepOrangeAccent,
                            ),
                          )
                      ),
                    ),
                    Padding(padding: EdgeInsets.only(top: 15)),
                    status == "" ? Container() :
                    Container(
                      padding: EdgeInsets.only(right: 20, bottom: 15),
                      alignment: Alignment.centerRight,
                      child: Text(status, style: TextStyle(fontSize: 11, color: Colors.red),),
                    ),
                    Container(
                      padding: EdgeInsets.only(right: 20),
                      alignment: Alignment.centerRight,
                      child: Text("Forgot password", style: TextStyle(fontSize: 11, color: Colors.green[800]),),
                    ),
                    Padding(padding: EdgeInsets.only(top: 15)),
                    Row(
                      children: [
                        Expanded(
                            flex: 1,
                            child: Container()),
                        Expanded(
                            flex: 1,
                            child: Container(
                              height: 50,
                              child: RaisedButton(
                                onPressed: (){
                                  getDataLogin(username.text, password.text, _statusToggle);
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text("Login", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),),
                                    Padding(padding: EdgeInsets.only(right: 10)),
                                    Icon(Icons.arrow_forward, color: Colors.white,),
                                    Padding(padding: EdgeInsets.only(right: 20))
                                  ],
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  side: BorderSide(color: Colors.green[200]),
                                ),
                                color: Colors.greenAccent,
                              ),
                            ))
                      ],
                    )
                  ],
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.2,
                padding: EdgeInsets.only(bottom: 30),
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Don't have an account? "),
                    Text(" Sign up", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green),)
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}