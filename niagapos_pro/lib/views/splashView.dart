import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/animation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashView extends StatefulWidget{
  @override
  _SplashViewState createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> with TickerProviderStateMixin{

  AnimationController _controller;
  Animation<double> _animation;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = AnimationController(
        duration: const Duration(seconds: 5), vsync: this, value: 0.1);
    _animation = CurvedAnimation(parent: _controller, curve: Curves.bounceInOut);

    _controller.forward();
    Timer(
      Duration(seconds: 5),
        () => checkPrefenches()
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Container(
        child: Center(
          child: ScaleTransition(
            scale: _animation,
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/iconmenu/transaksi.png', width: 150,),
              ],
            ),
          ),
        ),
      ),
    );
  }

  checkPrefenches() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if(prefs.getString('isLogin') == 'yes' && prefs.getString('user') == 'false'){
    //  UNTUK PEMBELI dengan parameter FALSE
      Navigator.pushReplacementNamed(context, '/halaman/HomeView');
    }else if(prefs.getString('isLogin') == 'yes' && prefs.getString('user') == 'true'){
    //  UNTUK PENJUAL dengan parameter TRUE
      Navigator.pushReplacementNamed(context, '/halaman/HomePenjualView');
    }else{
      Navigator.pushReplacementNamed(context, '/halaman/LoginView');
    }

  }
}