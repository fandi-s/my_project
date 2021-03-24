import 'dart:convert';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kconst/icons/ruas/detail_ruas.dart';
import 'package:kconst/utils/dotsindicator.dart';

import 'package:http/http.dart' as http;

class DetailKategori extends StatefulWidget{

  final String kategori;
  final String id_kategori;
  DetailKategori({Key key, @required this.kategori, this.id_kategori}) : super(key: key);

  @override
  _DetailKategoriState createState() => _DetailKategoriState();
}

class _DetailKategoriState extends State<DetailKategori> {

  List dataBarnya = [];
  List filterDatabarnya = [];
  double progreTanSmtra;
  String strProgTanSmtra;
  double valueCirSmtra = 0;
  double progreKonTanSmtra;
  String strKonProgTanSmtra;
  double valueKonCirSmtra = 0;

  var url;

  getData() async {
    // url = "http://i_cons.bpjt.pu.go.id/api/grafik_ruas/${widget.id_kategori}";
    url = "http://i_cons.bpjt.pu.go.id/api/getRuasRegion/${widget.id_kategori}";
    final response = await http.get(url);
    return json.decode(response.body);
  }

  List prog = [];
  List progKonst = [];

  getProgres() async {
    var url = "http://i_cons.bpjt.pu.go.id/api/dashboard";
    final response = await http.get(url);
    return json.decode(response.body);
  }

  getProgkonst() async {
    var url = "http://i_cons.bpjt.pu.go.id/api/prog_konstruksi";
    final response = await http.get(url);
    return json.decode(response.body);
  }

  final Color leftBarColor = const Color(0xff53fdd7);
  final Color middleBarColor = const Color(0xff00c1fc);
  final Color rightBarColor = const Color(0xffff5182);
  double width;
  getWith(){
    if(widget.id_kategori == "1"){
      width = 7;
    }else if(widget.id_kategori == "2"){
      width = 4;
    }else if(widget.id_kategori == "3"){
      width = 4;
    }else if(widget.id_kategori == "4"){
      width = 7;
    }
  }

  List<BarChartGroupData> rawBarGroups;
  List<BarChartGroupData> showingBarGroups;

  int touchedGroupIndex;
  final _controller = new PageController();
  final _kDuration = const Duration(milliseconds: 300);
  final _kCurve = Curves.ease;

  List<Widget> _pages;

