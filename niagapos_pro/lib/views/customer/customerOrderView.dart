import 'dart:async';

import 'package:flutter/material.dart';
import 'package:niagapos_pro/models/badgeModel.dart';
import 'package:niagapos_pro/models/customerOrderModel.dart';
import 'package:niagapos_pro/models/keranjangModel.dart';
import 'package:niagapos_pro/services/badgeServices.dart';
import 'package:niagapos_pro/services/customerOrderService.dart';
import 'package:progress_dialog/progress_dialog.dart';

import 'package:niagapos_pro/services/keranjangService.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CustomerOrderView extends StatefulWidget {

  @override
  _CustomerOrderViewState createState() => _CustomerOrderViewState();
}

class _CustomerOrderViewState extends State<CustomerOrderView> with TickerProviderStateMixin {


  bool isSearching = false;
  int counter = 0;
  double imgWidth = 26;
  double badgeWidthHeigh = 14;
  double fontBadgeSize = 8;
  Color colorImg = Colors.white;
  Color colorBadge = Colors.red;
  Color themeColor = Color(0xff2bcfb1);

  SharedPreferences prefs;
  String prefsKodePembeli;
  String prefsNamaPembeli;
  String prefsKodeToko;

  List fil_barang = [];
  List<CustomerOrderModel> dataOrder = new List();
  void getDataOrder() {
    CustomerOrderService().getOrder().then((value) {
      print("Di View Order ${value}");
      setState(() {
        dataOrder = fil_barang = value;
      });
    });
  }

