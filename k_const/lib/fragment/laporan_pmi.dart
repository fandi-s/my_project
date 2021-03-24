import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:kconst/viewlaporan.dart';

class Laporanpmi extends StatelessWidget{

  TextEditingController editingController = TextEditingController();
  List filterPmi = [];

  Future<List> getDataPmi() async {
    var url = "http://123.100.226.123:1720/index.php/mobile/get_pmi";
    final response = await http.get(url);
    return json.decode(response.body);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Container(
              padding: EdgeInsets.only(left: 10.0,right: 10.0),
              alignment: Alignment.centerLeft,
              child: TextField(
                onChanged: (value){

                },
                controller: editingController,
                decoration: InputDecoration(
                  labelText: "Search",
                  hintText: "Search",
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20.0))
                  )
                ),
              )
//              Text("Laporan PMI", style: TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.bold, fontSize: 20.0),),
            ),
          ),
          Expanded(
            flex: 9,
            child: Container(
              child: FutureBuilder<List>(
                future: getDataPmi(),
                builder: (context, snapshot){
                  if(snapshot.hasError) print(snapshot.error);
                  return snapshot.hasData
                      ? ItemList(list: snapshot.data)
                      : Center(child: CircularProgressIndicator());
                },
              ),
            ),
          ),

        ],
      ),
    );

  }
}

class ItemList extends StatelessWidget {
  List list;
  ItemList({this.list});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ListView.builder(
        itemCount: list==null ? 0 : list.length,
        itemBuilder: (context, i){
          return Card(
            child: Container(
              padding: EdgeInsets.all(20.0),
              child: Column(
                children: <Widget>[
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Text(list[i]['nama_ruas'], style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17.0),),
                  ),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Text("Jenis Laporan : "+list[i]['jenis_laporan_pmi'], style: TextStyle(color: Colors.black54),),
                      ),
                      Expanded(
                        child: Text(list[i]['tanggal_laporan_pmi'], style: TextStyle(color: Colors.black54)),
                      ),
                    ],
                  ),
                  Padding(padding: EdgeInsets.only(top: 10.0)),
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Text("    "+list[i]['keterangan']),
                  ),
                  Row(
                    children: <Widget>[
                      IconButton(icon: Icon(Icons.more, color: Colors.lightBlueAccent), onPressed: (){}),
                      IconButton(
                          icon: Icon(Icons.insert_drive_file, color: Colors.green), 
                          onPressed: (){
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => ViewLaporanPage()),
                            );
                          }
                      ),
                      IconButton(icon: Icon(Icons.delete, color: Colors.red), onPressed: (){})
                    ],
                  )
                ],
              ),
            ),
          );
        });
  }
}