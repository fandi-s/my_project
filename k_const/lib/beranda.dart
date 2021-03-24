import 'package:flutter/material.dart';
import 'package:kconst/fragment/account.dart';
import 'package:kconst/fragment/dashboard.dart';
import 'package:kconst/fragment/dashboardpmi.dart';
import 'package:kconst/fragment/lap_pmi.dart';
import 'package:kconst/fragment/laporan_pmi.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:kconst/fragment/post.dart';
import 'package:shared_preferences/shared_preferences.dart';

String username;
String status;

const String page1 = "Page 1";
const String page2 = "Page 2";
const String page3 = "Page 3";

class Beranda extends StatefulWidget{
  @override
  BerandaState createState() => BerandaState();
}

class BerandaState extends State<Beranda> with SingleTickerProviderStateMixin {

  List<Widget> _pages;
  Widget _page1;
  Widget _page2;
  Widget _page3;
  Widget _page4;

  int _page;
  GlobalKey _bottomNavigationKey = GlobalKey();
  Widget _currentPage;

  void initState(){
    super.initState();
    _loadPreferenches();
//    ADMIN
      _page1 = Dashboard();
      _page2 = Lappmi();
      _page3 = Account();
      _pages = [_page1, _page2, _page3];
      _page = 0;
      _currentPage = _page1;

  }

  _loadPreferenches() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      username = prefs.getString('username');
    });
  }

  @override
  Widget build(BuildContext context) {

    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Center(child: Image.asset("assets/images/logo_bpjt.png", width: 180.0,),),
      ),
      bottomNavigationBar: CurvedNavigationBar(
        key: _bottomNavigationKey,
        index: 0,
        height: 50.0,
        items: <Widget>[
          Icon(Icons.local_laundry_service, size: 30, color: Colors.white,),
          Icon(Icons.archive, size: 30, color: Colors.white,),
          Icon(Icons.account_box, size: 30, color: Colors.white,),
        ],
        color: Colors.blueAccent,
        buttonBackgroundColor: Colors.blueAccent,
        backgroundColor: Colors.white,
        animationCurve: Curves.easeInOut,
        animationDuration: Duration(milliseconds: 300),
        onTap: (index){
          setState(() {
            _page = index;
            _currentPage = _pages[index];
          });
        },
      ),
      body: _currentPage,
    );
  }
}