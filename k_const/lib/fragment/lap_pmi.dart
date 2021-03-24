import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;

import '../viewlaporan.dart';

class Lappmi extends StatefulWidget {
  @override
  LappmiState createState() => LappmiState();
}

class LappmiState extends State<Lappmi> {
  List laporan = [];
  List filterLaporan = [];
  List filterLaporanMingguan = [];
  bool isSearching = false;

  getLaporan() async {
//    var response = await Dio().get('http://123.100.226.123:1720/index.php/mobile/get_pmi');
//    return response.data;
    var url = "http://123.100.226.123:1720/index.php/mobile/get_pmi";
    final response = await http.get(url);
    return json.decode(response.body);
  }

  @override
  void initState() {
    // TODO: implement initState
    getLaporan().then((data){
      setState(() {
        laporan = filterLaporan = filterLaporanMingguan = data;
      });
    });
    super.initState();
  }

  void _filterLaporan(value){
    setState(() {
      filterLaporan = laporan
          .where((laporan)=>
          laporan['nama_ruas'].toLowerCase().contains(value.toLowerCase()))
          .toList();
    });
  }

  void _filterLaporanMingguan(){
    setState(() {
      filterLaporan = laporan
          .where((laporan)=>
          laporan['jenis_laporan_pmi'] == 'Mingguan')
          .toList();
    });
  }

  void _filterLaporanBulanan(){
    setState(() {
      filterLaporan = laporan
          .where((laporan)=>
      laporan['jenis_laporan_pmi'] == 'Bulanan')
          .toList();
    });
  }

  void _filterLaporanKhusus(){
    setState(() {
      filterLaporan = laporan
          .where((laporan)=>
      laporan['jenis_laporan_pmi'] == 'Khusus')
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: !isSearching
            ? Text('Laporan PMI', style: TextStyle(color: Colors.black54),)
            : TextField(
          onChanged: (value){
            _filterLaporan(value);
          },
          decoration: InputDecoration(
              hintText: "Search",

//              prefixIcon: Icon(Icons.search, color: Colors.black54,),
          ),
        ),
        actions: <Widget>[
          isSearching
              ? IconButton(
                  icon: Icon(Icons.cancel, color: Colors.black54,),
                  onPressed: (){
                    setState(() {
                      this.isSearching = false;
                      filterLaporan = laporan;
                    });
                  },
              )
              : IconButton(
                  icon: Icon(Icons.search, color: Colors.black54,),
                  onPressed: (){
                    setState(() {
                      this.isSearching = true;
                    });
                  },
              )
        ],
      ),
      body: Column(
        children: <Widget>[
          Container(
            height: 60.0,
//            padding: EdgeInsets.all(20),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: FlatButton.icon(
                    icon: Icon(Icons.list),
                    label: Text("Mingguan"),
                    onPressed: (){
                      _filterLaporanMingguan();
                    },
                  ),
                ),
                Expanded(
                  child: FlatButton.icon(
                    icon: Icon(Icons.list),
                    label: Text("Bulanan"),
                    onPressed: (){
                      _filterLaporanBulanan();
                    },
                  ),
                ),
                Expanded(
                  child: FlatButton.icon(
                    icon: Icon(Icons.list),
                    label: Text("Khusus"),
                    onPressed: (){
                      _filterLaporanKhusus();
                    },
                  ),
                )
              ],
            ),
          ),
          Expanded(
              child: filterLaporan.length > 0
                  ? ListView.builder(
                  itemCount: filterLaporan.length,
                  itemBuilder: (BuildContext context, int index){
                    return Card(
                        child: Container(
                          padding: EdgeInsets.all(20.0),
                          child: Column(
                            children: <Widget>[
                              Container(
                                alignment: Alignment.centerLeft,
                                child: Text(filterLaporan[index]['nama_ruas'], style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17.0),),
                              ),
                              Row(
                                children: <Widget>[
                                  Expanded(
                                    child: Text("Jenis Laporan : "+filterLaporan[index]['jenis_laporan_pmi'], style: TextStyle(color: Colors.black54),),
                                  ),
                                  Expanded(
                                    child: Text(filterLaporan[index]['tanggal_laporan_pmi'], style: TextStyle(color: Colors.black54)),
                                  ),
                                ],
                              ),
                              Padding(padding: EdgeInsets.only(top: 10.0)),
                              Container(
                                alignment: Alignment.centerLeft,
                                child: Text("Keterangan :    "+filterLaporan[index]['keterangan']),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  IconButton(
                                      icon: Icon(Icons.more, color: Colors.lightBlueAccent),
                                      onPressed: (){

                                      }
                                  ),
                                  IconButton(
                                      icon: Icon(Icons.visibility, color: Colors.green),
                                      onPressed: (){
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => ViewLaporanPage(
                                                urlParsing: "http://123.100.226.123:1720/file_uploads/laporan_pmi/"+filterLaporan[index]['file_laporan_pmi'],
                                              ),
                                          ),
                                        );
                                      }
                                  ),
                                  IconButton(
                                      icon: Icon(Icons.delete, color: Colors.red),
                                      onPressed: (){

                                      }
                                  )
                                ],
                              )
                            ],
                          ),
                        )
                    );
                  }
              )
                  : Center(
                child: CircularProgressIndicator(),
              )
          )
        ],
      )
    );
  }
}