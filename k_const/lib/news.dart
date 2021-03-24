
import 'dart:math';

import 'package:carousel_pro/carousel_pro.dart';
import 'package:charts_common/src/chart/common/behavior/legend/legend.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:kconst/beranda.dart';
import 'package:kconst/berandapmi.dart';
import 'package:kconst/detailnews.dart';
import 'package:kconst/detailoverview.dart';
import 'package:kconst/detailrealisasioperasi.dart';
import 'dart:convert';

import 'package:kconst/login.dart';
import 'package:kconst/utils/check_session.dart';
import 'package:kconst/utils/check_session_icons.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'icons/kategori/detail_kategori.dart';

import 'package:charts_flutter/flutter.dart' as charts;
import 'package:charts_flutter/src/text_element.dart';
import 'package:charts_flutter/src/text_style.dart' as style;

class NewsPage extends StatefulWidget{
  @override
  NewsState createState() => NewsState();
}

class NewsState extends State<NewsPage> {

  String tahunGrafik = "1978-2020";
  bool showChoice = false;
  bool show1978_2020 = false;
  bool show1978_1989 = false;
  bool show1999_2014 = false;
  bool show2015_2020 = false;

  var color2020 = Colors.black12;
  var color2019 = Colors.black12;
  var color1978 = Colors.black12;

