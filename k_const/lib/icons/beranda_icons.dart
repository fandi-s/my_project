import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:kconst/icons/kategori/detail_kategori.dart';
import 'package:kconst/utils/dotsindicator.dart';

import 'package:http/http.dart' as http;

class BerandaIcons extends StatefulWidget{
  @override
  BerandaIconsState createState() => BerandaIconsState();
}

class BerandaIconsState extends State<BerandaIcons> {

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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
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
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    final List<Widget> _pages = <Widget>[
      new ConstrainedBox(
        constraints: const BoxConstraints.expand(),
        child: prog.length > 0
        ? ListView.builder(
          itemCount: prog.length,
          itemBuilder: (BuildContext context, int index){
            double tj = double.parse(prog[index]['granttot_progres_tanah_jawa']);
            String valTJ = tj.toStringAsFixed(2);
            double valueTJ = double.parse(valTJ)/100;
            String valTJ2 = valueTJ.toStringAsFixed(2);
            double valueTjW = double.parse(valTJ2);

            double ntj = double.parse(prog[index]['granttot_progres_tanah_nonTjawa']);
            String valNTJ = ntj.toStringAsFixed(2);
            double valueNTJ = double.parse(valNTJ)/100;
            String valNTJ2 = valueNTJ.toStringAsFixed(2);
            double valueNTjW = double.parse(valNTJ2);

            double jbdtb = double.parse(prog[index]['granttot_progres_tanah_transJabotabek']);
            String valJBDTB = jbdtb.toStringAsFixed(2);
            double valueJBDTB = double.parse(valJBDTB)/100;
            String valJBDTB2 = valueJBDTB.toStringAsFixed(2);
            double valueJBDTb = double.parse(valJBDTB2);

            double ts = double.parse(prog[index]['granttot_progres_tanah_sumatra']);
            String valTS = ts.toStringAsFixed(2);
            double valueTS = double.parse(valTS)/100;
            String valTS2 = valueTS.toStringAsFixed(2);
            double valueTSm = double.parse(valTS2);


            return Container(
              decoration: BoxDecoration(
                  color: Colors.black26,
                  borderRadius: BorderRadius.only(
                      topRight: const Radius.circular(30.0),
                      topLeft: const Radius.circular(30.0),
                      bottomRight: const Radius.circular(10.0),
                      bottomLeft: const Radius.circular(10.0)
                  ),
                  gradient: LinearGradient(
                      colors: [
                        Colors.black38,
                        Colors.black26,
                        Colors.white
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter
                  )
              ),
              child: Column(
                children: <Widget>[
                  Container(
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.only(left: 35.0, top: 30.0, bottom: 30.0),
                    child: Text("Progres Tanah", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.0, color: Colors.black),),
                  ),
                  Container(
                    height: 350,
                    padding: EdgeInsets.only(left: 30.0, right: 30.0),
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                          color: Colors.black87,
                          borderRadius: BorderRadius.only(
                              topLeft: const Radius.circular(15.0),
                              topRight: const Radius.circular(15.0),
                              bottomLeft: const Radius.circular(15.0),
                              bottomRight: const Radius.circular(15.0)
                          )
                      ),
                      child: Column(
                        children: <Widget>[
                          Padding(padding: EdgeInsets.only(top: 35.0),),
                          Container(
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  flex: 3,
                                  child: Column(
                                    children: <Widget>[
                                      Row(
                                        children: <Widget>[
                                          Expanded(
                                            flex: 2,
                                            child: Container(
                                              padding: EdgeInsets.only(left: 35.0),
                                              alignment: Alignment.centerLeft,
                                              child: Text("Trans Jawa", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                                            ),
                                          ),
                                          Expanded(
                                            flex: 2,
                                            child: Container(
                                              padding: EdgeInsets.only(right: 35.0),
                                              alignment: Alignment.centerRight,
                                              child: Text("${valTJ} %", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Container(
                                        padding: EdgeInsets.only(top: 10.0, right: 35.0, left: 35.0),
                                        child: LinearProgressIndicator(
                                          backgroundColor: Colors.white,
                                          valueColor: AlwaysStoppedAnimation<Color>(Colors.redAccent),
                                          value: valueTjW,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                          Padding(padding: EdgeInsets.only(top: 35.0),),
                          Container(
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  flex: 3,
                                  child: Column(
                                    children: <Widget>[
                                      Row(
                                        children: <Widget>[
                                          Expanded(
                                            flex: 2,
                                            child: Container(
                                              padding: EdgeInsets.only(left: 35.0),
                                              alignment: Alignment.centerLeft,
                                              child: Text("Non Trans Jawa", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                                            ),
                                          ),
                                          Expanded(
                                            flex: 2,
                                            child: Container(
                                              padding: EdgeInsets.only(right: 35.0),
                                              alignment: Alignment.centerRight,
                                              child: Text("${valNTJ} %", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Container(
                                        padding: EdgeInsets.only(top: 10.0, right: 35.0, left: 35.0),
                                        child: LinearProgressIndicator(
                                          backgroundColor: Colors.white,
                                          valueColor: AlwaysStoppedAnimation<Color>(Colors.yellowAccent),
                                          value: valueNTjW,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                          Padding(padding: EdgeInsets.only(top: 35.0),),
                          Container(
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  flex: 3,
                                  child: Column(
                                    children: <Widget>[
                                      Row(
                                        children: <Widget>[
                                          Expanded(
                                            flex: 2,
                                            child: Container(
                                              padding: EdgeInsets.only(left: 35.0),
                                              alignment: Alignment.centerLeft,
                                              child: Text("Jabodetabek", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                                            ),
                                          ),
                                          Expanded(
                                            flex: 2,
                                            child: Container(
                                              padding: EdgeInsets.only(right: 35.0),
                                              alignment: Alignment.centerRight,
                                              child: Text("${valJBDTB} %", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Container(
                                        padding: EdgeInsets.only(top: 10.0, right: 35.0, left: 35.0),
                                        child: LinearProgressIndicator(
                                          backgroundColor: Colors.white,
                                          valueColor: AlwaysStoppedAnimation<Color>(Colors.greenAccent),
                                          value: valueJBDTb,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                          Padding(padding: EdgeInsets.only(top: 35.0),),
                          Container(
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  flex: 3,
                                  child: Column(
                                    children: <Widget>[
                                      Row(
                                        children: <Widget>[
                                          Expanded(
                                            flex: 2,
                                            child: Container(
                                              padding: EdgeInsets.only(left: 35.0),
                                              alignment: Alignment.centerLeft,
                                              child: Text("Trans Sumatera", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                                            ),
                                          ),
                                          Expanded(
                                            flex: 2,
                                            child: Container(
                                              padding: EdgeInsets.only(right: 35.0),
                                              alignment: Alignment.centerRight,
                                              child: Text("${valTS} %", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Container(
                                        padding: EdgeInsets.only(top: 10.0, right: 35.0, left: 35.0),
                                        child: LinearProgressIndicator(
                                          backgroundColor: Colors.white,
                                          valueColor: AlwaysStoppedAnimation<Color>(Colors.blueAccent),
                                          value: valueTSm,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          )

                        ],
                      ),
                    ),
                  )
                ],
              ),
            );
          },
        )
        : Container(
          child: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      ),
      new ConstrainedBox(
        constraints: const BoxConstraints.expand(),
        child: progKonst.length > 0
        ? ListView.builder(
            itemCount: progKonst.length,
            itemBuilder: (BuildContext context, int index){

              double tj = double.parse(progKonst[index]['RealisasiJawa']);
              String valTJ = tj.toStringAsFixed(2);
              double valueTJ = double.parse(valTJ)/100;
              String valTJ2 = valueTJ.toStringAsFixed(2);
              double valueTjW = double.parse(valTJ2);

              double ntj = double.parse(progKonst[index]['RealisasiNonJawa']);
              String valNTJ = ntj.toStringAsFixed(2);
              double valueNTJ = double.parse(valNTJ)/100;
              String valNTJ2 = valueNTJ.toStringAsFixed(2);
              double valueNTjW = double.parse(valNTJ2);

              double jbdtb = double.parse(progKonst[index]['RealisasiJabotabek']);
              String valJBDTB = jbdtb.toStringAsFixed(2);
              double valueJBDTB = double.parse(valJBDTB)/100;
              String valJBDTB2 = valueJBDTB.toStringAsFixed(2);
              double valueJBDTb = double.parse(valJBDTB2);

              double ts = double.parse(progKonst[index]['RealisasiSumatra']);
              String valTS = ts.toStringAsFixed(2);
              double valueTS = double.parse(valTS)/100;
              String valTS2 = valueTS.toStringAsFixed(2);
              double valueTSm = double.parse(valTS2);

              return Container(
                decoration: BoxDecoration(
                    color: Colors.black26,
                    borderRadius: BorderRadius.only(
                        topRight: const Radius.circular(30.0),
                        topLeft: const Radius.circular(30.0),
                        bottomRight: const Radius.circular(10.0),
                        bottomLeft: const Radius.circular(10.0)
                    ),
                    gradient: LinearGradient(
                        colors: [
                          Colors.black38,
                          Colors.black26,
                          Colors.white
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter
                    )
                ),
                child: Column(
                  children: <Widget>[
                    Container(
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.only(left: 35.0, top: 30.0, bottom: 30.0),
                      child: Text("Progres Konstruksi", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.0, color: Colors.black),),
                    ),
                    Container(
                      height: 350,
                      padding: EdgeInsets.only(left: 30.0, right: 30.0),
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                            color: Colors.black87,
                            borderRadius: BorderRadius.only(
                                topLeft: const Radius.circular(15.0),
                                topRight: const Radius.circular(15.0),
                                bottomLeft: const Radius.circular(15.0),
                                bottomRight: const Radius.circular(15.0)
                            )
                        ),
                        child: Column(
                          children: <Widget>[
                            Padding(padding: EdgeInsets.only(top: 35.0),),
                            Container(
                              child: Row(
                                children: <Widget>[
                                  Expanded(
                                    flex: 3,
                                    child: Column(
                                      children: <Widget>[
                                        Row(
                                          children: <Widget>[
                                            Expanded(
                                              flex: 2,
                                              child: Container(
                                                padding: EdgeInsets.only(left: 35.0),
                                                alignment: Alignment.centerLeft,
                                                child: Text("Trans Jawa", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                                              ),
                                            ),
                                            Expanded(
                                              flex: 2,
                                              child: Container(
                                                padding: EdgeInsets.only(right: 35.0),
                                                alignment: Alignment.centerRight,
                                                child: Text("${valTJ} %", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Container(
                                          padding: EdgeInsets.only(top: 10.0, right: 35.0, left: 35.0),
                                          child: LinearProgressIndicator(
                                            backgroundColor: Colors.white,
                                            valueColor: AlwaysStoppedAnimation<Color>(Colors.redAccent),
                                            value: valueTjW,
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Padding(padding: EdgeInsets.only(top: 35.0),),
                            Container(
                              child: Row(
                                children: <Widget>[
                                  Expanded(
                                    flex: 3,
                                    child: Column(
                                      children: <Widget>[
                                        Row(
                                          children: <Widget>[
                                            Expanded(
                                              flex: 2,
                                              child: Container(
                                                padding: EdgeInsets.only(left: 35.0),
                                                alignment: Alignment.centerLeft,
                                                child: Text("Non Trans Jawa", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                                              ),
                                            ),
                                            Expanded(
                                              flex: 2,
                                              child: Container(
                                                padding: EdgeInsets.only(right: 35.0),
                                                alignment: Alignment.centerRight,
                                                child: Text("${valNTJ} %", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Container(
                                          padding: EdgeInsets.only(top: 10.0, right: 35.0, left: 35.0),
                                          child: LinearProgressIndicator(
                                            backgroundColor: Colors.white,
                                            valueColor: AlwaysStoppedAnimation<Color>(Colors.yellowAccent),
                                            value: valueNTjW,
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Padding(padding: EdgeInsets.only(top: 35.0),),
                            Container(
                              child: Row(
                                children: <Widget>[
                                  Expanded(
                                    flex: 3,
                                    child: Column(
                                      children: <Widget>[
                                        Row(
                                          children: <Widget>[
                                            Expanded(
                                              flex: 2,
                                              child: Container(
                                                padding: EdgeInsets.only(left: 35.0),
                                                alignment: Alignment.centerLeft,
                                                child: Text("Jabodetabek", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                                              ),
                                            ),
                                            Expanded(
                                              flex: 2,
                                              child: Container(
                                                padding: EdgeInsets.only(right: 35.0),
                                                alignment: Alignment.centerRight,
                                                child: Text("${valJBDTB} %", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Container(
                                          padding: EdgeInsets.only(top: 10.0, right: 35.0, left: 35.0),
                                          child: LinearProgressIndicator(
                                            backgroundColor: Colors.white,
                                            valueColor: AlwaysStoppedAnimation<Color>(Colors.greenAccent),
                                            value: valueJBDTb,
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Padding(padding: EdgeInsets.only(top: 35.0),),
                            Container(
                              child: Row(
                                children: <Widget>[
                                  Expanded(
                                    flex: 3,
                                    child: Column(
                                      children: <Widget>[
                                        Row(
                                          children: <Widget>[
                                            Expanded(
                                              flex: 2,
                                              child: Container(
                                                padding: EdgeInsets.only(left: 35.0),
                                                alignment: Alignment.centerLeft,
                                                child: Text("Trans Sumatera", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                                              ),
                                            ),
                                            Expanded(
                                              flex: 2,
                                              child: Container(
                                                padding: EdgeInsets.only(right: 35.0),
                                                alignment: Alignment.centerRight,
                                                child: Text("${valTS} %", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Container(
                                          padding: EdgeInsets.only(top: 10.0, right: 35.0, left: 35.0),
                                          child: LinearProgressIndicator(
                                            backgroundColor: Colors.white,
                                            valueColor: AlwaysStoppedAnimation<Color>(Colors.blueAccent),
                                            value: valueTSm,
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            )

                          ],
                        ),
                      ),
                    )
                  ],
                ),
              );
            },
        ) : Container(
          child: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      ),
    ];

    final _controller = new PageController();
    const _kDuration = const Duration(milliseconds: 300);
    const _kCurve = Curves.ease;

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
              Padding(padding: EdgeInsets.only(top: 35.0,),),
              Row(
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: Container(
                        padding: EdgeInsets.only(left: 35.0, top: 20.0),
                        alignment: Alignment.bottomLeft,
                        child: GestureDetector(
                          onTap: (){
                            Scaffold.of(context).openDrawer();
                          },
                          child: Image.asset('assets/images/menu.png', width: 32.0, color: Colors.black54,),
                        )
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Container(
                      height: 150,
                      decoration: BoxDecoration(
                        color: Colors.white24,
                        borderRadius: BorderRadius.circular(10),
                        image: DecorationImage(
                          image: AssetImage('assets/icon/icon_dashboard.png'),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: Center(
                        child: OutlineButton(
                          onPressed: (){},
                          child: Stack(
                            children: <Widget>[
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Image.asset('assets/images/arrowright.png', width: 20.0, color: Colors.indigo,),
                              ),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding: EdgeInsets.only(left: 25.0),
                                  child: Text("Dashboard", style: TextStyle(fontSize: 13),),
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
                    ),
                  ),
                  Padding(padding: EdgeInsets.only(right: 35),),
                ],
              ),
              // Padding(padding: EdgeInsets.only(top: 15.0),),
              Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.only(left: 35.0, top: 30.0, bottom: 20.0),
                child: Text("Kategori", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.0),),
              ),
              Container(
                padding: EdgeInsets.only(left: 35.0, right: 35.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: OutlineButton(
                        onPressed: (){
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DetailKategori(
                                kategori: "Trans Jawa",
                                id_kategori: "1",
                              ),
                            ),
                          );
                        },
                        child: Stack(
                          children: <Widget>[
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Image.asset('assets/images/arrowright.png', width: 20.0, color: Colors.indigo,),
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: EdgeInsets.only(left: 25.0),
                                child: Text("Trans Jawa", style: TextStyle(fontSize: 13),),
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
                    Padding(padding: EdgeInsets.only(left: 7.0, right: 7.0),),
                    Expanded(
                      child: OutlineButton(
                        onPressed: (){
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DetailKategori(
                                kategori: "Non Trans Jawa",
                                id_kategori: "2",
                              ),
                            ),
                          );
                        },
                        child: Stack(
                          children: <Widget>[
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Image.asset('assets/images/arrowright.png', width: 20.0, color: Colors.indigo,),
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: EdgeInsets.only(left: 30.0),
                                child: Text("Non Trans Jawa", style: TextStyle(fontSize: 13),),
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
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.only(left: 35.0, right: 35.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: OutlineButton(
                        onPressed: (){
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DetailKategori(
                                kategori: "Jabodetabek",
                                id_kategori: "3",
                              ),
                            ),
                          );
                        },
                        child: Stack(
                          children: <Widget>[
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Image.asset('assets/images/arrowright.png', width: 20.0, color: Colors.indigo,),
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: EdgeInsets.only(left: 25.0),
                                child: Text("Jabodetabek", style: TextStyle(fontSize: 13),),
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
                    Padding(padding: EdgeInsets.only(left: 7.0, right: 7.0),),
                    Expanded(
                      child: OutlineButton(
                        onPressed: (){
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DetailKategori(
                                kategori: "Trans Sumatera",
                                id_kategori: "4",
                              ),
                            ),
                          );
                        },
                        child: Stack(
                          children: <Widget>[
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Image.asset('assets/images/arrowright.png', width: 20.0, color: Colors.indigo,),
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: EdgeInsets.only(left: 30.0),
                                child: Text("Trans Sumatera", style: TextStyle(fontSize: 13),),
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
                  ],
                ),
              ),
              // Padding(padding: EdgeInsets.only(top: 50.0),),
              Container(
                height: 500,
                child: Stack(
                  children: <Widget>[
                    PageView.builder(
                        physics: AlwaysScrollableScrollPhysics(),
                        controller: _controller,
                        itemBuilder: (BuildContext context, int index){
                          return _pages[index % _pages.length];
                        }
                    ),
                    Positioned(
                      bottom: -20.0,
                      left: 0.0,
                      right: 0.0,
                      child: Container(
                        // color: Colors.grey[800].withOpacity(0.5),
                        padding: const EdgeInsets.all(20.0),
                        child: Center(
                          child: DotsIndicator(
                            controller: _controller,
                            itemCount: _pages.length,
                            onPageSelected: (int page){
                              _controller.animateToPage(page, duration: _kDuration, curve: _kCurve);
                            },
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}