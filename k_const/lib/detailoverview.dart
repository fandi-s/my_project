import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:kconst/icons/ruas/detail_ruas.dart';

class DetailOverviewPage extends StatefulWidget{

  final String url;
  final String nama;
  DetailOverviewPage({Key key, @required this.url, this.nama}) : super(key: key);

  @override
  DetailOverviewState createState() => DetailOverviewState();
}

class DetailOverviewState extends State<DetailOverviewPage> {

  List ruasoverview = [];
  List filterSearch = [];

  bool isSearching = false;
  bool isFilter = false;

  getRuasOverview() async {
    var url = widget.url;
    final response = await http.get(url);
    return json.decode(response.body);
  }

  @override
  void initState() {
    // TODO: implement initState

    getRuasOverview().then((data){
      setState(() {
        ruasoverview = filterSearch = data;
      });
    });

    super.initState();
  }

  void _filterSearch(value){
    setState(() {
      filterSearch = ruasoverview
          .where((namaruas)=>
          namaruas['NamaRuas'].toLowerCase().contains(value.toLowerCase()))
          .toList();
    });
  }

  void _filterRegionTJ(){
    setState(() {
      filterSearch = ruasoverview
          .where((region)=>
          region['id_region'] == '1')
          .toList();
    });
  }

  void _filterRegionNonTJ(){
    setState(() {
      filterSearch = ruasoverview
          .where((region)=>
      region['id_region'] == '2')
          .toList();
    });
  }

  void _filterRegionJab(){
    setState(() {
      filterSearch = ruasoverview
          .where((region)=>
      region['id_region'] == '3')
          .toList();
    });
  }

  void _filterRegionTS(){
    setState(() {
      filterSearch = ruasoverview
          .where((region)=>
      region['id_region'] == '4')
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
        leading: GestureDetector(
          onTap: (){
            setState(() {
              if(isFilter==false){
                this.isFilter = true;
              }else{
                this.isFilter = false;
              }
            });
          },
          child: Icon(Icons.list, color: Colors.black54,),
        ),
        title: !isSearching
            ? Text('${widget.nama}', style: TextStyle(color: Colors.black54, fontWeight: FontWeight.bold, fontSize: 17),)
            : TextField(
          onChanged: (value){
            _filterSearch(value);
          },
          decoration: InputDecoration(
            hintText: "Search",
          ),
        ),
        actions: <Widget>[
          isSearching
              ? IconButton(
            icon: Icon(Icons.cancel, color: Colors.black54,),
            onPressed: (){
              setState(() {
                this.isSearching = false;
                filterSearch = ruasoverview;
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
          !isFilter
              ? Container()
              : Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(left: 35, right: 35),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        alignment: Alignment.centerLeft,
                        child: FlatButton.icon(
                          icon: Icon(Icons.list, size: 12,),
                          label: Text("Trans Jawa"),
                          onPressed: (){
                            _filterRegionTJ();
                          },
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                          alignment: Alignment.centerLeft,
                          child: FlatButton.icon(
                            icon: Icon(Icons.list, size: 12,),
                            label: Text("Non Trans"),
                            onPressed: (){
                              _filterRegionNonTJ();
                            },
                          )
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.only(left: 35, right: 35),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Container(
                          alignment: Alignment.centerLeft,
                          child: FlatButton.icon(
                            icon: Icon(Icons.list, size: 12,),
                            label: Text("Jabodetabek"),
                            onPressed: (){
                              _filterRegionJab();
                            },
                          )
                      ),
                    ),
                    Expanded(
                      child: Container(
                          alignment: Alignment.centerLeft,
                          child: FlatButton.icon(
                            icon: Icon(Icons.list, size: 12,),
                            label: Text("Trans Sumatera"),
                            onPressed: (){
                              _filterRegionTS();
                            },
                          )
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Padding(padding: EdgeInsets.only(top: 20),),
          Expanded(
            flex: 9,
            child: Container(
              padding: EdgeInsets.only(left: 35, right: 35),
              child: filterSearch.length > 0
                  ? ListView.builder(
                itemCount: filterSearch.length,
                itemBuilder: (BuildContext context, int index){

                  String regionGet;
                  if(filterSearch[index]['id_region'] == "1"){
                    regionGet = "Trans Jawa";
                  }else if(filterSearch[index]['id_region'] == "2"){
                    regionGet = "Non Trans";
                  }else if(filterSearch[index]['id_region'] == "3"){
                    regionGet = "Jabodetabek";
                  }else if(filterSearch[index]['id_region'] == "4"){
                    regionGet = "Trans Sumatera";
                  }

                  return Container(
                    padding: EdgeInsets.only(bottom: 10),
                    child: OutlineButton(
                      borderSide: BorderSide(
                        color: Colors.black26,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      onPressed: (){
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DetailRuas(
                              ruas: "${filterSearch[index]['id_ruas']}",
                              nama_ruas: "${filterSearch[index]['NamaRuas']}",
                              id_region: "${filterSearch[index]['id_region']}",
                              url_region: "${widget.url}",
                              frompage: "overview",
                            ),
                          ),
                        );
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 4,
                                child: Container(
                                  padding: EdgeInsets.only(right: 10, top: 10, bottom: 10),
                                  alignment: Alignment.centerLeft,
                                  child: Text("${filterSearch[index]['NamaRuas']}", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black54),),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Container(
                                  child: Text("${filterSearch[index]['panjang']} Km", style: TextStyle(fontWeight: FontWeight.bold, fontStyle: FontStyle.italic, color: Colors.red[400]),),
                                ),
                              )
                            ],
                          ),
                          Container(
                            padding: EdgeInsets.only(left: 20),
                            alignment: Alignment.centerLeft,
                            child: Text("${regionGet}", style: TextStyle(fontSize: 11, color: Colors.black45),),
                          ),
                          Padding(padding: EdgeInsets.only(bottom: 10),),
                        ],
                      ),
                    ),
                  )
                  ;
                },
              ) : Center(
                child: CircularProgressIndicator(),
              ),
            ),
          )
        ],
      ),
    );
  }
}