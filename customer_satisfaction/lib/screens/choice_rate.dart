import 'dart:async';
import 'dart:convert';

import 'package:customer_satisfaction/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:screen/screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:transparent_image/transparent_image.dart';

class ChoiceRate extends StatefulWidget {
  @override
  _ChoiceRateState createState() => _ChoiceRateState();
}

class _ChoiceRateState extends State<ChoiceRate> with WidgetsBindingObserver{

  SharedPreferences prefs;
  TextEditingController _controllerDeskripsi = new TextEditingController();

  AppLifecycleState _lastLifecycleState;

  bool valueChange6    = false;
  bool valueChange5    = false;
  bool valueChange4    = false;
  bool valueChange3    = false;
  bool valueChange2    = false;
  bool valueChange1    = false;

  String val6    = "";
  String val5    = "";
  String val4    = "";
  String val3    = "";
  String val2    = "";
  String val1    = "";

  double sizeIcon1  = 120.0;
  double sizeIcon2  = 120.0;
  double sizeIcon3  = 120.0;
  double sizeIcon4  = 120.0;
  double sizeIcon5  = 120.0;
  double sizeSelect = 130.0;
  double sizeDefault = 120.0;

  Color img1    = Colors.black54;
  Color img2    = Colors.black54;
  Color img3    = Colors.black54;
  Color img4    = Colors.black54;
  Color img5    = Colors.black54;
  Color img6    = Colors.black54;
  Color imgDefault  = Colors.black54;
  Color imgChecked  = Colors.red;

  var imageSelected = Image.asset('assets/lima.png');
  double titleSize  = 20;

  var content;

