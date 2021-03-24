import 'package:flutter/material.dart';
import 'package:niagapos_pro/views/customer/customerCartView.dart';
import 'package:niagapos_pro/views/customer/customerOrderView.dart';
import 'package:niagapos_pro/views/customer/customerTransaksiView.dart';
import 'package:niagapos_pro/views/homePenjualView.dart';
import 'package:niagapos_pro/views/homeView.dart';
import 'package:niagapos_pro/views/loginView.dart';
import 'package:niagapos_pro/views/splashView.dart';
import 'package:niagapos_pro/views/toko/transaksiTokoView.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'views/halamanUtama.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    title: "Niaga POS",
    // home: prefs.getString('isLogin')=="yes"
    //     ? HomeView()
    //     : LoginView(),
    home: SplashView(),
    routes: <String,WidgetBuilder>{
      '/halaman/HomeView':(BuildContext context)=>HomeView(),
      '/halaman/LoginView':(BuildContext context)=>LoginView(),
      '/halaman/HomePenjualView':(BuildContext context)=>HomePenjualView(),
      '/halaman/customer/OrderView':(BuildContext context)=>CustomerOrderView(),
      '/halaman/customer/TransaksiView':(BuildContext context)=>CustomerTransaksiView(),
      '/halaman/customer/CartView':(BuildContext context)=>CustomerCartView(),
    //  ROUTING PENJUAL/TOKO
      '/toko/TransaksiView':(BuildContext context)=>TransaksiTokoView()
    },
  ));
}