  void showDialogOperasi() {
    showGeneralDialog(
        barrierLabel: "Label",
        barrierDismissible: true,
        barrierColor: Colors.black.withOpacity(0.5),
        transitionDuration: Duration(milliseconds: 700),
        context: context,
        pageBuilder: (context, anim1, anim2){
          return Align(
            alignment: Alignment.center,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
              ),
              height: 100,
              width: 200,
              child: FlatButton(
                child: Text("Ruas sudah operasi...!", style: TextStyle(color: Colors.green),),
              ),
            ),
          );
        }
    );
  }

  bool showChoice = false;

  void _filterKonstruksi(){
    setState(() {
      filterDatabarnya = dataBarnya
          .where((region)=>
      region['status'] == '1')
          .toList();
    });
  }

  void _filterPersiapan(){
    setState(() {
      filterDatabarnya = dataBarnya
          .where((region)=>
      region['status'] == '2')
          .toList();
    });
  }

  void _filterOperasi(){
    setState(() {
      filterDatabarnya = dataBarnya
          .where((region)=>
      region['status'] == '3')
          .toList();
    });
  }

  var colorBtnKon = Colors.white30;
  var colorBtnOpr = Colors.white30;
  var colorBtnPer = Colors.white30;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getData().then((data){
      setState(() {
        filterDatabarnya = dataBarnya = data;
      });
    });

    getProgres().then((data){
      setState(() {
        prog = data;
      });
    });

    getProgkonst().then((data){
      setState(() {
        progKonst = data;
      });
    });

    getWith();

  }
  String url_parse = "";

  @override
  Widget build(BuildContext context) {
    if(widget.id_kategori=="1"){
      url_parse = "http://i_cons.bpjt.pu.go.id/api/getRuasRegion/1";
    }else if(widget.id_kategori=="2"){
      url_parse = "http://i_cons.bpjt.pu.go.id/api/getRuasRegion/2";
    }else if(widget.id_kategori=="3"){
      url_parse = "http://i_cons.bpjt.pu.go.id/api/getRuasRegion/3";
    }else if(widget.id_kategori=="4"){
      url_parse = "http://i_cons.bpjt.pu.go.id/api/getRuasRegion/4";
    }

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.blueAccent,
                Colors.white60,
                Colors.white,
              ],
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
            )
        ),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Padding(padding: EdgeInsets.only(top: 50),),
              Container(
                padding: EdgeInsets.only(left: 5, right: 5),
                child: Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  color: Colors.black45,
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            GestureDetector(
                              onTap: (){
                                if(showChoice==false){
                                  setState(() {
                                    showChoice=true;
                                  });
                                }else{
                                  setState(() {
                                    showChoice=false;
                                  });
                                }
                              },
                              child: Container(
                                child: makeTransactionsIcon(),
                              ),
                            ),
                            const SizedBox(
                              width: 38,
                            ),
                            const Text(
                              "Pilih Ruas",
                              style: TextStyle(color: Colors.white60, fontSize: 16),
                            ),
                            const SizedBox(
                              width: 4,
                            ),
                            Text("${widget.kategori}", style: TextStyle(color: Colors.white, fontSize: 22)),

                          ],
                        ),
                        !showChoice ?
                        Container(
                          padding: EdgeInsets.only(top: 20),
                          child: Row(
                            children: [
                              Expanded(
                                child: OutlineButton(
                                  onPressed: (){
                                    _filterKonstruksi();
                                    setState(() {
                                      colorBtnKon = Colors.white;
                                      colorBtnPer = Colors.white30;
                                      colorBtnOpr = Colors.white30;
                                    });
                                  },
                                  borderSide: BorderSide(
                                      color: colorBtnKon
                                  ),
                                  child: Text("Konstruksi", style: TextStyle(color: Colors.white70),),
                                ),
                              ),
                              Padding(padding: EdgeInsets.only(left: 10)),
                              Expanded(
                                child: OutlineButton(
                                  onPressed: (){
                                    _filterPersiapan();
                                    setState(() {
                                      colorBtnKon = Colors.white30;
                                      colorBtnPer = Colors.white;
                                      colorBtnOpr = Colors.white30;
                                    });
                                  },
                                  borderSide: BorderSide(
                                      color: colorBtnPer
                                  ),
                                  child: Text("Persiapan", style: TextStyle(color: Colors.white70),),
                                ),
                              ),
                              Padding(padding: EdgeInsets.only(right: 10)),
                              Expanded(
                                child: OutlineButton(
                                  onPressed: (){
                                    _filterOperasi();
                                    setState(() {
                                      colorBtnKon = Colors.white30;
                                      colorBtnPer = Colors.white30;
                                      colorBtnOpr = Colors.white;
                                    });
                                  },
                                  borderSide: BorderSide(
                                      color: colorBtnOpr
                                  ),
                                  child: Text("Operasi", style: TextStyle(color: Colors.white70),),
                                ),
                              )
                            ],
                          ),
                        ) :
                        Container(),
                        Container(
                          height: MediaQuery.of(context).size.height*0.75,
                          child: filterDatabarnya.length > 0
                              ? ListView.builder(
                            itemCount: filterDatabarnya.length,
                            itemBuilder: (BuildContext context, int index){

                              String id_status = filterDatabarnya[index]['status'];
                              String status = "";
                              if(id_status=="1"){
                                status = "Konstruksi";
                              }else if(id_status=="2"){
                                status = "Persiapan";
                              }else if(id_status=="3"){
                                status = "Operasi";
                              }

                              return Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10),
                                  child: OutlineButton(
                                    padding: EdgeInsets.only(top: 10, left: 10, right: 10),
                                    borderSide: BorderSide(
                                      color: Colors.white70
                                    ),
                                    onPressed: (){
                                      // showDialogOperasi();
                                      Navigator.push(
                                           context,
                                           MaterialPageRoute(
                                             builder: (context) => DetailRuas(
                                               ruas: "${filterDatabarnya[index]['id_ruas']}",
                                               nama_ruas: "${filterDatabarnya[index]['NamaRuas']}",
                                               id_region: "${widget.id_kategori}",
                                               url_region: "${url_parse}",
                                               frompage: "region"
                                             ),
                                           ),
                                      );
                                    },
                                    child: Stack(
                                      children: <Widget>[
                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: Image.asset('assets/images/arrowright.png', width: 20.0, color: Colors.white38,),
                                        ),
                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: Padding(
                                            padding: EdgeInsets.only(left: 25.0, top: 3),
                                            child: Text("${filterDatabarnya[index]['NamaRuas']}", style: TextStyle(fontSize: 15, color: Colors.white),),
                                          ),
                                        ),
                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: Padding(
                                            padding: EdgeInsets.only(left: 25.0, top: 20),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Text("${filterDatabarnya[index]['seksi']}", style: TextStyle(color: Colors.white, fontSize: 11),),
                                                Padding(padding: EdgeInsets.only(top: 10),),
                                                Text("Panjang : ${filterDatabarnya[index]['panjang']} Km", style: TextStyle(color: Colors.white, fontSize: 11),),
                                                Text("Status : ${status}", style: TextStyle(color: Colors.white, fontSize: 11),),
                                                Padding(padding: EdgeInsets.only(bottom: 20),)
                                              ],
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                    highlightedBorderColor: Colors.lightBlueAccent,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10.0)
                                    ),
                                  ),
                                ),
                              );
                            },
                          ) : Container(
                            child: Center(
                              child: CircularProgressIndicator(),
                            ),
                          )
                        )
                      ],
                    ),
                  ),
                ),
              ),
              Padding(padding: EdgeInsets.only(top: 20.0),),

            ],
          ),
        ),
      ),
    );
  }

  Widget makeTransactionsIcon() {
    const double width = 4.5;
    const double space = 3.5;
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
          width: width,
          height: 10,
          color: Colors.white.withOpacity(0.4),
        ),
        const SizedBox(
          width: space,
        ),
        Container(
          width: width,
          height: 28,
          color: Colors.white.withOpacity(0.8),
        ),
        const SizedBox(
          width: space,
        ),
        Container(
          width: width,
          height: 42,
          color: Colors.white.withOpacity(1),
        ),
        const SizedBox(
          width: space,
        ),
        Container(
          width: width,
          height: 28,
          color: Colors.white.withOpacity(0.8),
        ),
        const SizedBox(
          width: space,
        ),
        Container(
          width: width,
          height: 10,
          color: Colors.white.withOpacity(0.4),
        ),
      ],
    );
  }


}