import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Account extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text("Account Page"),
              Padding(padding: EdgeInsets.only(top: 20.0),),
              IconButton(
                icon: Image.asset("assets/images/exit.png"),
                onPressed: () async {
                  SharedPreferences prefs = await SharedPreferences.getInstance();
                  prefs.remove('status');
                  Navigator.pushReplacementNamed(context, '/Login');
                },
              )

            ],
          ),
        )
      ),
    );
  }

}