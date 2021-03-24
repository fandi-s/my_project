import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

String username;
String id_ruas;

class BerandaIconsAdmin extends StatefulWidget{
  @override
  BerandaIconsAdminState createState() => BerandaIconsAdminState();
}

class BerandaIconsAdminState extends State<BerandaIconsAdmin> {

  void loadAkun() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      username = prefs.getString('status_icons');
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadAkun();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: Container(
        color: Colors.blue,
        child: Center(
          child: Text("Beranda Icons Admin ${username}"),
        ),
      ),
    );
  }
}