  void loadPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var status = prefs.getString('status');
    status == null
        ? Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Login()),
        )
        : status == "2"
        ? Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Beranda()),
        )
        : Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Berandapmi()),
        );
  }

  List news = [];
  List filterNews = [];
  bool isSearching = false;

  getNews() async {
    final f = new DateFormat('dd-MM-yyyy');
    var now = new DateTime.now();
    var from = f.format(now.subtract(new Duration(days: 10)));
    print("ANJENG ${from}");

    var url = "http://newsapi.org/v2/everything?q=jasamarga&from=${from}&sortBy=publishedAt&apiKey=aaf8e4292e484afc9e58085f47cd3d82";
    // var url = "http://newsapi.org/v2/everything?q=jasamarga&from=20-11-2020&sortBy=publishedAt&apiKey=aaf8e4292e484afc9e58085f47cd3d82";

    final response = await http.get(url);
    return json.decode(response.body)['articles'];
  }

  List headerNews = [];
  List filterHeader = [];

  List _carousel = [];
  getCarousel() async {
    var fo = new DateFormat('MMM');
    var nows = new DateTime.now();
    var url = "http://fds-management.com/carousel.json";
    final response = await http.get(url);
    return json.decode(response.body)['${fo.format(nows)}'];
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getNews().then((data){
      setState(() {
        news = filterNews = data;
      });
    });

    // getHeaderNews().then((data){
    //   setState(() {
    //     headerNews = filterHeader = data;
    //   });
    // });

    getCarousel().then((data){
      setState(() {
        _carousel = data;
      });
    });
  }

  void _filterNews(value){
    setState(() {
      filterNews = news
          .where((news)=>
          news['title'].toLowerCase().contains(value.toLowerCase()))
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
        leading: Container(
          child: Center(
            child: GestureDetector(
              onTap: (){
                showDialogChoice();
              },
              child: Image.asset('assets/iconk3/signin.png', scale: 2, color: Colors.blueGrey,),
            ),
          ),
        ),
        title: !isSearching
            ? Center(child: Image.asset('assets/images/logo_bpjt.png', scale: 4,),)
            : TextField(
          onChanged: (value){
            _filterNews(value);
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
                filterNews = news;
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
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            // Padding(padding: EdgeInsets.only(top: 10.0),),
            Container(
                height: 220.0,
                child: _carousel.length > 0 ?
                    ListView.builder(
                      itemCount: _carousel.length,
                      itemBuilder: (BuildContext context, int index){
                        return SizedBox(
                          height: 220.0,
                          child: Carousel(
                            boxFit: BoxFit.cover,
                            autoplay: true,
                            autoplayDuration: Duration(milliseconds: 5000),
                            dotSize: 5.0,
                            dotIncreasedColor: Colors.black54,
                            dotBgColor: Colors.transparent,
                            dotPosition: DotPosition.bottomLeft,
                            dotVerticalPadding: 10.0,
                            dotHorizontalPadding: 5.0,
                            dotSpacing: 10.0,
                            showIndicator: true,
                            indicatorBgPadding: 7.0,
                            images: [
                              Image.asset('assets/carousel/${_carousel[index]['img1']}'),
                              Image.asset('assets/carousel/${_carousel[index]['img2']}'),
                              Image.asset('assets/carousel/${_carousel[index]['img3']}'),
                            ],
                          ),
                        );
                      },
                    ) : SizedBox(
                  height: 220.0,
                  child: Carousel(
                    boxFit: BoxFit.cover,
                    autoplay: true,
                    autoplayDuration: Duration(milliseconds: 5000),
                    dotSize: 5.0,
                    dotIncreasedColor: Colors.black54,
                    dotBgColor: Colors.transparent,
                    dotPosition: DotPosition.bottomLeft,
                    dotVerticalPadding: 10.0,
                    dotHorizontalPadding: 5.0,
                    dotSpacing: 10.0,
                    showIndicator: true,
                    indicatorBgPadding: 7.0,
                    images: [
                      Image.asset('assets/carousel/carousatu.png'),
                      Image.asset('assets/carousel/caroudua.png'),
                      Image.asset('assets/carousel/caroutiga.png'),
                      Image.asset('assets/carousel/carouempat.png'),
                    ],
                  ),
                )
            ),
            Padding(padding: EdgeInsets.only(top: 10)),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 50,
                  child: FlatButton(
                    onPressed: (){
                      Navigator.push(context, MaterialPageRoute(
                          builder: (context) => DetailNewsPage(
                            url: "https://www.facebook.com/BPJTInfo/?hc_ref=ARQHRGWesvjPuWkg_ohcDwA6jYW9qLIi_lu50rpdxt7msufvM1U1OTMOseyqpSTZyq4&fref=nf&__tn__=kC-R",
                          )
                      ));
                    },
                    child: Image.asset('assets/icon/facebook.png', width: 20, color: Colors.blue[800],),
                  ),
                ),
                Container(
                  width: 50,
                  child: FlatButton(
                    onPressed: (){
                      Navigator.push(context, MaterialPageRoute(
                          builder: (context) => DetailNewsPage(
                            url: "https://twitter.com/bpjt_info",
                          )
                      ));
                    },
                    child: Image.asset('assets/icon/twitter.png', width: 20, color: Colors.blue[400]),
                  ),
                ),
                Container(
                  width: 50,
                  child: FlatButton(
                    onPressed: (){
                      Navigator.push(context, MaterialPageRoute(
                          builder: (context) => DetailNewsPage(
                            url: "https://www.instagram.com/bpjt_info/",
                          )
                      ));
                    },
                    child: Image.asset('assets/icon/instagram.png', width: 20, color: Colors.pink),
                  ),
                ),
                Container(
                  width: 55,
                  child: FlatButton(
                    onPressed: (){
                      Navigator.push(context, MaterialPageRoute(
                          builder: (context) => DetailNewsPage(
                            url: "https://www.youtube.com/channel/UCEMaY1KP0A0AWWCN8xr8GIA",
                          )
                      ));
                    },
                    child: Image.asset('assets/icon/youtube.png', width: 25, color: Colors.red[900]),
                  ),
                ),
              ],
            ),
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.only(left: 35.0, bottom: 20.0),
              child: Text("Overview", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.0),),
            ),
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(left: 36, top: 5),
                        child: Image.asset('assets/icon/konstruksi.png', width: 24, color: Colors.lightBlueAccent[400],),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 5, left: 10),
                        child: GestureDetector(
                          onTap: (){
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DetailOverviewPage(
                                  url: "http://i_cons.bpjt.pu.go.id/api/list_dataRuas/1",
                                  nama: "Konstruksi",
                                ),
                              ),
                            );
                          },
                          child: Text("Jalan Tol Konstruksi 26 ruas 846 Km", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue[900], fontSize: 11)),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(left: 36, top: 5),
                        child: Image.asset('assets/icon/persiapan.png', width: 24, color: Colors.lightBlueAccent[400],),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 5, left: 10),
                        child: GestureDetector(
                          onTap: (){
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DetailOverviewPage(
                                  url: "http://i_cons.bpjt.pu.go.id/api/list_dataRuas/2",
                                  nama: "Persiapan",
                                ),
                              ),
                            );
                          },
                          child: Text("Jalan Tol Persiapan (Telah PPJT) 22 ruas 1.096 Km", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue[900], fontSize: 11)),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(left: 36, top: 5),
                        child: Image.asset('assets/icon/operasi.png', width: 24, color: Colors.lightBlueAccent[400],),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 5, left: 10),
                        child: GestureDetector(
                          onTap: (){
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DetailOverviewPage(
                                  url: "http://i_cons.bpjt.pu.go.id/api/list_dataRuas/3",
                                  nama: "Operasi",
                                ),
                              ),
                            );
                          },
                          child: Text("Jalan Tol Operasi 58 ruas 2.304 Km", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue[900], fontSize: 11)),
                        ),
                      ),
                    ],
                  ),
                  Padding(padding: EdgeInsets.only(top: 15),),
                ],
              ),
            ),
            Padding(padding: EdgeInsets.only(top: 10),),
            Container(
              padding: EdgeInsets.only(left: 20, right: 20),
              child: Card(
                child: Column(
                  children: <Widget>[
                    Padding(padding: EdgeInsets.only(top: 10),),
                    Row(
                      children: <Widget>[
                        Padding(padding: EdgeInsets.only(left: 20),),
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
                          child: Icon(Icons.menu, size: 20,),
                        ),
                        Padding(padding: EdgeInsets.only(left: 10),),
                        Text("Realisasi Panjang Pengoperasian Jalan Tol ${tahunGrafik}", style: TextStyle(fontSize: 11),),
                      ],
                    ),
                    !showChoice
                        ? Container()
                        : Container(
                          padding: EdgeInsets.only(top: 10),
                          height: 35,
                          child: Row(
                            children: <Widget>[
                              Padding(padding: EdgeInsets.only(left: 20),),
                              Expanded(
                                child: OutlineButton(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  borderSide: BorderSide(
                                      color: color1978
                                  ),
                                  onPressed: (){
                                    if(show1978_2020==false){
                                      setState(() {
                                        tahunGrafik = "1978 - 2020";
                                        show1978_2020 = true;
                                        show1978_1989 = false;
                                        show1999_2014 = false;
                                        show2015_2020 = false;
                                        color1978 = Colors.lightBlue;
                                        color2019 = Colors.black12;
                                        color2020 = Colors.black12;
                                      });
                                    }
                                  },
                                  child: Text("1978 - 2020", style: TextStyle(fontSize: 8),),
                                ),
                              ),
                              Padding(padding: EdgeInsets.only(right: 4),),
                              Expanded(
                                child: OutlineButton(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  borderSide: BorderSide(
                                    color: color2019
                                  ),
                                  onPressed: (){
                                    if(show1978_1989==false){
                                      setState(() {
                                        tahunGrafik = "2015 - 2019";
                                        show1978_1989 = true;
                                        show1978_2020 = false;
                                        show1999_2014 = false;
                                        show2015_2020 = false;
                                        color1978 = Colors.black12;
                                        color2019 = Colors.lightBlue;
                                        color2020 = Colors.black12;
                                      });
                                    }
                                  },
                                  child: Text("2015-2019", style: TextStyle(fontSize: 8),),
                                ),
                              ),
                              Padding(padding: EdgeInsets.only(left: 4),),
                              Expanded(
                                child: OutlineButton(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8.0),
                                      side: BorderSide(color: Colors.red)
                                  ),
                                  borderSide: BorderSide(
                                    color: color2020
                                  ),
                                  onPressed: (){
                                    if(show2015_2020==false){
                                      setState(() {
                                        tahunGrafik = "2015 - 2020";
                                        show2015_2020 = true;
                                        show1978_2020 = false;
                                        show1978_1989 = false;
                                        show1999_2014 = false;
                                        color1978 = Colors.black12;
                                        color2019 = Colors.black12;
                                        color2020 = Colors.lightBlue;
                                      });
                                    }
                                  },
                                  child: Text("2015 - 2020", style: TextStyle(fontSize: 8),),
                                ),
                              ),
                              Padding(padding: EdgeInsets.only(right: 20),),
                            ],
                          ),
                        ),
                    Container(
                      padding: EdgeInsets.only(left: 20, right: 20),
                      height: 320,
                      child: Padding(
                          padding: EdgeInsets.only(top: 10, bottom: 10),
                          child: Column(
                            children: <Widget>[
                                  show1978_1989 == true
                                  ? Container(
                                    height: 290,
                                    child: OrdinalComboBarLineChartAll89.withSampleData(),
                                  )
                                  : show2015_2020 == true
                                  ? Container(
                                    height: 290,
                                    child: OrdinalComboBarLineChartAll20.withSampleData(),
                                  )
                                  : show1978_2020 == true
                                  ? Container(
                                    height: 290,
                                    child: OrdinalComboBarLineChartAll.withSampleData(),
                                  )
                                  : Container(
                                    height: 290,
                                    child: OrdinalComboBarLineChartAll.withSampleData(),
                                  ),
                              // Container(
                              //   height: 100,
                              //   child: Column(
                              //     children: <Widget>[
                              //       Padding(padding: EdgeInsets.only(top: 10),),
                              //       Row(
                              //         children: <Widget>[
                              //           Padding(padding: EdgeInsets.only(left: 30),),
                              //           Container(
                              //             height: 20,
                              //             width: 20,
                              //             color: Colors.blue,
                              //           ),
                              //           Expanded(
                              //               flex: 1,
                              //               child: Padding(
                              //                 padding: EdgeInsets.only(left: 10),
                              //                 child: Text("Pertambahan per Tahun (Km)", style: TextStyle(fontSize: 10),),
                              //               )
                              //           )
                              //         ],
                              //       ),
                              //       Padding(padding: EdgeInsets.only(top: 10),),
                              //       Row(
                              //         children: <Widget>[
                              //           Padding(padding: EdgeInsets.only(left: 30),),
                              //           Container(
                              //             height: 2,
                              //             width: 20,
                              //             color: Colors.red,
                              //           ),
                              //           Expanded(
                              //               flex: 5,
                              //               child: Padding(
                              //                 padding: EdgeInsets.only(left: 10),
                              //                 child: Text("Akumulasi Realisasi panjang Operasi (Km)", style: TextStyle(fontSize: 10),),
                              //               )
                              //           )
                              //         ],
                              //       )
                              //     ],
                              //   ),
                              // )
                            ],
                          )
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.only(left: 35.0, top: 30.0, bottom: 20.0),
              child: Text("Pilih Region", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.0),),
            ),
            Container(
              padding: EdgeInsets.only(left: 20.0, right: 20.0),
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
                      borderSide: BorderSide(color: Colors.transparent),
                      child: Stack(
                        children: <Widget>[
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Container(
                              width: 46,
                              height: 46,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                  image: AssetImage('assets/icon/transjawa.jpg'),
                                  fit: BoxFit.fill
                                )
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: EdgeInsets.only(left: 50.0, top: 17),
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
                      borderSide: BorderSide(color: Colors.transparent),
                      child: Stack(
                        children: <Widget>[
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Container(
                              width: 46,
                              height: 46,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                      image: AssetImage('assets/icon/nontransjawa.jpg'),
                                      fit: BoxFit.fill
                                  )
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: EdgeInsets.only(left: 50.0, top: 17),
                              child: Text("Non Trans", style: TextStyle(fontSize: 13),),
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
            Padding(padding: EdgeInsets.only(top: 10),),
            Container(
              padding: EdgeInsets.only(left: 20.0, right: 20.0),
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
                      borderSide: BorderSide(color: Colors.transparent),
                      child: Stack(
                        children: <Widget>[
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Container(
                              width: 46,
                              height: 46,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                      image: AssetImage('assets/icon/jabodetabek.jpg'),
                                      fit: BoxFit.fill
                                  )
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: EdgeInsets.only(left: 50.0, top: 17),
                              child: Text("Jabodetabek", style: TextStyle(fontSize: 13)),
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
                      borderSide: BorderSide(color: Colors.transparent),
                      child: Stack(
                        children: <Widget>[
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Container(
                              width: 46,
                              height: 46,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                      image: AssetImage('assets/icon/transsumatera.jpg'),
                                      fit: BoxFit.fill
                                  )
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: EdgeInsets.only(left: 50, top: 17),
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
            Padding(padding: EdgeInsets.only(top: 25),),
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.only(left: 35.0, bottom: 10.0),
              child: Text("News", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.0),),
            ),
            Container(
              height: 500,
              child: Container(
                child: filterNews != null
                    ? ListView.builder(
                  shrinkWrap: true,
                  itemCount: filterNews.length,
                  itemBuilder: (BuildContext context, int index){
                    return GestureDetector(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(
                          builder: (context) => DetailNewsPage(
                            url: filterNews[index]['url'],
                          )
                        ));
                      },
                      child: Container(
                        padding: EdgeInsets.all(20.0),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              flex: 2,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10.0),
                                child: Image.network(filterNews[index]['urlToImage']),
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: Container(
                                padding: EdgeInsets.only(left: 20.0),
                                child: Column(
                                  children: <Widget>[
                                    Container(
                                      alignment: Alignment.topLeft,
                                      child: Text(filterNews[index]['title'], style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),),
                                    ),
                                    Container(
                                      alignment: Alignment.topLeft,
                                      child: ambilTanggal(filterNews[index]['source']['name'], filterNews[index]['publishedAt']),
                                    ),
                                    Padding(padding: EdgeInsets.only(top: 5),),
                                    Container(
                                      alignment: Alignment.topLeft,
                                      child: Text(filterNews[index]['description'], style: TextStyle(fontSize: 11),),
                                    ),


                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  },
                )
                    : filterNews == null
                    ? Container(
                  child: Center(
                    child: Text("Data tidak ada!"),
                  ),
                ) : Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  ambilTanggal(sumber, tanggal) {
    var string = tanggal;
    List<String> strings = string.split("-");
    var strtgl = strings[2];
    List<String> ambil = strtgl.split("T");
    var strBulan = "";
    if(strings[1] == 01){
      strBulan = "Jan";
    }else if(strings[1] == "02"){
      strBulan = "Feb";
    }else if(strings[1] == "03"){
      strBulan = "Mar";
    }else if(strings[1] == "04"){
      strBulan = "Apr";
    }else if(strings[1] == "05"){
      strBulan = "Mei";
    }else if(strings[1] == "06"){
      strBulan = "Jun";
    }else if(strings[1] == "07"){
      strBulan = "Jul";
    }else if(strings[1] == "08"){
      strBulan = "Agu";
    }else if(strings[1] == "09"){
      strBulan = "Sep";
    }else if(strings[1] == "10"){
      strBulan = "Okt";
    }else if(strings[1] == "11"){
      strBulan = "Nov";
    }else if(strings[1] == "12"){
      strBulan = "Des";
    }

    return Text("${sumber} - ${ambil[0]} ${strBulan} ${strings[0]}", style: TextStyle(fontSize: 10, color: Colors.grey),);
  }

  void showDialogChoice() {
    showGeneralDialog(
      barrierLabel: "Barrier",
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: Duration(milliseconds: 400),
      context: context,
      pageBuilder: (_, __, ___) {
        return Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            height: 200,
            padding: EdgeInsets.only(top: 30, bottom: 30),
            margin: EdgeInsets.only(bottom: 50, left: 12, right: 12),
            decoration: BoxDecoration(
              color: Colors.black54,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: SizedBox.expand(
                      child: Center(
                        child: FlatButton(
                          onPressed: (){
                            Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => CheckSessionIcons())
                            );
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Image.asset('assets/images/noimage.png', color: Colors.white, width: 64,),
                              Text("I-cons", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),)
                            ],
                          ),
                        ),
                      )
                  ),
                ),
                Expanded(
                    child: SizedBox.expand(
                        child: Center(
                          child: FlatButton(
                            onPressed: (){
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => CheckSession())
                              );
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Image.asset('assets/images/noimage.png', color: Colors.white, width: 64,),
                                Text("K-cons", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white))
                              ],
                            ),
                          ),
                        )
                    )
                )
              ],
            ),
          ),
        );
      },
      transitionBuilder: (_, anim, __, child) {
        return SlideTransition(
          position: Tween(begin: Offset(0, 1), end: Offset(0, 0)).animate(anim),
          child: child,
        );
      },
    );
  }

}

