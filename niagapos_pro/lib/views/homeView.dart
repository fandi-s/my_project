import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/material.dart';
import 'package:niagapos_pro/utils/MyClipper.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeView extends StatefulWidget{
  @override
  _HomeViewState createState() => _HomeViewState();
}


class _HomeViewState extends State<HomeView> {

  SharedPreferences prefs;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPreferenches();
  }

  getPreferenches() async {
    prefs = await SharedPreferences.getInstance();
    prefs.getString('username');
    setState(() {
      prefs.getString('username');

    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Container(
        child: Column(
          children: [
            ClipPath(
              clipper: MyClipper(),
              child: Container(
                width: double.infinity,
                height: 350,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('assets/bgr.png'),
                        fit: BoxFit.cover
                    )
                ),
                child: Container(
                  child: Stack(
                    children: [
                      Carousel(
                        autoplay: true,
                        autoplayDuration: Duration(milliseconds: 5000),
                        dotSize: 5.0,
                        dotIncreasedColor: Colors.white54,
                        dotBgColor: Colors.transparent,
                        dotPosition: DotPosition.bottomLeft,
                        dotVerticalPadding: 50.0,
                        dotHorizontalPadding: 30.0,
                        dotSpacing: 10.0,
                        showIndicator: true,
                        indicatorBgPadding: 7.0,
                        borderRadius: true,
                        images: [
                          Image.asset(
                            'assets/carousel/car4.jpg',
                            fit: BoxFit.cover,
                          ),
                          Image.asset(
                            'assets/carousel/car2.jpg',
                            fit: BoxFit.cover,
                          ),
                          Image.asset(
                            'assets/carousel/car3.jpg',
                            fit: BoxFit.cover,
                          ),
                        ],
                      ),
                      Container(
                        padding: EdgeInsets.only(bottom: 60, left: 80, right: 20),
                        alignment: Alignment.bottomLeft,
                        child: FlatButton(
                            onPressed: (){},
                            color: Colors.black26,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                              side: BorderSide(color: Colors.greenAccent, width: 0.5),
                            ),
                            child: Container(
                              padding: EdgeInsets.all(10),
                              child: Text("Promo dari ${prefs.getString('username')} yang akan muncul", style: TextStyle(color: Colors.white),),
                            )
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(padding: EdgeInsets.only(top: 20)),
            Container(
              padding: EdgeInsets.only(left: 30),
              alignment: Alignment.centerLeft,
              child: Text("Point pelanggan", style: TextStyle(color: Colors.black45, fontWeight: FontWeight.bold),),
            ),
            Padding(padding: EdgeInsets.only(top: 8)),
            Container(
              padding: EdgeInsets.only(left: 20, right: 20),
              height: 150,
              child: RaisedButton(
                onPressed: (){},
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: BorderSide(color: Colors.greenAccent, width: 0.5),
                ),
                elevation: 0,
                color: Colors.white,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: EdgeInsets.only(bottom: 0, right: 20),
                      alignment: Alignment.bottomRight,
                      child: FlatButton(
                          onPressed: (){
                            prefs.clear();
                            Navigator.pushReplacementNamed(context, '/halaman/LoginView');
                          },
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side: BorderSide(color: Colors.greenAccent, width: 0.5),
                          ),
                          child: Container(
                            width: 100,
                            padding: EdgeInsets.all(10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('Logout', style: TextStyle(color: Colors.redAccent),),
                                Padding(padding: EdgeInsets.only(left: 10),),
                                Image.asset('assets/iconmenu/penjual/logout.png',width: 20,)
                              ],
                            ),
                          )
                      ),
                    ),
                    Container(
                      child: Row(
                        children: [
                          Expanded(
                              flex: 2,
                              child: Container(
                                alignment: Alignment.center,
                                child: Image.asset('assets/iconmenu/point.png', width: 65,),
                              )
                          ),
                          Expanded(child: Container(
                            alignment: Alignment.centerRight,
                            padding: EdgeInsets.only(right: 10),
                            child: Text("1304", style: TextStyle(fontSize: 30, color: Colors.greenAccent),),
                          )),
                          Expanded(child: Container(
                            child: Text("Point", style: TextStyle(fontSize: 12, color: Colors.black45),),
                          )),
                        ],
                      ),
                    ),
                    Padding(padding: EdgeInsets.only(bottom: 10))
                  ],
                ),
              ),
            ),
            Padding(padding: EdgeInsets.only(top: 20)),
            Container(
              height: 200,
              child: Row(
                children: [
                  Padding(padding: EdgeInsets.only(left: 20)),
                  Expanded(
                      flex: 1,
                      child: Container(
                        child: RaisedButton(
                          onPressed: (){
                            Navigator.pushNamed(context, '/halaman/customer/TransaksiView');
                          },
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                            side: BorderSide(color: Colors.greenAccent, width: 0.5),
                          ),
                          color: Colors.white,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset('assets/iconmenu/transaksi.png', width: 100,),
                              Padding(padding: EdgeInsets.only(top: 20)),
                              Text('Transaksi', style: TextStyle(fontSize: 17, color: Colors.greenAccent),)
                            ],
                          ),
                        ),
                      )
                  ),
                  Padding(padding: EdgeInsets.only(left: 10, right: 10)),
                  Expanded(
                      flex: 1,
                      child: Container(
                        child: RaisedButton(
                          onPressed: (){
                            Navigator.pushNamed(context, '/halaman/customer/OrderView');
                          },
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                            side: BorderSide(color: Colors.greenAccent, width: 0.5),
                          ),
                          color: Colors.white,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset('assets/iconmenu/order.png', width: 100,),
                              Padding(padding: EdgeInsets.only(top: 20)),
                              Text('Order', style: TextStyle(fontSize: 17, color: Colors.greenAccent),)
                            ],
                          ),
                        ),
                      )
                  ),
                  Padding(padding: EdgeInsets.only(right: 20))
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// class MyClipper extends CustomClipper<Path> {
//   @override
//   Path getClip(Size size) {
//     var path = Path();
//
//     path.lineTo(0, size.height);
//     path.lineTo(size.width, size.height -50);
//     path.lineTo(size.width, 0);
//     path.close();
//
//     return path;
//   }
//
//   @override
//   bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
//     // TODO: implement shouldReclip
//     return null;
//   }
//
// }