  valueSelected6(String valueBecause, String valueSelected, bool val) {
    setState(() {
          valueChange6 == false
          ?
          valueChange6 = val
          :
          valueChange6 = false;
    });
    Navigator.pop(context);
    _showDialogDeskripsi(valueBecause,valueSelected);
  }
  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPrefs();
    Screen.keepOn(true);
    Screen.setBrightness(0.8);
  }

  String imgrate1 = '';
  String imgrate2 = '';
  String imgrate3 = '';
  String imgrate4 = '';
  String imgrate5 = '';
  String idUserTempat;
  String idKategori;

  String title      = "Selamat datang Di Rest Area 88A";
  String subtitle   = "";

  void getPrefs() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      idUserTempat = prefs.getString('id_user_tempat');
      idKategori = prefs.getString('id_kategori');
      if(idKategori=='3'){
        setState(() {
          subtitle = "Silakan pilih penilaian anda terhadap Masjid kami.";
        });
      }else{
        setState(() {
          subtitle = "Silakan pilih penilaian anda terhadap Toilet kami.";
        });
      }
      getFooterDonasi(idUserTempat);
      getFooterVisitUs();
      getFooterPoweredBy();
    });
    if(prefs.getString('id_kategori')=="1"){
    //  WANITA
      setState(() {
        imgrate1 = 'assets/satu.png';
        imgrate2 = 'assets/dua.png';
        imgrate3 = 'assets/tiga.png';
        imgrate4 = 'assets/empat.png';
        imgrate5 = 'assets/lima.png';
      });
    }else{
    //  PRIA
      setState(() {
        imgrate1 = 'assets/cow1.png';
        imgrate2 = 'assets/cow2.png';
        imgrate3 = 'assets/cow3.png';
        imgrate4 = 'assets/cow4.png';
        imgrate5 = 'assets/cow5.png';
      });
    }
  }

  Future<List> insertRating(String rating,String jenisKeluhan,String keterangan) async {
    String idJenisKeluhan;
    if(jenisKeluhan == "-"){
      setState(() {
        idJenisKeluhan = "0";
      });
    }else if(jenisKeluhan == ""){

    }

    String imgSend;
    if(idKategori == '1'){
      if(rating == '3'){
        setState(() {
          imgSend = 'assets/tiga.png';
        });
      }else if(rating == '4'){
        setState(() {
          imgSend = 'assets/empat.png';
        });
      }else if(rating == '5') {
        setState(() {
          imgSend = 'assets/lima.png';
        });
      }
    }else{
      if(rating == '3'){
        setState(() {
          imgSend = 'assets/cow3.png';
        });
      }else if(rating == '4'){
        setState(() {
          imgSend = 'assets/cow4.png';
        });
      }else if(rating == '5') {
        setState(() {
          imgSend = 'assets/cow5.png';
        });
      }
    }

    var url = Constant.RATED;
    final response = await http.post(
      url,
      body: {
        'id_user_tempat':idUserTempat,
        'rating':rating,
        'id_jenis_keluhan':idJenisKeluhan,
        'keterangan':keterangan
      },
      headers: {"Accept":"application/json"}
    );

    var dataRate = json.decode(response.body);
    if(dataRate.length!=0){
      if(dataRate['status']=="fail"){
        print("Gagal");
      }else{
        print("Berhasil");
        _showDialogSukses(imgSend);
        setState(() {
          sizeIcon1 = sizeDefault;
          sizeIcon2 = sizeDefault;
          sizeIcon3 = sizeDefault;
          sizeIcon4 = sizeDefault;
          sizeIcon5 = sizeDefault;
        });
        if(keterangan != "-"){
          Navigator.pop(context);
        }
        var duration = const Duration(seconds: 3);
        Timer(duration, (){
          Navigator.pop(context);
        });
      }
    }else{
      print("Ada Kesalahan.");
    }
  }

  String imgFooterVisitUs = "";
  void getFooterVisitUs() async {
    var url = Constant.FOOTER;
    final response = await http.post(
        url,
      body: {
        'id_user_tempat':'0',
        'kategori_footer':'1'
      },
      headers: {"Accept": "application/json"}
    );

    var dataVisitUs = json.decode(response.body);
    if(dataVisitUs.length!=0){
      if(dataVisitUs['status']=='success'){
        setState(() {
          imgFooterVisitUs = Constant.BASE_URL_IMAGE+dataVisitUs['image'];
          print(imgFooterVisitUs);
        });
      }else{
        setState(() {
          imgFooterVisitUs = Constant.BASE_URL_IMAGE_CRASH;
        });
      }
    }else{
      setState(() {
        imgFooterVisitUs = Constant.BASE_URL_IMAGE_CRASH;
      });
    }
  }

  String imgFooterDonasi = "";
  void getFooterDonasi(String idUserTempat) async {
    print("OOIII"+idUserTempat);
    var url = Constant.FOOTER;
    final response = await http.post(
        url,
        body: {
          'id_user_tempat':idUserTempat,
          'kategori_footer':'2'
        },
        headers: {"Accept": "application/json"}
    );

    var dataDonasi = json.decode(response.body);
    if(dataDonasi.length!=0){
      print("BERHASIL DONASI"+dataDonasi['status']);

      if(dataDonasi['status']=='success'){
        setState(() {
          imgFooterDonasi = Constant.BASE_URL_IMAGE+dataDonasi['image'];
          print(imgFooterDonasi);
        });
      }else{
        setState(() {
          imgFooterDonasi = Constant.BASE_URL_IMAGE_CRASH;
        });
      }
    }else{
      print("ADA KESALAHAN");
      setState(() {
        imgFooterDonasi = Constant.BASE_URL_IMAGE_CRASH;
      });
    }
  }

  String imgFooterPoweredBy = "";
  void getFooterPoweredBy() async {
    var url = Constant.FOOTER;
    final response = await http.post(
        url,
        body: {
          'id_user_tempat':'0',
          'kategori_footer':'3'
        },
        headers: {"Accept": "application/json"}
    );

    var dataVisitUs = json.decode(response.body);
    if(dataVisitUs.length!=0){
      if(dataVisitUs['status']=='success'){
        setState(() {
          imgFooterPoweredBy = Constant.BASE_URL_IMAGE+dataVisitUs['image'];
        });
      }else{
        setState(() {
          imgFooterPoweredBy = Constant.BASE_URL_IMAGE_CRASH;
        });
      }
    }else{
      setState(() {
        imgFooterPoweredBy = Constant.BASE_URL_IMAGE_CRASH;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
          body: SingleChildScrollView(
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/bgr_qai.png'),
                  fit: BoxFit.cover,
                ),
              ),
              height: MediaQuery.of(context).size.height,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height * 0.15,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(padding: EdgeInsets.only(left: 200)),
                        Expanded(
                          child: Image.asset('assets/logo_jmrb.png', width: 200,),
                        ),
                        Padding(padding: EdgeInsets.only(right: 200)),
                      ],
                    ),
                  ),
                  Padding(padding: EdgeInsets.only(top: 10)),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.15,
                    padding: EdgeInsets.only(left: 40, right: 40, bottom: 40),
                    child: Column(
                      children: [
                        Text(title, style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),),
                        Text(subtitle, style: TextStyle(color: Colors.white, fontSize: 20),),
                      ],
                    ),
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.3,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              FlatButton(
                                child: Image.asset(imgrate1, width: sizeIcon1,),
                                onPressed: (){
                                  setState(() {
                                    sizeIcon1  = sizeSelect;
                                    sizeIcon2  = sizeDefault;
                                    sizeIcon3  = sizeDefault;
                                    sizeIcon4  = sizeDefault;
                                    sizeIcon5  = sizeDefault;
                                    imageSelected   = Image.asset(imgrate1, width: 300,);
                                    _showDialog('1');
                                  });
                                },
                              ),
                              Padding(padding: EdgeInsets.only(top: 8)),
                              Text("Tidak Puas", style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),)
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              FlatButton(
                                child: Image.asset(imgrate2, width: sizeIcon2,),
                                onPressed: (){
                                  setState(() {
                                    sizeIcon1  = sizeDefault;
                                    sizeIcon2  = sizeSelect;
                                    sizeIcon3  = sizeDefault;
                                    sizeIcon4  = sizeDefault;
                                    sizeIcon5  = sizeDefault;
                                    imageSelected   = Image.asset(imgrate2, width: 300,);
                                    _showDialog('2');
                                  });
                                },
                              ),
                              Padding(padding: EdgeInsets.only(top: 8)),
                              Text("Kurang Puas", style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),)
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              FlatButton(
                                child: Image.asset(imgrate3, width: sizeIcon3,),
                                onPressed: (){
                                  setState(() {
                                    sizeIcon1  = sizeDefault;
                                    sizeIcon2  = sizeDefault;
                                    sizeIcon3  = sizeSelect;
                                    sizeIcon4  = sizeDefault;
                                    sizeIcon5  = sizeDefault;
                                  });
                                  insertRating('3','-','-');
                                },
                              ),
                              Padding(padding: EdgeInsets.only(top: 8)),
                              Text("Cukup Puas", style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),)
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              FlatButton(
                                child: Image.asset(imgrate4, width: sizeIcon4,),
                                onPressed: (){
                                  setState(() {
                                    sizeIcon1  = sizeDefault;
                                    sizeIcon2  = sizeDefault;
                                    sizeIcon3  = sizeDefault;
                                    sizeIcon4  = sizeSelect;
                                    sizeIcon5  = sizeDefault;
                                  });
                                  insertRating('4','-','-');
                                },
                              ),
                              Padding(padding: EdgeInsets.only(top: 8)),
                              Text("Puas", style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),)
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              FlatButton(
                                child: Image.asset(imgrate5, width: sizeIcon5,),
                                onPressed: (){
                                  setState(() {
                                    sizeIcon1  = sizeDefault;
                                    sizeIcon2  = sizeDefault;
                                    sizeIcon3  = sizeDefault;
                                    sizeIcon4  = sizeDefault;
                                    sizeIcon5  = sizeSelect;
                                  });
                                  insertRating('5','-','-');
                                },
                              ),
                              Padding(padding: EdgeInsets.only(top: 8)),
                              Text("Sangat Puas", style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),)
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.15,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(padding: EdgeInsets.only(left: 200)),
                        Expanded(
                          child: Column(
                            children: [
                              Container(
                                padding: EdgeInsets.only(bottom: 5),
                                child: Text("Visit Us", style: TextStyle(color: Colors.white, fontSize: 13),),
                              ),
                              FadeInImage.memoryNetwork(placeholder: kTransparentImage, image: imgFooterVisitUs, height: 70,)
                              // Image.network(imgFooterVisitUs, height: 80,)
                            ],
                          ),
                        ),
                        Expanded(
                          child: idKategori=='3' ? Column(
                            children: [
                              Container(
                                padding: EdgeInsets.only(bottom: 5),
                                child: Text("Infak Masjid", style: TextStyle(color: Colors.white, fontSize: 13),),
                              ),
                              FadeInImage.memoryNetwork(placeholder: kTransparentImage, image: imgFooterDonasi, height: 70,)
                            ],
                          ) : Container(),
                        ),
                        Padding(padding: EdgeInsets.only(right: 200)),
                      ],
                    ),
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.1,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Container(),
                        ),
                        Expanded(
                          child: Container(),
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              Container(
                                child: Text("Powered by", style: TextStyle(color: Colors.white, fontSize: 13),),
                              ),
                              Padding(padding: EdgeInsets.only(top: 5)),
                              Container(
                                  child: FadeInImage.memoryNetwork(placeholder: kTransparentImage, image: imgFooterPoweredBy, height: 20,)
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        )
    );
  }

  void _showDialog(String valueRating) {
    showDialog(
      context: context,
      builder: (BuildContext context){
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0)
            ),
            child: SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.only(left: 40, right: 40),
                height: 600,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    imageSelected,
                    Padding(padding: EdgeInsets.only(top: 20)),
                    Text('Apa yang membuat anda tidak nyaman?', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                    Padding(padding: EdgeInsets.only(top: 25)),
                    Container(
                      child: Row(
                        children: [
                          Expanded(
                            child: FlatButton(
                              onPressed: (){
                                insertRatingSatuDua(valueRating,'1','--');
                                setState(() {
                                  img1 = imgChecked;
                                  img2 = imgDefault;
                                  img3 = imgDefault;
                                  img4 = imgDefault;
                                  img5 = imgDefault;
                                  img6 = imgDefault;
                                });
                              },
                              child: Column(
                                children: [
                                  Image.asset('assets/check.png', width: 30, color: img1,),
                                  Padding(padding: EdgeInsets.only(top: 8)),
                                  Text("Pelayanan", style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold))
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            child: FlatButton(
                              onPressed: (){
                                insertRatingSatuDua(valueRating,'2','--');
                                setState(() {
                                  img1 = imgDefault;
                                  img2 = imgChecked;
                                  img3 = imgDefault;
                                  img4 = imgDefault;
                                  img5 = imgDefault;
                                  img6 = imgDefault;
                                });
                              },
                              child: Column(
                                children: [
                                  Image.asset('assets/check.png', width: 30, color: img2,),
                                  Padding(padding: EdgeInsets.only(top: 8)),
                                  Text("Kebersihan", style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold))
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            child: FlatButton(
                              onPressed: (){
                                insertRatingSatuDua(valueRating,'3','--');
                                setState(() {
                                  img1 = imgDefault;
                                  img2 = imgDefault;
                                  img3 = imgChecked;
                                  img4 = imgDefault;
                                  img5 = imgDefault;
                                  img6 = imgDefault;
                                });
                              },
                              child: Column(
                                children: [
                                  Image.asset('assets/check.png', width: 30, color: img3,),
                                  Padding(padding: EdgeInsets.only(top: 8)),
                                  Text("Kenyamanan", style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold))
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            child: FlatButton(
                              onPressed: (){
                                insertRatingSatuDua(valueRating,'4','--');
                                setState(() {
                                  img1 = imgDefault;
                                  img2 = imgDefault;
                                  img3 = imgDefault;
                                  img4 = imgChecked;
                                  img5 = imgDefault;
                                  img6 = imgDefault;
                                });
                              },
                              child: Column(
                                children: [
                                  Image.asset('assets/check.png', width: 30, color: img4,),
                                  Padding(padding: EdgeInsets.only(top: 8)),
                                  Text("Fasilitas", style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold))
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            child: FlatButton(
                              onPressed: (){
                                insertRatingSatuDua(valueRating,'5','--');
                                setState(() {
                                  img1 = imgDefault;
                                  img2 = imgDefault;
                                  img3 = imgDefault;
                                  img4 = imgDefault;
                                  img5 = imgChecked;
                                  img6 = imgDefault;
                                });
                              },
                              child: Column(
                                children: [
                                  Image.asset('assets/check.png', width: 30, color: img5,),
                                  Padding(padding: EdgeInsets.only(top: 8)),
                                  Text("Keamanan", style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold))
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            child: FlatButton(
                              onPressed: (){
                                valueSelected6('6',valueRating,true);
                              },
                              child: Column(
                                children: [
                                  Image.asset('assets/check.png', width: 30, color: img6,),
                                  Padding(padding: EdgeInsets.only(top: 8)),
                                  Text("Lainya", style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold))
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
      }
    );
  }

  void _showDialogDeskripsi(String valueBecause, String valueSelected) {
    showDialog(
        context: context,
      builder: (BuildContext context){
          return SingleChildScrollView(
            child: Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)
              ),
              child: Container(
                padding: EdgeInsets.only(left: 30,right: 30,top: 30,bottom: 30),
                child: Column(
                  children: [
                    TextFormField(
                      controller: _controllerDeskripsi,
                      textAlignVertical: TextAlignVertical.top,
                      decoration: InputDecoration(
                          labelText: 'Deskripsi',
                          border: OutlineInputBorder()
                      ),
                      maxLines: 5,
                      minLines: 2,
                      autofocus: true,
                    ),
                    Row(
                      children: [
                        Expanded(
                            child: OutlineButton(
                              onPressed: (){
                                insertRatingSatuDua(valueSelected,'6',_controllerDeskripsi.text);
                              },
                              child: Text("Kirim", style: TextStyle(color: Colors.deepOrange),),
                            )
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          );
      }
    );
  }

  void insertRatingSatuDua(String valueRating, String idKeluhan, String keterangan) async {
    var url = Constant.RATED;
    final response = await http.post(
        url,
        body: {
          'id_user_tempat':idUserTempat,
          'rating':valueRating,
          'id_jenis_keluhan':idKeluhan,
          'keterangan':keterangan
        },
        headers: {"Accept":"application/json"}
    );

    var dataRate = json.decode(response.body);
    if(dataRate.length!=0){
      if(dataRate['status']=="fail"){
        print("Gagal");
      }else{
        print("Berhasil");
        sizeIcon1 = sizeDefault;
        sizeIcon2 = sizeDefault;
        sizeIcon3 = sizeDefault;
        sizeIcon4 = sizeDefault;
        sizeIcon5 = sizeDefault;
        if(keterangan != "-"){
          Navigator.pop(context);
        }
      }
    }else{
      print("Ada Kesalahan.");
    }
  }

  void _showDialogSukses(String imgShow) {
    showDialog(
      context: context,
      builder: (BuildContext context){
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: EdgeInsets.symmetric(horizontal: 200, vertical: 70),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0)
          ),
          child: Container(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(imgShow, width: 300,),
                  Padding(padding: EdgeInsets.only(top: 20)),
                  Text("Terimakasih untuk saran yang membangun.", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.deepOrange),),
                ],
              )
            ),
          ),
        );
      }
    );
  }
}