class OrdinalComboBarLineChartAll extends StatefulWidget {
  final List<charts.Series> seriesList;
  final bool animate;

  OrdinalComboBarLineChartAll(this.seriesList, {this.animate});

  factory OrdinalComboBarLineChartAll.withSampleData() {
    return OrdinalComboBarLineChartAll(
      _createSampleData(),
      animate: false,
    );
  }

  @override
  State<StatefulWidget> createState() => _SelectedCallbackState();

  static List<charts.Series<OrdinalSales, String>> _createSampleData() {

    final desktopSalesData = [
      new OrdinalSales('1978 - 1998', 551),
      new OrdinalSales('1999 - 2014', 244),
      new OrdinalSales('2015 - 2020', 1298),
    ];

    final tableSalesData = [
      new OrdinalSales('1978 - 1998', 551),
      new OrdinalSales('1999 - 2014', 795),
      new OrdinalSales('2015 - 2020', 2093),
    ];

    return [
      charts.Series<OrdinalSales, String>(
          id: 'Pertambahan per tahun (Km)',
          colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
          domainFn: (OrdinalSales sales, _) => sales.year,
          measureFn: (OrdinalSales sales, _) => sales.sales,
          labelAccessorFn: (OrdinalSales sales,_)=>'${sales.sales}',
          data: desktopSalesData),
      charts.Series<OrdinalSales, String>(
          id: 'Akumulasi Realisasi Panjang Operasi (Km)',
          colorFn: (_, __) => charts.MaterialPalette.red.shadeDefault,
          domainFn: (OrdinalSales sales, _) => sales.year,
          measureFn: (OrdinalSales sales, _) => sales.sales,
          labelAccessorFn: (OrdinalSales sales,_)=>'${sales.sales}',
          data: tableSalesData)
      // Configure our custom line renderer for this series.
        ..setAttribute(
            charts.rendererIdKey, 'customLine'
        ),
    ];
  }

}