  List<BadgeModel> dataBadge = new List();
  void getBadge(){
    BadgeServices().totalQty().then((value){
      setState(() {
        dataBadge = value;
        print("Di View Badge ${dataBadge[0].totalQty}");
        if(dataBadge[0].totalQty == null){
          counter = 0;
          print("jika null maka : ${counter}");
        }else{
          counter = dataBadge[0].totalQty;
          print("jika not a null maka : ${counter}");
        }

      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDataOrder();
    getBadge();
    getPreferences();
  }

  void getPreferences() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      prefsKodePembeli = prefs.getString('password');
      prefsNamaPembeli = prefs.getString('username');
      prefsKodeToko    = prefs.getString('kode_toko');
      print("ANJENG ${prefsKodeToko}");
    });
  }

  List<KeranjangModel> dataKeranjang = List();
  void masukanKeranjang(
      String kodePembeli,
      String namaPembeli,
      String kodeToko,
      String kodeBarang,
      String barcodeBarang,
      String namaBarang,
      String satuan,
      String klpBarang,
      String hargaJual,
      String kodeSatuan,
      String hargaTotal
      ){
    KeranjangService().masukanBarang(
      kodePembeli,
      namaPembeli,
      kodeToko,
      kodeBarang,
      barcodeBarang,
      namaBarang,
      satuan,
      klpBarang,
      hargaJual,
      kodeSatuan,
      hargaTotal
    ).then((value){
      if(value == true){
        setState(() {
          counter++;
          imgWidth = 100;
          colorBadge==Colors.red ? colorBadge = Colors.orange : colorBadge = Colors.red;
          colorImg==Colors.white ? colorImg = Colors.black45 : colorImg = Colors.white;
          badgeWidthHeigh = 20;
          fontBadgeSize = 11;
        });
        print("Sukses Insert");
      }else{
        print("Gagal Boss");
      }

    });
  }

  Widget shopingCartBadge(){
    return Stack(
      children: <Widget>[
        FlatButton(
          onPressed: (){
            Navigator.pushReplacementNamed(context, '/halaman/customer/CartView');
          },
          child: IconButton(
            icon: AnimatedContainer(
              duration: Duration(seconds: 3),
              width: imgWidth,
              child: Image.asset('assets/cart.png', width: imgWidth, color: colorImg,),
            ),
            // onPressed: (){
            //   Navigator.pushReplacementNamed(context, '/halaman/customer/CartView');
            // },
          ),
        ),
        counter != 0 ? Positioned(
          right: 25,
          top: 11,
          child: Container(
            padding: EdgeInsets.all(2),
            decoration: BoxDecoration(
                color: colorBadge,
                borderRadius: BorderRadius.circular(6)
            ),
            constraints: BoxConstraints(
              minWidth: badgeWidthHeigh,
              minHeight: badgeWidthHeigh,
            ),
            child: Text(
              '${counter}',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: fontBadgeSize,
                  fontWeight: FontWeight.bold
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ) : Container()
      ],
    );
  }

  Future<void> _showDialogSuccess() async {
    return showDialog(
      barrierColor: Colors.transparent,
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context){
        Future.delayed(Duration(milliseconds: 200), (){
          Navigator.of(context).pop(true);
        });
        return AlertDialog(
          elevation: 0,
          backgroundColor: Colors.transparent,
          content: Container(
            child: Image.asset('assets/tocart.png', width: 50,),
          ),
        );
      }
    );
  }

  void _filBarang(value) {
    setState(() {
      fil_barang = dataOrder.where((ord) =>
        ord.namaBarang.toLowerCase().contains(value.toLowerCase()))
        .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Order", style: TextStyle(fontWeight: FontWeight.bold),),
        backgroundColor: themeColor,
        elevation: 0,
        actions: [
          shopingCartBadge()
        ],
      ),
      body: Container(
        child: Stack(
          children: [
            Center(
              child: fil_barang == null
                  ? Container(
                width: 100,
                child: LinearProgressIndicator(
                  backgroundColor: Colors.greenAccent,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                ),
              )
                  : ListView.builder(itemCount: fil_barang.length, itemBuilder: (context, i){

                    final String _kodePembeli     = prefsKodePembeli;
                    final String _namaPembeli     = prefsNamaPembeli;
                    final String _kodeToko        = fil_barang[i].kodeToko;
                    final String _kodeBarang      = fil_barang[i].kodeBarang;
                    final String _barcodeBarang   = fil_barang[i].barcodeBarang;
                    final String _namaBarang      = fil_barang[i].namaBarang;
                    final String _satuan          = fil_barang[i].satuan;
                    final String _klpBarang       = fil_barang[i].klpBarang;
                    final String _hargaJual       = fil_barang[i].hargaJual;
                    final String _kodeSatuan      = fil_barang[i].kodeSatuan;
                    final String _hargaTotal      = fil_barang[i].hargaJual;

              return Container(
                  padding: EdgeInsets.only(left: 20, right: 20, top: 10),
                  child: RaisedButton(
                        onPressed: (){
                          masukanKeranjang(_kodePembeli,_namaPembeli,_kodeToko,_kodeBarang,_barcodeBarang,_namaBarang,_satuan,_klpBarang,_hargaJual,_kodeSatuan,_hargaTotal);
                          _showDialogSuccess();
                        },
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side: BorderSide(color: Colors.greenAccent, width: 0.5),
                        ),
                        elevation: 0,
                        color: Colors.white,
                        child: Row(
                          children: [
                            Container(
                              padding: EdgeInsets.only(top: 10, bottom: 10, right: 10),
                              child: Image.asset('assets/img_barang.png', width: 46.0,),
                            ),
                            Expanded(
                              flex: 2,
                              child: Column(
                                children: [
                                  Container(
                                    alignment: Alignment.centerLeft,
                                    child: Text('${_namaBarang}', style: TextStyle(fontSize: 20.0),),
                                  ),
                                  Container(
                                    alignment: Alignment.centerLeft,
                                    child: Text('${_satuan}', style: TextStyle(fontSize: 10),),
                                  )
                                ],
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Container(
                                alignment: Alignment.centerLeft,
                                child: Text('Rp. ${_hargaJual}', style: TextStyle(fontSize: 20.0),),
                              ),
                            ),
                          ],
                        ),
                      ),
                );
              },) ,
            ),
            Container(
              padding: EdgeInsets.only(left: 20, bottom: 20),
              alignment: Alignment.bottomCenter,
              child: !isSearching
                  ? Row(
                      children: [
                        IconButton(icon: Icon(Icons.search), onPressed: (){
                          setState(() {
                            isSearching = true;
                          });
                        }),
                        IconButton(icon: Image.asset('assets/iconorder/barcode.png', color: themeColor, width: 24,), onPressed: (){}),
                        IconButton(icon: Image.asset('assets/iconorder/qrcode.png', color: themeColor, width: 24,), onPressed: (){})
                      ],
                    )
                  : Container(
                        child: Row(
                          children: [
                            Expanded(
                              flex: 4,
                              child: TextFormField(
                                decoration: InputDecoration(
                                    labelText: "Search",
                                    fillColor: Colors.white,
                                    filled: true,
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10)
                                    ),
                                ),
                                onChanged: (value){
                                  _filBarang(value);
                                },
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: IconButton(
                                icon: Icon(Icons.clear, color: themeColor),
                                onPressed: (){
                                  setState(() {
                                    this.isSearching = false;
                                  });
                                },
                              ),
                            )
                          ],
                        ),
                    )
            )
          ],
        ),
      ),
    );
  }
}