import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:kconst/beranda.dart';
import 'package:kconst/berandapmi.dart';
import 'package:kconst/fragment/account.dart';
import 'package:kconst/fragment/dashboard.dart';
import 'package:kconst/fragment/laporan_pmi.dart';
import 'package:kconst/icons/beranda_icons.dart';
import 'package:kconst/icons/beranda_icons_admin.dart';
import 'package:kconst/icons/login_icons.dart';
import 'package:kconst/login.dart';
import 'package:kconst/news.dart';
import 'package:kconst/utils/check_session.dart';
import 'package:kconst/utils/check_session_icons.dart';
import 'package:kconst/viewlaporan.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var status = prefs.getString('status');
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'K-Const',
    home: NewsPage(),
    // home: status == null ? Login() : status == "2" ? Beranda() : Berandapmi(),
    routes: <String,WidgetBuilder>{
      '/fragment/Dashboard': (BuildContext context)=>new Dashboard(),
      '/fragment/Laporanpmi': (BuildContext context)=>new Laporanpmi(),
      '/fragment/Account': (BuildContext context)=>new Account(),
      '/Login': (BuildContext context)=>new Login(),
      '/Beranda': (BuildContext context)=>new Beranda(),
      '/Berandapmi': (BuildContext context)=>new Berandapmi(),
      '/ViewLaporan': (BuildContext context)=>new ViewLaporanPage(),
      '/utils/CheckSession': (BuildContext context)=>new CheckSession(),
      '/icons/BerandaIcons': (BuildContext context)=>new BerandaIcons(),
      '/icons/BerandaIconsAdmin': (BuildContext context)=>new BerandaIconsAdmin(),
      '/icons/LoginIcons': (BuildContext context)=>new LoginIcons(),
      '/utils/CheckSessionIcons': (BuildContext context)=>new CheckSessionIcons(),
    },
  ));
}