class _SelectedCallbackState extends State<OrdinalComboBarLineChartAll> {

  String valueBiru = "";
  String valueMerah = "";
  String valueTahun = "";
  static String pointerValue;

  @override
  Widget build(BuildContext context) {

    _onSelectionChanged(charts.SelectionModel model) {
      final selectedDatum = model.selectedDatum;

      if(selectedDatum.isNotEmpty){
        // print("${selectedDatum.first.datum.year} - ${selectedDatum.first.datum.sales} - ${selectedDatum.last.datum.sales}");
        setState(() {
          valueBiru = "${selectedDatum.first.datum.sales} Km ";
          valueMerah = "${selectedDatum.last.datum.sales} Km ";
          valueTahun = "${selectedDatum.first.datum.year}";
        });

      }
    }

    // TODO: implement build
    return Container(
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.only(top: 10, bottom: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                    child: Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: Text("${valueTahun}", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey),),
                    )
                ),
                Container(
                    child: Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: Text("${valueBiru}", style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.blue),),
                    )
                ),
                Container(
                    child: Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: Text("${valueMerah}", style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.red),),
                    )
                ),
              ],
            ),
          ),
          Container(
            height: 240,
            child: charts.OrdinalComboChart(widget.seriesList,
                animate: widget.animate,
                defaultRenderer: new charts.BarRendererConfig(
                    groupingType: charts.BarGroupingType.stacked,
                    barRendererDecorator: new charts.BarLabelDecorator<String>(
                        insideLabelStyleSpec: new charts.TextStyleSpec(fontSize: 7, color: charts.Color.white),
                        outsideLabelStyleSpec: new charts.TextStyleSpec(fontSize: 7, color: charts.Color.black),
                        labelPosition: charts.BarLabelPosition.outside,
                    ),
                    cornerStrategy: const charts.ConstCornerStrategy(30),
                ),
                selectionModels: [
                  charts.SelectionModelConfig(
                    changedListener: _onSelectionChanged
                  )
                ],
                primaryMeasureAxis: charts.NumericAxisSpec(
                  renderSpec: charts.NoneRenderSpec(),
                ),
                domainAxis: charts.OrdinalAxisSpec(
                    renderSpec: charts.SmallTickRendererSpec(
                      labelRotation: 45,
                      labelStyle: charts.TextStyleSpec(
                        fontSize: 9,
                        color: charts.MaterialPalette.black,
                      ),
                    )
                ),
                behaviors: [
                  charts.SeriesLegend(
                    desiredMaxColumns: 1,
                    entryTextStyle: charts.TextStyleSpec(
                      color: charts.Color(r: 149, g: 149, b: 149),
                      fontSize: 10
                    )
                  ),
                ],
                customSeriesRenderers: [
                  new charts.LineRendererConfig(
                    customRendererId: 'customLine',
                    includePoints: true,
                    radiusPx: 3,
                  ),
                ]),
          )
        ],
      ),
    );
  }
}

