import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'package:syncfusion_flutter_charts/charts.dart';

String username;
String id_ruas;

class Dashboardpmi extends StatefulWidget{
  @override
  DashboardpmiState createState() => DashboardpmiState();
}

class DashboardpmiState extends State<Dashboardpmi> with SingleTickerProviderStateMixin {

//  TO CHART DATA

  List data;
  Timer timer;

  void makeRequest() async {
    String url = 'http://fds-management.com/barchart.json';
    var response = await http.get(url, headers: {'Accept':'aplication/json'});

    setState(() {
      data = json.decode(response.body);
    });
  }

  void initState(){
    super.initState();
    _loadPreferenches();
    loadSalesData();
    timer=new Timer.periodic(Duration(seconds: 10), (t) => makeRequest());
  }

  @override
  void dispose(){
    timer.cancel();
    super.dispose();
  }

//  END DATA CHART

//  CHART TIPE 2

  List<SalesData> chartData = [];
  Future<String> _loadSalesDataAsset() async {
    String url = 'http://fds-management.com/barchart2.json';
    var response = await http.get(url, headers: {'Accept':'aplication/json'});
    return response.body.toString();
//    return await rootBundle.loadString('assets/data.json');
  }

  Future loadSalesData() async {
    String jsonString = await _loadSalesDataAsset();
    final jsonResponse = json.decode(jsonString);
    setState(() {
      for(Map i in jsonResponse){
        chartData.add(SalesData.fromJson(i));
      }
    });
  }

//  END OF CHART TIPE 2

