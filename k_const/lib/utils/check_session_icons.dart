import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CheckSessionIcons extends StatefulWidget{
  @override
  CheckSessionIconsState createState() => CheckSessionIconsState();
}

class CheckSessionIconsState extends State<CheckSessionIcons> {

  void loadPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var status = prefs.getString('status_icons');
    if(status == null){
      Navigator.pushReplacementNamed(context, '/icons/LoginIcons');
    } else if (status == "1"){
      Navigator.pushReplacementNamed(context, '/icons/BerandaIconsAdmin');
    } else if (status == "3"){
      Navigator.pushReplacementNamed(context, '/icons/BerandaIcons');
    }
    // status == null
    //     ? Navigator.pushReplacementNamed(context, '/icons/LoginIcons')
    //     : status == "3"
    //     ? Navigator.pushReplacementNamed(context, '/icons/BerandaIconsAdmin')
    //     : Navigator.pushReplacementNamed(context, '/icons/BerandaIcons');
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadPrefs();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: Container(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }

}