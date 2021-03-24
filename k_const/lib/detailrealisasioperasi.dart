import 'package:flutter/material.dart';

class DetailRealisasiOperasiPage extends StatefulWidget{

  final String value;
  DetailRealisasiOperasiPage({Key key, @required this.value}) : super(key: key);

  @override
  DetailRealisasiOperasiState createState() => DetailRealisasiOperasiState();
}

class DetailRealisasiOperasiState extends State<DetailRealisasiOperasiPage> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: Container(
        child: Center(
          child: Text("${widget.value}"),
        ),
      ),
    );
  }
}