class OrdinalComboBarLineChartAll89 extends StatefulWidget {
  final List<charts.Series> seriesList;
  final bool animate;

  OrdinalComboBarLineChartAll89(this.seriesList, {this.animate});

  factory OrdinalComboBarLineChartAll89.withSampleData() {
    return OrdinalComboBarLineChartAll89(
      _createSampleData(),
      animate: false,
    );
  }

  @override
  State<StatefulWidget> createState() => _SelectedCallbackState89();

  static List<charts.Series<OrdinalSales, String>> _createSampleData() {

    final desktopSalesData = [
      new OrdinalSales('2015', 132),
      new OrdinalSales('2016', 44),
      new OrdinalSales('2017', 156),
      new OrdinalSales('2018', 450),
      new OrdinalSales('2019', 516),
    ];

    final tableSalesData = [
      new OrdinalSales('2015', 132),
      new OrdinalSales('2016', 170),
      new OrdinalSales('2017', 300),
      new OrdinalSales('2018', 770),
      new OrdinalSales('2019', 1300),
    ];

    return [
      charts.Series<OrdinalSales, String>(
          id: 'Pertambahan per tahun (Km)',
          colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
          domainFn: (OrdinalSales sales, _) => sales.year,
          measureFn: (OrdinalSales sales, _) => sales.sales,
          labelAccessorFn: (OrdinalSales sales,_)=>'${sales.sales}',
          data: desktopSalesData),
      charts.Series<OrdinalSales, String>(
          id: 'Akumulasi Realisasi Panjang Operasi (Km)',
          colorFn: (_, __) => charts.MaterialPalette.red.shadeDefault,
          domainFn: (OrdinalSales sales, _) => sales.year,
          measureFn: (OrdinalSales sales, _) => sales.sales,
          labelAccessorFn: (OrdinalSales sales,_)=>'${sales.sales}',
          data: tableSalesData)
      // Configure our custom line renderer for this series.
        ..setAttribute(
            charts.rendererIdKey, 'customLine'
        ),
    ];
  }

}