  _loadPreferenches() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      username = prefs.getString('username');
      id_ruas = prefs.getString('id_ruas');
    });
  }

  @override
  Widget build(BuildContext context) {

    var datalahan=[
      Konstruksi("Sisa Lahan", 50, Colors.yellow),
      Konstruksi("Lahan Bebas", 70, Colors.lightBlueAccent),
      Konstruksi("Kebutuhan Lahan", 100, Colors.pinkAccent),
    ];

    var datasetuju=[
      Konstruksi("Jan", 50, Colors.lightBlueAccent),
      Konstruksi("Feb", 70, Colors.lightBlueAccent),
      Konstruksi("Mar", 100, Colors.lightBlueAccent),
      Konstruksi("Apr", 50, Colors.lightBlueAccent),
      Konstruksi("Mei", 150, Colors.lightBlueAccent),
      Konstruksi("Jun", 130, Colors.lightBlueAccent),
      Konstruksi("Jul", 30, Colors.lightBlueAccent),
      Konstruksi("Agu", 30, Colors.lightBlueAccent),
      Konstruksi("Sep", 30, Colors.lightBlueAccent),
      Konstruksi("Okt", 30, Colors.lightBlueAccent),
      Konstruksi("Nov", 30, Colors.lightBlueAccent),
      Konstruksi("Des", 30, Colors.lightBlueAccent),
    ];

    var datanonsetuju=[
      Konstruksi("Jan", 60, Colors.pinkAccent),
      Konstruksi("Feb", 80, Colors.pinkAccent),
      Konstruksi("Mar", 140, Colors.pinkAccent),
      Konstruksi("Apr", 80, Colors.pinkAccent),
      Konstruksi("Mei", 190, Colors.pinkAccent),
      Konstruksi("Jun", 150, Colors.pinkAccent),
      Konstruksi("Jul", 70, Colors.pinkAccent),
      Konstruksi("Agu", 60, Colors.pinkAccent),
      Konstruksi("Sep", 80, Colors.pinkAccent),
      Konstruksi("Okt", 140, Colors.pinkAccent),
      Konstruksi("Nov", 80, Colors.pinkAccent),
      Konstruksi("Des", 190, Colors.pinkAccent),
    ];

//    SERIES

    var serieslahan =[
      charts.Series(
          domainFn: (Konstruksi konst,_)=>konst.xaxis,
          measureFn: (Konstruksi konst,_)=>konst.yaxis,
          colorFn: (Konstruksi konst,_)=>konst.color,
          id: 'Lahan',
          data: datalahan,
          labelAccessorFn: (Konstruksi konst,_)=>'${konst.yaxis.toString()}'
      )
    ];

    var seriesdesain =[
      charts.Series(
          domainFn: (Konstruksi konst,_)=>konst.xaxis,
          measureFn: (Konstruksi konst,_)=>konst.yaxis,
          colorFn: (Konstruksi konst,_)=>konst.color,
          id: 'Sales',
          data: datanonsetuju,
          labelAccessorFn: (Konstruksi konst,_)=>'${konst.yaxis.toString()}'
      ),
      charts.Series(
          domainFn: (Konstruksi konst,_)=>konst.xaxis,
          measureFn: (Konstruksi konst,_)=>konst.yaxis,
          colorFn: (Konstruksi konst,_)=>konst.color,
          id: 'Sales',
          data: datasetuju,
          labelAccessorFn: (Konstruksi konst,_)=>'${konst.yaxis.toString()}'
      ),
    ];


//    CHART

    var chartlahan = charts.BarChart(
      serieslahan,
      barRendererDecorator: charts.BarLabelDecorator<String>(),
      animate: true,
    );

    var chartDesain = charts.BarChart(
      seriesdesain,
      barGroupingType: charts.BarGroupingType.stacked,
      barRendererDecorator: charts.BarLabelDecorator<String>(),
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
              Text(username, style: TextStyle(color: Colors.blueAccent),),
              Padding(padding: EdgeInsets.only(top: 20.0),),

              Padding(padding: EdgeInsets.only(top: 20.0),),
              Container(
                padding: EdgeInsets.all(10.0),
                color: Colors.blueAccent,
                alignment: Alignment.centerLeft,
                child: Text("Laporan PMI 2020 - "+username+" - "+id_ruas, style: TextStyle(color: Colors.white),),
              ),
              Padding(padding: EdgeInsets.only(top: 5.0),),
              Row(
                children: <Widget>[
                  Expanded(
                    child: Card(
                        child: Container(
                          padding: EdgeInsets.all(10.0),
                          child: Column(
                            children: <Widget>[
                              Text("Jan"),
                              Text("06", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),),
                            ],
                          ),
                        )
                    ),
                  ),
                  Expanded(
                    child: Card(
                        child: Container(
                          padding: EdgeInsets.all(10.0),
                          child: Column(
                            children: <Widget>[
                              Text("Feb"),
                              Text("03", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),),
                            ],
                          ),
                        )
                    ),
                  ),
                  Expanded(
                    child: Card(
                        child: Container(
                          padding: EdgeInsets.all(10.0),
                          child: Column(
                            children: <Widget>[
                              Text("Mar"),
                              Text("02", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),),
                            ],
                          ),
                        )
                    ),
                  ),
                  Expanded(
                    child: Card(
                        child: Container(
                          padding: EdgeInsets.all(10.0),
                          child: Column(
                            children: <Widget>[
                              Text("Apr"),
                              Text("02", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),),
                            ],
                          ),
                        )
                    ),
                  ),
                  Expanded(
                    child: Card(
                        child: Container(
                          padding: EdgeInsets.all(10.0),
                          child: Column(
                            children: <Widget>[
                              Text("Mei"),
                              Text("02", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),),
                            ],
                          ),
                        )
                    ),
                  ),
                  Expanded(
                    child: Card(
                        child: Container(
                          padding: EdgeInsets.all(10.0),
                          child: Column(
                            children: <Widget>[
                              Text("Jun"),
                              Text("02", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),),
                            ],
                          ),
                        )
                    ),
                  ),
                ],
              ),

              Row(
                children: <Widget>[
                  Expanded(
                    child: Card(
                        child: Container(
                          padding: EdgeInsets.all(10.0),
                          child: Column(
                            children: <Widget>[
                              Text("Jul"),
                              Text("06", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),),
                            ],
                          ),
                        )
                    ),
                  ),
                  Expanded(
                    child: Card(
                        child: Container(
                          padding: EdgeInsets.all(10.0),
                          child: Column(
                            children: <Widget>[
                              Text("Agu"),
                              Text("03", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),),
                            ],
                          ),
                        )
                    ),
                  ),
                  Expanded(
                    child: Card(
                        child: Container(
                          padding: EdgeInsets.all(10.0),
                          child: Column(
                            children: <Widget>[
                              Text("Sep"),
                              Text("02", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),),
                            ],
                          ),
                        )
                    ),
                  ),
                  Expanded(
                    child: Card(
                        child: Container(
                          padding: EdgeInsets.all(10.0),
                          child: Column(
                            children: <Widget>[
                              Text("Okt"),
                              Text("02", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),),
                            ],
                          ),
                        )
                    ),
                  ),
                  Expanded(
                    child: Card(
                        child: Container(
                          padding: EdgeInsets.all(10.0),
                          child: Column(
                            children: <Widget>[
                              Text("Nov"),
                              Text("02", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),),
                            ],
                          ),
                        )
                    ),
                  ),
                  Expanded(
                    child: Card(
                        child: Container(
                          padding: EdgeInsets.all(10.0),
                          child: Column(
                            children: <Widget>[
                              Text("Des"),
                              Text("02", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),),
                            ],
                          ),
                        )
                    ),
                  ),
                ],
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
                      Text("Grafik Desain", style: TextStyle(),),
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
                      Text("Kebutuhan Lahan", style: TextStyle(),),
                      SizedBox(
                        height: 200.0,
                        child: chartlahan,
                      )
                    ],
                  ),
                ),
              ),



              Padding(padding: EdgeInsets.only(top: 10.0),),
              // Container(
              //   padding: EdgeInsets.all(10.0),
              //   alignment: Alignment.centerLeft,
              //   color: Colors.blueAccent,
              //   child: Text("Progres Timer", style: TextStyle(color: Colors.white),),
              // ),
              // Card(
              //   child: Container(
              //     padding: EdgeInsets.all(10.0),
              //     child: Column(
              //       children: <Widget>[
              //         Text("Kebutuhan Lahan", style: TextStyle(),),
              //         SizedBox(
              //           height: 200.0,
              //           child: data == null
              //               ? Center(child: CircularProgressIndicator())
              //               : createChart(),
              //         )
              //       ],
              //     ),
              //   ),
              // ),


              Padding(padding: EdgeInsets.only(top: 10.0),),
              // Container(
              //   padding: EdgeInsets.all(10.0),
              //   alignment: Alignment.centerLeft,
              //   color: Colors.blueAccent,
              //   child: Text("Barchart 2", style: TextStyle(color: Colors.white),),
              // ),
              // Card(
              //   child: Container(
              //     padding: EdgeInsets.all(10.0),
              //     child: Column(
              //       children: <Widget>[
              //         Text("Barchart dari JSON", style: TextStyle(),),
              //         SizedBox(
              //           height: 200.0,
              //           child: data == null
              //               ? Center(child: CircularProgressIndicator())
              //               : SfCartesianChart(
              //                   primaryXAxis: CategoryAxis(),
              //                   legend: Legend(isVisible: false),
              //                   tooltipBehavior: TooltipBehavior(
              //                       enable: true,
              //                       header: 'Sales',
              //                       format: "point.x : point.y",
              //                   ),
              //                   series: <ChartSeries<SalesData, String>>[
              //                     ColumnSeries<SalesData, String>(
              //                       dataSource: chartData,
              //                       xValueMapper: (SalesData sale,_)=>sale.year,
              //                       yValueMapper: (SalesData sale,_)=>sale.sales,
              //                       dataLabelSettings: DataLabelSettings(isVisible: true),
              //                       color: Colors.orange
              //                     )
              //                   ],
              //           )
              //         )
              //       ],
              //     ),
              //   ),
              // ),

            ],
          ),
        ),
      ),
    );
  }

  charts.Series<LiveWerkzeuge, String> createSeries(String id, int i){
    return charts.Series<LiveWerkzeuge, String>(
      id: id,
      domainFn: (LiveWerkzeuge wear,_)=>wear.wsp,
      measureFn: (LiveWerkzeuge wear,_)=>wear.belastung,
      data: [
        LiveWerkzeuge('Inventarisasi', data[i]['temp1']),
        LiveWerkzeuge('Pengumuman', data[i]['temp2']),
        LiveWerkzeuge('Apraisal', data[i]['temp3']),
        LiveWerkzeuge('Musyawarah', data[i]['temp4']),
      ],
      labelAccessorFn: (LiveWerkzeuge wear,_)=>'${wear.wsp.toString()}',
    );
  }

  charts.Series<LiveWerkzeuge, String> createSeries2(String id, int i){
    return charts.Series<LiveWerkzeuge, String>(
      id: id,
      domainFn: (LiveWerkzeuge wear,_)=>wear.wsp,
      measureFn: (LiveWerkzeuge wear,_)=>wear.belastung,
      data: [
        LiveWerkzeuge('Inventarisasi', data[i]['temp3']),
        LiveWerkzeuge('Pengumuman', data[i]['temp1']),
        LiveWerkzeuge('Apraisal', data[i]['temp4']),
        LiveWerkzeuge('Musyawarah', data[i]['temp2']),
      ],
      labelAccessorFn: (LiveWerkzeuge wear,_)=>'${wear.wsp.toString()}',
    );
  }

  Widget createChart() {
    List<charts.Series<LiveWerkzeuge, String>> seriesList = [];

    for(int i=0; i<data.length; i++){
//      String id = 'Belum Realisasi${i + 1}';
//      String id2 = 'Sudah Realisasi${i + 1}';
      String id = 'Belum Realisasi';
      String id2 = 'Sudah Realisasi';
      seriesList.add(createSeries(id, i));
      seriesList.add(createSeries2(id2, i));
    }

    return new charts.BarChart(
      seriesList,
      barGroupingType: charts.BarGroupingType.grouped,
      behaviors: [new charts.SeriesLegend()],
    );
  }

}

class LiveWerkzeuge {
  final String wsp;
  final int belastung;

  LiveWerkzeuge(this.wsp, this.belastung);
}

class Konstruksi {
  final String xaxis;
  final int yaxis;
  final charts.Color color;

  Konstruksi(this.xaxis, this.yaxis, Color color)
      : this.color=charts.Color(r: color.red,g: color.green,b: color.blue,a: color.alpha);

}


class SalesData {
  SalesData(this.year, this.sales);

  final String year;
  final double sales;

  factory SalesData.fromJson(Map<String, dynamic> parsedJson){
    return SalesData(
      parsedJson['year'].toString(),
      parsedJson['sales'] as double,
    );
  }

}