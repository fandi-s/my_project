import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:kconst/login.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:shared_preferences/shared_preferences.dart';

class Dashboard extends StatefulWidget{
  @override
  DashboardState createState() => DashboardState();
}

class DashboardState extends State<Dashboard> with SingleTickerProviderStateMixin {

  String username;

  void initState(){
    super.initState();
    _loadPreferenches();
  }

  _loadPreferenches() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      username = prefs.getString('username');
    });
  }

  @override
  Widget build(BuildContext context) {

    var data=[
      Sales("2015", 50, Colors.lightBlue),
      Sales("2016", 70, Colors.lightBlue),
      Sales("2017", 100, Colors.lightBlue),
      Sales("2018", 50, Colors.lightBlue),
      Sales("2019", 150, Colors.lightBlue),
    ];

    var datapie=[
      Sales("Perencanaan", 2166, Colors.orange),
      Sales("Operasi", 1308, Colors.deepPurple),
      Sales("Menuju Laik Fungsi", 267, Colors.blueAccent),
      Sales("Konstruksi", 1132, Colors.greenAccent),
    ];

    var datasetuju=[
      Sales("Jan", 50, Colors.black54),
      Sales("Feb", 70, Colors.black54),
      Sales("Mar", 100, Colors.black54),
      Sales("Apr", 50, Colors.black54),
      Sales("Mei", 150, Colors.black54),
      Sales("Jun", 130, Colors.black54),
      Sales("Jul", 30, Colors.black54),
      Sales("Agu", 30, Colors.black54),
      Sales("Sep", 30, Colors.black54),
      Sales("Okt", 30, Colors.black54),
      Sales("Nov", 30, Colors.black54),
      Sales("Des", 30, Colors.black54),
    ];

    var datanonsetuju=[
      Sales("Jan", 60, Colors.lightBlue),
      Sales("Feb", 80, Colors.lightBlue),
      Sales("Mar", 140, Colors.lightBlue),
      Sales("Apr", 80, Colors.lightBlue),
      Sales("Mei", 190, Colors.lightBlue),
      Sales("Jun", 150, Colors.lightBlue),
      Sales("Jul", 70, Colors.lightBlue),
      Sales("Agu", 60, Colors.lightBlue),
      Sales("Sep", 80, Colors.lightBlue),
      Sales("Okt", 140, Colors.lightBlue),
      Sales("Nov", 80, Colors.lightBlue),
      Sales("Des", 190, Colors.lightBlue),
    ];

    var datalahan=[
      Sales("Kebutuhan Lahan", 66, Colors.lightBlueAccent),
      Sales("Lahan Bebas", 65, Colors.black54),
      Sales("Sisa Lahan", 11, Colors.greenAccent),
    ];

    var series =[
      charts.Series(
          domainFn: (Sales sales,_)=>sales.day,
          measureFn: (Sales sales,_)=>sales.sold,
          colorFn: (Sales sales,_)=>sales.color,
          id: 'Sales',
          data: data,
          labelAccessorFn: (Sales sales,_)=>'${sales.sold.toString()}'
      )
    ];

    var seriespie =[
      charts.Series(
          domainFn: (Sales sales,_)=>sales.day,
          measureFn: (Sales sales,_)=>sales.sold,
          colorFn: (Sales sales,_)=>sales.color,
          id: 'Sales',
          data: datapie,
          labelAccessorFn: (Sales sales,_)=>'${sales.day} : ${sales.sold.toString()} Km'
      )
    ];

    var seriesdesain =[
      charts.Series(
          domainFn: (Sales sales,_)=>sales.day,
          measureFn: (Sales sales,_)=>sales.sold,
          colorFn: (Sales sales,_)=>sales.color,
          id: 'Sales',
          data: datanonsetuju,
          labelAccessorFn: (Sales sales,_)=>'${sales.sold.toString()}'
      ),
      charts.Series(
          domainFn: (Sales sales,_)=>sales.day,
          measureFn: (Sales sales,_)=>sales.sold,
          colorFn: (Sales sales,_)=>sales.color,
          id: 'Sales',
          data: datasetuju,
          labelAccessorFn: (Sales sales,_)=>'${sales.sold.toString()}'
      ),
    ];

    var serieslahan =[
      charts.Series(
          domainFn: (Sales sales,_)=>sales.day,
          measureFn: (Sales sales,_)=>sales.sold,
          colorFn: (Sales sales,_)=>sales.color,
          id: 'Sales',
          data: datalahan,
          labelAccessorFn: (Sales sales,_)=>'${sales.sold.toString()} Km'
      )
    ];

    var chart = charts.BarChart(
      series,
      barRendererDecorator: charts.BarLabelDecorator<String>(),
      animate: true,
    );

    var pieChart = charts.PieChart(
      seriespie,
      defaultRenderer: charts.ArcRendererConfig(
          arcRendererDecorators: [charts.ArcLabelDecorator()],
          arcWidth: 50
      ),
      animate: true,
    );

    var chartDesain = charts.BarChart(
      seriesdesain,
      barGroupingType: charts.BarGroupingType.stacked,
      barRendererDecorator: charts.BarLabelDecorator<String>(),
    );

    var chartlahan = charts.BarChart(
      serieslahan,
      barRendererDecorator: charts.BarLabelDecorator<String>(),
      animate: true,
      vertical: false,
    );


    // TODO: implement build
    return Scaffold(
        body: SingleChildScrollView(
          child: Container(
              padding: EdgeInsets.only(left: 20.0, right: 20.0),
              child: Column(
                children: <Widget>[
                  Padding(padding: EdgeInsets.only(top: 20.0),),
                  Text("Welcome!", style: TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.bold),),
                  Padding(padding: EdgeInsets.only(top: 10.0),),
                  Image.asset("assets/iconk3/ic_profile.png", width: 60.0,),
                  Padding(padding: EdgeInsets.only(top: 10.0),),
                  Text(username.toString(), style: TextStyle(color: Colors.blueAccent),),
                  Padding(padding: EdgeInsets.only(top: 20.0),),
                  Container(
                    padding: EdgeInsets.all(10.0),
                    color: Colors.blueAccent,
                    alignment: Alignment.centerLeft,
                    child: Text("Nasional", style: TextStyle(color: Colors.white),),
                  ),
                  Padding(padding: EdgeInsets.only(top: 10.0),),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          color: Colors.red,
                          padding: EdgeInsets.all(10.0),
                          child: Column(
                            children: <Widget>[
                              Text("Perencanaan", style: TextStyle(color: Colors.white),),
                              Text("21", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 25.0),),
                              Text("Tot. Panjang : 2166.19 km", style: TextStyle(color: Colors.white, fontSize: 10),),
                            ],
                          ),
                        ),
                      ),
                      Padding(padding: EdgeInsets.only(left: 2, right: 2),),
                      Expanded(
                          child: Container(
                            color: Colors.lightBlueAccent,
                            padding: EdgeInsets.all(10.0),
                            child: Column(
                              children: <Widget>[
                                Text("Konstruksi", style: TextStyle(color: Colors.white),),
                                Text("25", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 25.0),),
                                Text("Tot. Panjang : 1132.063 km", style: TextStyle(color: Colors.white, fontSize: 10),),
                              ],
                            ),
                          )
                      ),
                    ],
                  ),

                  Padding(padding: EdgeInsets.only(top: 4.0),),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          color: Colors.blue,
                          padding: EdgeInsets.all(10.0),
                          child: Column(
                            children: <Widget>[
                              Text("Menuju Laik Fungsi", style: TextStyle(color: Colors.white),),
                              Text("4", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 25.0),),
                              Text("Tot. Panjang : 267.98 km", style: TextStyle(color: Colors.white, fontSize: 10),),
                            ],
                          ),
                        ),
                      ),
                      Padding(padding: EdgeInsets.only(left: 2, right: 2),),
                      Expanded(
                          child: Container(
                            color: Colors.deepPurpleAccent,
                            padding: EdgeInsets.all(10.0),
                            child: Column(
                              children: <Widget>[
                                Text("Operasi", style: TextStyle(color: Colors.white),),
                                Text("25", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 25.0),),
                                Text("Tot. Panjang : 1308.6145 km", style: TextStyle(color: Colors.white, fontSize: 10),),
                              ],
                            ),
                          )
                      ),
                    ],
                  ),

                  Padding(padding: EdgeInsets.only(top: 10.0),),
                  Container(
                    padding: EdgeInsets.all(10.0),
                    color: Colors.blueAccent,
                    alignment: Alignment.centerLeft,
                    child: Text("Realisasi Pengoperasian Jalan Tol", style: TextStyle(color: Colors.white),),
                  ),
                  Card(
                    child: Container(
                      padding: EdgeInsets.all(10.0),
                      child: Column(
                        children: <Widget>[
                          Text("Realisasi Pengoperasian Jalan Tol 2015-2019", style: TextStyle(),),
                          SizedBox(
                            height: 200.0,
                            child: chart,
                          )
                        ],
                      ),
                    ),
                  ),


                  Padding(padding: EdgeInsets.only(top: 10.0),),
                  Container(
                    padding: EdgeInsets.all(10.0),
                    color: Colors.blueAccent,
                    alignment: Alignment.centerLeft,
                    child: Text("Jalan Tol Indonesia Dalam Angka", style: TextStyle(color: Colors.white),),
                  ),
                  Card(
                    child: Container(
                      padding: EdgeInsets.all(10.0),
                      child: Column(
                        children: <Widget>[
                          Text("Progress Pelaksanaan", style: TextStyle(),),
                          SizedBox(
                            height: 200.0,
                            child: pieChart,
                          )
                        ],
                      ),
                    ),
                  ),



                  Padding(padding: EdgeInsets.only(top: 10.0),),
                  Container(
                    padding: EdgeInsets.all(10.0),
                    alignment: Alignment.centerLeft,
                    color: Colors.blueAccent,
                    child: Text("Progres Desain", style: TextStyle(color: Colors.white),),
                  ),
                  Card(
                    child: Container(
                      padding: EdgeInsets.all(10.0),
                      child: Column(
                        children: <Widget>[
                          Text("Progress Pelaksanaan", style: TextStyle(),),
                          SizedBox(
                            height: 200.0,
                            child: chartDesain,
                          )
                        ],
                      ),
                    ),
                  ),



                  Padding(padding: EdgeInsets.only(top: 10.0),),
                  Container(
                    padding: EdgeInsets.all(10.0),
                    alignment: Alignment.centerLeft,
                    color: Colors.blueAccent,
                    child: Text("Progres Lahan (bidang)", style: TextStyle(color: Colors.white),),
                  ),
                  Card(
                    child: Container(
                      padding: EdgeInsets.all(10.0),
                      child: Column(
                        children: <Widget>[
                          Text("Progress Lahan", style: TextStyle(),),
                          SizedBox(
                            height: 200.0,
                            child: chartlahan,
                          )
                        ],
                      ),
                    ),
                  ),


                  Padding(padding: EdgeInsets.only(top: 10.0),),
                  Container(
                    padding: EdgeInsets.all(10.0),
                    color: Colors.blueAccent,
                    alignment: Alignment.centerLeft,
                    child: Text("Progress Konstruksi", style: TextStyle(color: Colors.white),),
                  ),
                  Card(
                    child: Container(
                        padding: EdgeInsets.all(10.0),
                        child: Column(
                          children: <Widget>[
                            Text("Progress Fisik", style: TextStyle(fontWeight: FontWeight.bold),),
                            Row(
                              children: <Widget>[
                                Expanded(
                                    child: Container(
                                      padding: EdgeInsets.all(10.0),
                                      child: Column(
                                        children: <Widget>[
                                          Text("82,36 %", style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 20.0),),
                                          Padding(padding: EdgeInsets.only(top: 10.0),),
                                          Text("Realisasi", style: TextStyle(color: Colors.black87),),
                                        ],
                                      ),
                                    )
                                ),
                                Padding(padding: EdgeInsets.only(left: 2, right: 2),),
                                Expanded(
                                    child: Container(
                                      padding: EdgeInsets.all(10.0),
                                      child: Column(
                                        children: <Widget>[
                                          Text("89,65 %", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 20.0),),
                                          Padding(padding: EdgeInsets.only(top: 10.0),),
                                          Text("Rencana", style: TextStyle(color: Colors.black87),),
                                        ],
                                      ),
                                    )
                                ),
                                Padding(padding: EdgeInsets.only(left: 2, right: 2),),
                                Expanded(
                                    child: Container(
                                      padding: EdgeInsets.all(10.0),
                                      child: Column(
                                        children: <Widget>[
                                          Text("7,29 %", style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 20.0),),
                                          Padding(padding: EdgeInsets.only(top: 10.0),),
                                          Text("Deviasi", style: TextStyle(color: Colors.black87),),
                                        ],
                                      ),
                                    )
                                ),
                              ],
                            ),
                          ],
                        )
                    ),
                  ),

                  Card(
                    child: Container(
                        padding: EdgeInsets.all(10.0),
                        child: Column(
                          children: <Widget>[
                            Text("Progress Waktu", style: TextStyle(fontWeight: FontWeight.bold),),
                            Row(
                              children: <Widget>[
                                Expanded(
                                    child: Container(
                                      padding: EdgeInsets.all(10.0),
                                      child: Column(
                                        children: <Widget>[
                                          Text("939", style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 20.0),),
                                          Padding(padding: EdgeInsets.only(top: 10.0),),
                                          Text("hari Terpakai", style: TextStyle(color: Colors.black87),),
                                        ],
                                      ),
                                    )
                                ),
                                Padding(padding: EdgeInsets.only(left: 2, right: 2),),
                                Expanded(
                                    child: Container(
                                      padding: EdgeInsets.all(10.0),
                                      child: Column(
                                        children: <Widget>[
                                          Text("1008", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 20.0),),
                                          Padding(padding: EdgeInsets.only(top: 10.0),),
                                          Text("Total Hari", style: TextStyle(color: Colors.black87),),
                                        ],
                                      ),
                                    )
                                ),
                                Padding(padding: EdgeInsets.only(left: 2, right: 2),),
                                Expanded(
                                    child: Container(
                                      padding: EdgeInsets.all(10.0),
                                      child: Column(
                                        children: <Widget>[
                                          Text("69", style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 20.0),),
                                          Padding(padding: EdgeInsets.only(top: 10.0),),
                                          Text("Sisa", style: TextStyle(color: Colors.black87),),
                                        ],
                                      ),
                                    )
                                ),
                              ],
                            ),
                          ],
                        )
                    ),
                  ),

                  Padding(padding: EdgeInsets.only(top: 10.0),),
                  Container(
                    padding: EdgeInsets.all(10.0),
                    alignment: Alignment.centerLeft,
                    color: Colors.blueAccent,
                    child: Text("Progress K3", style: TextStyle(color: Colors.white),),
                  ),
                  Card(
                      child: Column(
                        children: <Widget>[
                          Container(
                              padding: EdgeInsets.all(10.0),
                              child: Column(
                                children: <Widget>[
                                  Row(
                                    children: <Widget>[
                                      Expanded(
                                          child: Container(
                                            padding: EdgeInsets.all(10.0),
                                            child: Column(
                                              children: <Widget>[
                                                Text("Pekerja", style: TextStyle(color: Colors.black87),),
                                                Container(
                                                  padding: EdgeInsets.all(10.0),
                                                  child: Image.asset("assets/iconk3/ic_pekerja.png"),
                                                ),
                                                Text("Total : 0", style: TextStyle(color: Colors.black87, fontSize: 10),),
                                                Text("Bln ini : 0", style: TextStyle(color: Colors.black87, fontSize: 10),),
                                                Text("Bln Lalu : 0", style: TextStyle(color: Colors.black87, fontSize: 10),),
                                              ],
                                            ),
                                          )
                                      ),
                                      Padding(padding: EdgeInsets.only(left: 2, right: 2),),
                                      Expanded(
                                          child: Container(
                                            padding: EdgeInsets.all(10.0),
                                            child: Column(
                                              children: <Widget>[
                                                Text("Jam Kerja", style: TextStyle(color: Colors.black87),),
                                                Container(
                                                  padding: EdgeInsets.all(10.0),
                                                  child: Image.asset("assets/iconk3/ic_jamkerja.png"),
                                                ),
                                                Text("Total : 0", style: TextStyle(color: Colors.black87, fontSize: 10),),
                                                Text("Bln ini : 0", style: TextStyle(color: Colors.black87, fontSize: 10),),
                                                Text("Bln Lalu : 0", style: TextStyle(color: Colors.black87, fontSize: 10),),
                                              ],
                                            ),
                                          )
                                      ),
                                      Padding(padding: EdgeInsets.only(left: 2, right: 2),),
                                      Expanded(
                                          child: Container(
                                            padding: EdgeInsets.all(10.0),
                                            child: Column(
                                              children: <Widget>[
                                                Text("Insiden", style: TextStyle(color: Colors.black87),),
                                                Container(
                                                  padding: EdgeInsets.all(10.0),
                                                  child: Image.asset("assets/iconk3/ic_insiden.png"),
                                                ),
                                                Text("Total : 0", style: TextStyle(color: Colors.black87, fontSize: 10),),
                                                Text("Bln ini : 0", style: TextStyle(color: Colors.black87, fontSize: 10),),
                                                Text("Bln Lalu : 0", style: TextStyle(color: Colors.black87, fontSize: 10),),
                                              ],
                                            ),
                                          )
                                      ),
                                      Padding(padding: EdgeInsets.only(left: 2, right: 2),),
                                      Expanded(
                                          child: Container(
                                            padding: EdgeInsets.all(10.0),
                                            child: Column(
                                              children: <Widget>[
                                                Text("Fatalitas", style: TextStyle(color: Colors.black87),),
                                                Container(
                                                  padding: EdgeInsets.all(10.0),
                                                  child: Image.asset("assets/iconk3/ic_fatalitas.png"),
                                                ),
                                                Text("Total : 0", style: TextStyle(color: Colors.black87, fontSize: 10),),
                                                Text("Bln ini : 0", style: TextStyle(color: Colors.black87, fontSize: 10),),
                                                Text("Bln Lalu : 0", style: TextStyle(color: Colors.black87, fontSize: 10),),
                                              ],
                                            ),
                                          )
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: <Widget>[
                                      Expanded(
                                          child: Container(
                                            padding: EdgeInsets.all(10.0),
                                            child: Column(
                                              children: <Widget>[
                                                Text("Nearmis", style: TextStyle(color: Colors.black87),),
                                                Container(
                                                  padding: EdgeInsets.all(10.0),
                                                  child: Image.asset("assets/iconk3/ic_nearmis.png"),
                                                ),
                                                Text("Total : 0", style: TextStyle(color: Colors.black87, fontSize: 10),),
                                                Text("Bln ini : 0", style: TextStyle(color: Colors.black87, fontSize: 10),),
                                                Text("Bln Lalu : 0", style: TextStyle(color: Colors.black87, fontSize: 10),),
                                              ],
                                            ),
                                          )
                                      ),
                                      Padding(padding: EdgeInsets.only(left: 2, right: 2),),
                                      Expanded(
                                          child: Container(
                                            padding: EdgeInsets.all(10.0),
                                            child: Column(
                                              children: <Widget>[
                                                Text("Pelatihan K3", style: TextStyle(color: Colors.black87),),
                                                Container(
                                                  padding: EdgeInsets.all(10.0),
                                                  child: Image.asset("assets/iconk3/ic_pelatihan.png"),
                                                ),
                                                Text("Total : 0", style: TextStyle(color: Colors.black87, fontSize: 10),),
                                                Text("Bln ini : 0", style: TextStyle(color: Colors.black87, fontSize: 10),),
                                                Text("Bln Lalu : 0", style: TextStyle(color: Colors.black87, fontSize: 10),),
                                              ],
                                            ),
                                          )
                                      ),
                                      Padding(padding: EdgeInsets.only(left: 2, right: 2),),
                                      Expanded(
                                          child: Container(
                                            padding: EdgeInsets.all(10.0),
                                            child: Column(
                                              children: <Widget>[
                                                Text("Kasus Covid-19", style: TextStyle(color: Colors.black87),),
                                                Container(
                                                  padding: EdgeInsets.all(10.0),
                                                  child: Image.asset("assets/iconk3/ic_covid.png"),
                                                ),
                                                Text("Total : 0", style: TextStyle(color: Colors.black87, fontSize: 10),),
                                                Text("Bln ini : 0", style: TextStyle(color: Colors.black87, fontSize: 10),),
                                                Text("Bln Lalu : 0", style: TextStyle(color: Colors.black87, fontSize: 10),),
                                              ],
                                            ),
                                          )
                                      ),

                                    ],
                                  ),
                                ],
                              )
                          ),
                        ],
                      )
                  ),

                  Padding(padding: EdgeInsets.only(top: 30.0),),



                ],
              )
          ),
        )

    );
  }
}

class Sales {
  final String day;
  final int sold;
  final charts.Color color;

  Sales(this.day, this.sold, Color color)
      : this.color=charts.Color(r: color.red,g: color.green,b: color.blue,a: color.alpha);

}