class _SelectedCallbackState89 extends State<OrdinalComboBarLineChartAll89> {

  String valueBiru = "";
  String valueMerah = "";
  String valueTahun = "";

  @override
  Widget build(BuildContext context) {

    _onSelectionChanged(charts.SelectionModel model) {
      final selectedDatum = model.selectedDatum;

      if(selectedDatum.isNotEmpty){
        // print("${selectedDatum.first.datum.year} - ${selectedDatum.first.datum.sales} - ${selectedDatum.last.datum.sales}");
        setState(() {
          valueBiru = "${selectedDatum.first.datum.sales} Km";
          valueMerah = "${selectedDatum.last.datum.sales} Km";
          valueTahun = "${selectedDatum.first.datum.year}";
        });
      }
    }

    // TODO: implement build
    return Container(
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.only(top: 10, bottom: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                    child: Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: Text("${valueTahun}", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey),),
                    )
                ),
                Container(
                    child: Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: Text("${valueBiru}", style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.blue),),
                    )
                ),
                Container(
                    child: Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: Text("${valueMerah}", style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.red),),
                    )
                ),
              ],
            ),
          ),
          Container(
            height: 240,
            child: charts.OrdinalComboChart(widget.seriesList,
                animate: widget.animate,
                defaultRenderer: new charts.BarRendererConfig(
                  groupingType: charts.BarGroupingType.stacked,
                  barRendererDecorator: new charts.BarLabelDecorator<String>(
                    insideLabelStyleSpec: new charts.TextStyleSpec(fontSize: 7, color: charts.Color.white),
                    outsideLabelStyleSpec: new charts.TextStyleSpec(fontSize: 7, color: charts.Color.black),
                    labelPosition: charts.BarLabelPosition.outside,
                  ),
                  cornerStrategy: const charts.ConstCornerStrategy(30),
                ),
                selectionModels: [
                  charts.SelectionModelConfig(
                    type: charts.SelectionModelType.info,
                    changedListener: _onSelectionChanged,
                  )
                ],
                primaryMeasureAxis: charts.NumericAxisSpec(
                  renderSpec: charts.NoneRenderSpec(),
                ),
                domainAxis: charts.OrdinalAxisSpec(
                    renderSpec: charts.SmallTickRendererSpec(
                      labelRotation: 45,
                      labelStyle: charts.TextStyleSpec(
                        fontSize: 9,
                        color: charts.MaterialPalette.black,
                      ),
                    )
                ),
                behaviors: [
                  charts.SeriesLegend(
                      desiredMaxColumns: 1,
                      entryTextStyle: charts.TextStyleSpec(
                          color: charts.Color(r: 149, g: 149, b: 149),
                          fontSize: 10
                      )
                  ),
                ],
                customSeriesRenderers: [
                  new charts.LineRendererConfig(
                    customRendererId: 'customLine',
                    includePoints: true,
                    radiusPx: 3,
                  ),
                ]),
          )
        ],
      ),
    );;
  }
}

