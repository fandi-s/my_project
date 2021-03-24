import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CheckSession extends StatefulWidget{
  @override
  CheckState createState() => CheckState();
}

class CheckState extends State<CheckSession> {

  void loadPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var status = prefs.getString('status');
    status == null
        ? Navigator.pushReplacementNamed(context, '/Login')
        : status == "2"
        ? Navigator.pushReplacementNamed(context, '/Beranda')
        : Navigator.pushReplacementNamed(context, '/Berandapmi');
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
    return Center(
      child: CircularProgressIndicator(),
    );
  }
}