class OrdinalComboBarLineChartAll20 extends StatefulWidget {
  final List<charts.Series> seriesList;
  final bool animate;

  OrdinalComboBarLineChartAll20(this.seriesList, {this.animate});

  factory OrdinalComboBarLineChartAll20.withSampleData() {
    return OrdinalComboBarLineChartAll20(
      _createSampleData(),
      animate: false,
    );
  }

  @override
  State<StatefulWidget> createState() => _SelectedCallbackState20();

  static List<charts.Series<OrdinalSales, String>> _createSampleData() {

    final desktopSalesData = [
      new OrdinalSales('2015', 132),
      new OrdinalSales('2016', 44),
      new OrdinalSales('2017', 156),
      new OrdinalSales('2018', 450),
      new OrdinalSales('2019', 516),
      new OrdinalSales('2020', 210),
    ];

    final tableSalesData = [
      new OrdinalSales('2015', 132),
      new OrdinalSales('2016', 170),
      new OrdinalSales('2017', 300),
      new OrdinalSales('2018', 770),
      new OrdinalSales('2019', 1300),
      new OrdinalSales('2020', 1500),
    ];

    return [
      charts.Series<OrdinalSales, String>(
          id: 'Pertambahan per tahun (Km)',
          colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
          domainFn: (OrdinalSales sales, _) => sales.year,
          measureFn: (OrdinalSales sales, _) => sales.sales,
          labelAccessorFn: (OrdinalSales sales,_)=>'${sales.sales}',
          data: desktopSalesData),
      charts.Series<OrdinalSales, String>(
          id: 'Akumulasi Realisasi Panjang Operasi (Km)',
          colorFn: (_, __) => charts.MaterialPalette.red.shadeDefault,
          domainFn: (OrdinalSales sales, _) => sales.year,
          measureFn: (OrdinalSales sales, _) => sales.sales,
          labelAccessorFn: (OrdinalSales sales,_)=>'${sales.sales}',
          data: tableSalesData)
      // Configure our custom line renderer for this series.
        ..setAttribute(
            charts.rendererIdKey, 'customLine'
        ),
    ];
  }

}

class _SelectedCallbackState20 extends State<OrdinalComboBarLineChartAll20> {

  String valueBiru = "";
  String valueMerah = "";
  String valueTahun = "";

  @override
  Widget build(BuildContext context) {

    _onSelectionChanged(charts.SelectionModel model) {
      final selectedDatum = model.selectedDatum;

      if(selectedDatum.isNotEmpty){
        // print("${selectedDatum.first.datum.year} - ${selectedDatum.first.datum.sales} - ${selectedDatum.last.datum.sales}");
        setState(() {
          valueBiru = "${selectedDatum.first.datum.sales} Km";
          valueMerah = "${selectedDatum.last.datum.sales} Km";
          valueTahun = "${selectedDatum.first.datum.year}";
        });
      }
    }

    // TODO: implement build
    return Container(
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.only(top: 10, bottom: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                    child: Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: Text("${valueTahun}", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey),),
                    )
                ),
                Container(
                    child: Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: Text("${valueBiru}", style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.blue),),
                    )
                ),
                Container(
                    child: Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: Text("${valueMerah}", style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.red),),
                    )
                ),
              ],
            ),
          ),
          Container(
            height: 240,
            child: charts.OrdinalComboChart(widget.seriesList,
                animate: widget.animate,
                defaultRenderer: new charts.BarRendererConfig(
                  groupingType: charts.BarGroupingType.stacked,
                  barRendererDecorator: new charts.BarLabelDecorator<String>(
                    insideLabelStyleSpec: new charts.TextStyleSpec(fontSize: 7, color: charts.Color.white),
                    outsideLabelStyleSpec: new charts.TextStyleSpec(fontSize: 7, color: charts.Color.black),
                    labelPosition: charts.BarLabelPosition.outside,
                  ),
                  cornerStrategy: const charts.ConstCornerStrategy(30),
                ),
                selectionModels: [
                  charts.SelectionModelConfig(
                    type: charts.SelectionModelType.info,
                    changedListener: _onSelectionChanged,
                  )
                ],
                primaryMeasureAxis: charts.NumericAxisSpec(
                  renderSpec: charts.NoneRenderSpec(),
                ),
                domainAxis: charts.OrdinalAxisSpec(
                    renderSpec: charts.SmallTickRendererSpec(
                      labelRotation: 45,
                      labelStyle: charts.TextStyleSpec(
                        fontSize: 9,
                        color: charts.MaterialPalette.black,
                      ),
                    )
                ),
                behaviors: [
                  charts.SeriesLegend(
                      desiredMaxColumns: 1,
                      entryTextStyle: charts.TextStyleSpec(
                          color: charts.Color(r: 149, g: 149, b: 149),
                          fontSize: 10
                      )
                  ),
                ],
                customSeriesRenderers: [
                  new charts.LineRendererConfig(
                    customRendererId: 'customLine',
                    includePoints: true,
                    radiusPx: 3,
                  ),
                ]),
          )
        ],
      ),
    );;
  }
}

/// Sample ordinal data type.
class OrdinalSales {
  final String year;
  final int sales;

  OrdinalSales(this.year, this.sales);
}