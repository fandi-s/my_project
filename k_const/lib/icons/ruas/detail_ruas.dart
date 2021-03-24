import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kconst/icons/ruas/droneview.dart';
import 'package:kconst/utils/dotsindicator.dart';
import 'package:intl/intl.dart';

import 'package:http/http.dart' as http;
import 'package:charts_flutter/flutter.dart' as charts;

class DetailRuas extends StatefulWidget{

  final String ruas;
  final String nama_ruas;
  final String id_region;
  final String url_region;
  final String frompage;
  DetailRuas({Key key, @required this.ruas, this.nama_ruas, this.id_region, this.url_region, this.frompage}) : super(key: key);

  @override
  DetailRuasState createState() => DetailRuasState();
}

class DetailRuasState extends State<DetailRuas> {

  //UNTUK CHART FLEXIBLE DAN RIGID
  String urlrigid;
  List dataJSONrigid = [];
  getDataRigid() async {
    urlrigid  = "http://i_cons.bpjt.pu.go.id/api/perkerasan_rigit/${widget.ruas}";
    final response = await http.get(urlrigid);
    return json.decode(response.body);
  }

  String urlFlexible;
  List dataFlexible = [];
  getDataFlexible() async {
    urlFlexible = "http://i_cons.bpjt.pu.go.id/api/perkerasan_fleksibel/${widget.ruas}";
    final response = await http.get(urlFlexible);
    return json.decode(response.body);
  }

  String urlDrone;
  List dataDrone = [];
  getDrone() async {
    urlDrone = "http://i_cons.bpjt.pu.go.id/api/drone/${widget.ruas}";
    final response = await http.get(urlDrone);
    return json.decode(response.body);
  }

  String urlPekerjaantanah;
  List dataPekTanah = [];
  getPektanah() async {
    urlPekerjaantanah = "http://i_cons.bpjt.pu.go.id/api/penanganan_tanah/${widget.ruas}";
    final response = await http.get(urlPekerjaantanah);
    return json.decode(response.body);
  }


  bool isFilter = false;

  final nfr = NumberFormat.currency(locale: "id_IDR", symbol: "Rp. ");

  final _controller = new PageController(initialPage: 1);
  final _kDuration = const Duration(milliseconds: 300);
  final _kCurve = Curves.ease;

  bool _fromTop = true;

  List dataRuas = [];
  var url;
  getData(url) async {
    // if(widget.ruas=="1001"){
    //   url = "http://fds-management.com/ruas_pettarani.json";
    // }else{
    //   url = "http://i_cons.bpjt.pu.go.id/api/detail_ruas/${widget.ruas}";
    // }
    url = "http://i_cons.bpjt.pu.go.id/api/detail_ruas/${widget.ruas}";
    final response = await http.get(url);
    return json.decode(response.body);
  }

  List dataRuasKonst = [];
  var urlKonst;
  getDataKonst(urlKonst) async {
    // if(widget.ruas=="1001"){
    //   urlKonst = "http://fds-management.com/konst_pettarani.json";
    // }else{
    //   urlKonst = "http://i_cons.bpjt.pu.go.id/api/konstruksi/${widget.ruas}";
    // }
    urlKonst = "http://i_cons.bpjt.pu.go.id/api/konstruksi/${widget.ruas}";
    final response = await http.get(urlKonst);
    return json.decode(response.body);
  }

  List dataRuasKonstSeksi = [];
  var urlKonstSeksi;
  getDataKonstSeksi(urlKonstSeksi) async {
    // if(widget.ruas=="1001"){
    //   urlKonst = "http://fds-management.com/konst_seksi_pettarani.json";
    // }else{
    //   urlKonst = "http://i_cons.bpjt.pu.go.id/api/detail_prog_konstruksi/${widget.id_region}/${widget.ruas}";
    // }
    urlKonst = "http://i_cons.bpjt.pu.go.id/api/detail_prog_konstruksi/${widget.id_region}/${widget.ruas}";
    final response = await http.get(urlKonst);
    return json.decode(response.body);
  }

  String nama_seksi = "";
  String panjang = "";
  String prog_tanah = "";
  String status_prog = "";
  String target_opr = "";

  String realisasiTanah = "";
  String rencanaKonst = "";
  String realisasiKonst = "";
  String deviasi = "";

  double valuerealisasiTanah;
  double valuerencanaKonst;
  double valuerealisasiKonst;
  double valuedeviasiKonst;

  List dataPilihRuas = [];
  var urlPilihRuas;
  getDataPilihRuas(urlPilihRuas) async {
    urlPilihRuas = "http://i_cons.bpjt.pu.go.id/api/grafik_ruas/${widget.id_region}";
    final response = await http.get(urlPilihRuas);
    return json.decode(response.body);
  }

  List ruasoverview = [];
  List filterSearch = [];
  getRuasOverview() async {
    var url = "${widget.url_region}";
    final response = await http.get(url);
    return json.decode(response.body);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getDataRigid().then((data){
      setState(() {
        dataJSONrigid = data;
      });
    });

    getDataFlexible().then((data){
      setState(() {
        dataFlexible = data;
      });
    });

    getDrone().then((data){
      setState(() {
        dataDrone = data;
      });
    });

    getPektanah().then((data){
      setState(() {
        dataPekTanah = data;
      });
    });

    getData(url).then((data){
      setState(() {
        dataRuas = data;
      });
    });

    getDataKonst(urlKonst).then((data){
      setState(() {
        dataRuasKonst = data;
      });
    });

    getDataKonstSeksi(urlKonstSeksi).then((data){
      setState(() {
        dataRuasKonstSeksi = data;
      });
    });

    getDataPilihRuas(urlPilihRuas).then((data){
      setState(() {
        dataPilihRuas = data;
      });
    });

    getRuasOverview().then((data){
      setState(() {
        ruasoverview = filterSearch = data;
      });
    });
  }

  void _filterRegionTJ(){
    setState(() {
      if(widget.frompage=="overview"){
        if(widget.id_region=="1"){
          filterSearch = ruasoverview
              .where((region)=>
          region['id_region'] == '1')
              .toList();
        }else if(widget.id_region=="2"){
          filterSearch = ruasoverview
              .where((region)=>
          region['id_region'] == '2')
              .toList();
        }else if(widget.id_region=="3"){
          filterSearch = ruasoverview
              .where((region)=>
          region['id_region'] == '3')
              .toList();
        }else if(widget.id_region=="4"){
          filterSearch = ruasoverview
              .where((region)=>
          region['id_region'] == '4')
              .toList();
        }
      }else if(widget.frompage=="region"){
        filterSearch = ruasoverview;
      }

    });
  }

  bool btn_ppjt = true;
  bool btn_ppjt_amdmn = false;
  var col_ppjt = Colors.white70;
  var col_amndm = Colors.white70;

  bool btn_utama = true;
  bool btn_elevated = false;
  var col_utama = Colors.black38;
  var col_lelevated = Colors.black38;

  String selGalian;
  String totalGalian;
  String selTimbunan;
  String totalTimbunan;

  @override
  Widget build(BuildContext context) {
    
    List<Sales> databelum = [];
    for(Map m in dataJSONrigid){
      String blm_terbangun = "${m['belum_terbangun']}";
      String finalStr = blm_terbangun.replaceAll(",", "");
      double blm = double.parse(finalStr);
      databelum.add(Sales(m['nama_struktur'], blm, Colors.red));
    }

    List<Sales> datasudah = [];
    for(Map m in dataJSONrigid){
      databelum.add(Sales(m['nama_struktur'], m['terbangun'], Colors.lightBlue));
    }

    var seriesRigid =[
      charts.Series(
          domainFn: (Sales sales,_)=>sales.day,
          measureFn: (Sales sales,_)=>sales.sold,
          colorFn: (Sales sales,_)=>sales.color,
          id: 'Sales',
          data: databelum,
          labelAccessorFn: (Sales sales,_)=>'${sales.sold.toString()}'
      ),
      charts.Series(
          domainFn: (Sales sales,_)=>sales.day,
          measureFn: (Sales sales,_)=>sales.sold,
          colorFn: (Sales sales,_)=>sales.color,
          id: 'Sales',
          data: datasudah,
          labelAccessorFn: (Sales sales,_)=>'${sales.sold.toString()}'
      ),
    ];

    var chartRigid = charts.BarChart(
      seriesRigid,
      barGroupingType: charts.BarGroupingType.stacked,
      barRendererDecorator: charts.BarLabelDecorator<String>(
        labelPosition: charts.BarLabelPosition.outside
      ),
      animate: true,
      vertical: false,
      // primaryMeasureAxis: charts.NumericAxisSpec(
      //   renderSpec: charts.NoneRenderSpec(),
      // ),
    );

    List<Sales> databelumSubase = [];
    for(Map m in dataFlexible){
      String blm_terbangun = "${m['belum_terbangun']}";
      String finalStr = blm_terbangun.replaceAll(",", "");
      double blm = double.parse(finalStr);
      String label;
      print(blm);
      if(m['kategori']==1){
        label = "LPA";
      }else{
        label = "Sub Base";
      }
      databelumSubase.add(Sales(label, blm, Colors.red));
    }

    List<Sales> datasudahSubase = [];
    for(Map m in dataFlexible){
      String label;
      if(m['kategori']==1){
        label = "LPA";
      }else{
        label = "Sub Base";
      }
      datasudahSubase.add(Sales(label, m['terbangun'], Colors.lightBlue));
    }

    var seriesSubase =[
      charts.Series(
          domainFn: (Sales sales,_)=>sales.day,
          measureFn: (Sales sales,_)=>sales.sold,
          colorFn: (Sales sales,_)=>sales.color,
          id: 'Sales',
          data: datasudahSubase,
          labelAccessorFn: (Sales sales,_)=>'${sales.sold.toString()}'
      ),
      charts.Series(
          domainFn: (Sales sales,_)=>sales.day,
          measureFn: (Sales sales,_)=>sales.sold,
          colorFn: (Sales sales,_)=>sales.color,
          id: 'Sales',
          data: databelumSubase,
          labelAccessorFn: (Sales sales,_)=>'${sales.sold.toString()}'
      ),
    ];

    var chartSubbase = charts.BarChart(
      seriesSubase,
      barGroupingType: charts.BarGroupingType.stacked,
      barRendererDecorator: charts.BarLabelDecorator<String>(),
      animate: true,
      vertical: false,
    );

    for(Map m in dataPekTanah){
      setState(() {
        selGalian = m['selesai_galian'];
        totalGalian = m['dari_total_galian'];
        selTimbunan = m['selesai_timbunan'];
        totalTimbunan = m['dari_total_timbunan'];
      });
    }

    final List<Widget> _pagesPJG_PMLG = <Widget>[
      ConstrainedBox(
        constraints: const BoxConstraints.expand(),
        child: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.black12,
                  Colors.white24,
                  Colors.white,
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: BorderRadius.only(
                  topRight: const Radius.circular(20.0),
                  topLeft: const Radius.circular(20.0),
                  bottomRight: const Radius.circular(10.0),
                  bottomLeft: const Radius.circular(10.0)
              ),
          ),
          child: Column(
            children: [
              Padding(padding: EdgeInsets.only(top: 35)),
              Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.only(left: 35.0),
                child: Text("Aspek Umum Teknis", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87, fontSize: 16),),
              ),
              Padding(padding: EdgeInsets.only(top: 10)),
              Container(
                padding: EdgeInsets.only(left: 30, right: 30),
                child: Row(
                  children: [
                    Expanded(
                      child: OutlineButton(
                        borderSide: BorderSide(
                          color: col_ppjt
                        ),
                        onPressed: (){
                          setState(() {
                            btn_ppjt = true;
                            btn_ppjt_amdmn = false;
                            col_ppjt = Colors.black87;
                            col_amndm = Colors.white70;
                          });
                        },
                        child: Text("PPJT", style: TextStyle(fontSize: 11),),
                      ),
                    ),
                    Padding(padding: EdgeInsets.only(left: 5, right: 5)),
                    Expanded(
                        child: OutlineButton(
                          borderSide: BorderSide(
                              color: col_amndm
                          ),
                          onPressed: (){
                            setState(() {
                              btn_ppjt = false;
                              btn_ppjt_amdmn = true;
                              col_ppjt = Colors.white70;
                              col_amndm = Colors.black87;
                            });
                          },
                          child: Text("Amandemen PPJT", style: TextStyle(fontSize: 11),),
                        )
                    ),
                  ],
                ),
              ),
              btn_ppjt == true
                  ?
              Container(
                height: 280,
                child: dataRuas.length > 0 ?
                ListView.builder(
                  itemCount: dataRuas.length,
                  itemBuilder: (BuildContext context, int index){
                    return Container(
                      padding: EdgeInsets.only(left: 20, right: 20),
                      child: Column(
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Padding(padding: EdgeInsets.only(left: 20.0),),
                              Expanded(
                                flex: 1,
                                child: Text("Panjang Total", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.black54),),
                              ),
                              Padding(padding: EdgeInsets.only(left: 10.0),),
                              Container(
                                child: Text(" : ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.black54),),
                              ),
                              Padding(padding: EdgeInsets.only(left: 10.0),),
                              Expanded(
                                flex: 2,
                                child: Text("${dataRuas[index]['Panjang']} Km", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.black54),),
                              )
                            ],
                          ),
                          Padding(padding: EdgeInsets.only(top: 8.0),),
                          Row(
                            children: <Widget>[
                              Padding(padding: EdgeInsets.only(left: 20.0),),
                              Expanded(
                                flex: 1,
                                child: Text("Panjang Konstruksi", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.black54),),
                              ),
                              Padding(padding: EdgeInsets.only(left: 10.0),),
                              Container(
                                child: Text(" : ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.black54),),
                              ),
                              Padding(padding: EdgeInsets.only(left: 10.0),),
                              Expanded(
                                flex: 2,
                                child: Text("${dataRuas[index]['Panjang_kontruksi']} Km", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.black54),),
                              )
                            ],
                          ),
                          Padding(padding: EdgeInsets.only(top: 8.0),),
                          Row(
                            children: <Widget>[
                              Padding(padding: EdgeInsets.only(left: 20.0),),
                              Expanded(
                                flex: 1,
                                child: Text("Panjang Operasi", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.black54),),
                              ),
                              Padding(padding: EdgeInsets.only(left: 10.0),),
                              Container(
                                child: Text(" : ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.black54),),
                              ),
                              Padding(padding: EdgeInsets.only(left: 10.0),),
                              Expanded(
                                flex: 2,
                                child: Text("${dataRuas[index]['Panjang_operasi']} Km", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.black54),),
                              )
                            ],
                          ),
                          Padding(padding: EdgeInsets.only(top: 8.0),),
                          Row(
                            children: <Widget>[
                              Padding(padding: EdgeInsets.only(left: 20.0),),
                              Expanded(
                                flex: 1,
                                child: Text("Jumlah Seksi", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.black54),),
                              ),
                              Padding(padding: EdgeInsets.only(left: 10.0),),
                              Container(
                                child: Text(" : ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.black54),),
                              ),
                              Padding(padding: EdgeInsets.only(left: 10.0),),
                              Expanded(
                                flex: 2,
                                child: Text("${dataRuas[index]['JumlahSeksi']} Seksi", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.black54),),
                              )
                            ],
                          ),
                          Padding(padding: EdgeInsets.only(top: 8.0),),
                          Row(
                            children: <Widget>[
                              Padding(padding: EdgeInsets.only(left: 20.0),),
                              Expanded(
                                flex: 1,
                                child: Text("LHR dalam PPJT", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.black54),),
                              ),
                              Padding(padding: EdgeInsets.only(left: 10.0),),
                              Container(
                                child: Text(" : ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.black54),),
                              ),
                              Padding(padding: EdgeInsets.only(left: 10.0),),
                              Expanded(
                                flex: 2,
                                child: Text("${dataRuas[index]['JumlahKendaraanPerhari']}", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.black54),),
                              )
                            ],
                          ),
                          Padding(padding: EdgeInsets.only(top: 8.0),),
                          Row(
                            children: <Widget>[
                              Padding(padding: EdgeInsets.only(left: 20.0),),
                              Expanded(
                                flex: 1,
                                child: Text("Target Operasi PPJT", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.black54),),
                              ),
                              Padding(padding: EdgeInsets.only(left: 10.0),),
                              Container(
                                child: Text(" : ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.black54),),
                              ),
                              Padding(padding: EdgeInsets.only(left: 10.0),),
                              Expanded(
                                flex: 2,
                                child: Text("${dataRuas[index]['TargetOperasi']}", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.black54),),
                              )
                            ],
                          ),
                          Padding(padding: EdgeInsets.only(top: 8.0),),
                          Row(
                            children: <Widget>[
                              Padding(padding: EdgeInsets.only(left: 20.0),),
                              Expanded(
                                flex: 1,
                                child: Text("Biaya Investasi", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.black54),),
                              ),
                              Padding(padding: EdgeInsets.only(left: 10.0),),
                              Container(
                                child: Text(" : ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.black54),),
                              ),
                              Padding(padding: EdgeInsets.only(left: 10.0),),
                              Expanded(
                                flex: 2,
                                child: Text("${nfr.format(double.parse(dataRuas[index]['BiayaInvestasi']))}", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.black54),),
                              )
                            ],
                          ),
                          Padding(padding: EdgeInsets.only(top: 8.0),),
                          Row(
                            children: <Widget>[
                              Padding(padding: EdgeInsets.only(left: 20.0),),
                              Expanded(
                                flex: 1,
                                child: Text("Biaya Konstruksi", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.black54),),
                              ),
                              Padding(padding: EdgeInsets.only(left: 10.0),),
                              Container(
                                child: Text(" : ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.black54),),
                              ),
                              Padding(padding: EdgeInsets.only(left: 10.0),),
                              Expanded(
                                flex: 2,
                                child: Text("${nfr.format(double.parse(dataRuas[index]['BiayaKonstruksi']))}", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.black54),),
                              )
                            ],
                          ),
                          Padding(padding: EdgeInsets.only(top: 8.0),),
                          Row(
                            children: <Widget>[
                              Padding(padding: EdgeInsets.only(left: 20.0),),
                              Expanded(
                                flex: 1,
                                child: Text("Biaya Tanah", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.black54),),
                              ),
                              Padding(padding: EdgeInsets.only(left: 10.0),),
                              Container(
                                child: Text(" : ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.black54),),
                              ),
                              Padding(padding: EdgeInsets.only(left: 10.0),),
                              Expanded(
                                flex: 2,
                                child: Text("${nfr.format(double.parse(dataRuas[index]['BiayaTanah']))}", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.black54),),
                              )
                            ],
                          ),
                          Padding(padding: EdgeInsets.only(top: 8.0),),
                          Row(
                            children: <Widget>[
                              Padding(padding: EdgeInsets.only(left: 20.0),),
                              Expanded(
                                flex: 1,
                                child: Text("Masa Konsesi", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.black54),),
                              ),
                              Padding(padding: EdgeInsets.only(left: 10.0),),
                              Container(
                                child: Text(" : ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.black54),),
                              ),
                              Padding(padding: EdgeInsets.only(left: 10.0),),
                              Expanded(
                                flex: 2,
                                child: Text("${dataRuas[index]['MasaKonsesi']} Tahun", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.black54),),
                              )
                            ],
                          ),
                          Padding(padding: EdgeInsets.only(top: 8.0),),
                          Row(
                            children: <Widget>[
                              Padding(padding: EdgeInsets.only(left: 20.0),),
                              Expanded(
                                flex: 1,
                                child: Text("Tarif Tol", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.black54),),
                              ),
                              Padding(padding: EdgeInsets.only(left: 10.0),),
                              Container(
                                child: Text(" : ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.black54),),
                              ),
                              Padding(padding: EdgeInsets.only(left: 10.0),),
                              Expanded(
                                flex: 2,
                                child: Text("Rp. ${dataRuas[index]['TarifTol']}/Km", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.black54),),
                              )
                            ],
                          ),
                          Padding(padding: EdgeInsets.only(top: 8.0),),
                          Row(
                            children: <Widget>[
                              Padding(padding: EdgeInsets.only(left: 20.0),),
                              Expanded(
                                flex: 1,
                                child: Text("SPMK", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.black54),),
                              ),
                              Padding(padding: EdgeInsets.only(left: 10.0),),
                              Container(
                                child: Text(" : ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.black54),),
                              ),
                              Padding(padding: EdgeInsets.only(left: 10.0),),
                              Expanded(
                                flex: 2,
                                child: Text("${dataRuas[index]['spmk']}", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.black54),),
                              )
                            ],
                          ),
                          Padding(padding: EdgeInsets.only(top: 8.0),),
                          Row(
                            children: <Widget>[
                              Padding(padding: EdgeInsets.only(left: 20.0),),
                              Expanded(
                                flex: 1,
                                child: Text("Tenaga Kerja BUJT", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.black54),),
                              ),
                              Padding(padding: EdgeInsets.only(left: 10.0),),
                              Container(
                                child: Text(" : ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.black54),),
                              ),
                              Padding(padding: EdgeInsets.only(left: 10.0),),
                              Expanded(
                                flex: 2,
                                child: Text("${dataRuas[index]['tenaga_kerja_bujt']}", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.black54),),
                              )
                            ],
                          ),
                          Padding(padding: EdgeInsets.only(bottom: 50.0),),
                        ],
                      ),
                    );
                  },
                ) : Center(
                  child: CircularProgressIndicator(),
                ),
              )
                  :
              btn_ppjt_amdmn == true
                  ?
              Container(
                child: Center(
                  child: Text("Amandemen"),
                ),
              )
                  :
              Container(
                height: 280,
                child: dataRuas.length > 0 ?
                ListView.builder(
                  itemCount: dataRuas.length,
                  itemBuilder: (BuildContext context, int index){
                    return Container(
                      padding: EdgeInsets.only(left: 20, right: 20),
                      child: Column(
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Padding(padding: EdgeInsets.only(left: 20.0),),
                              Expanded(
                                flex: 1,
                                child: Text("Panjang Total", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.black54),),
                              ),
                              Padding(padding: EdgeInsets.only(left: 10.0),),
                              Container(
                                child: Text(" : ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.black54),),
                              ),
                              Padding(padding: EdgeInsets.only(left: 10.0),),
                              Expanded(
                                flex: 2,
                                child: Text("${dataRuas[index]['Panjang']} Km", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.black54),),
                              )
                            ],
                          ),
                          Padding(padding: EdgeInsets.only(top: 8.0),),
                          Row(
                            children: <Widget>[
                              Padding(padding: EdgeInsets.only(left: 20.0),),
                              Expanded(
                                flex: 1,
                                child: Text("Panjang Konstruksi", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.black54),),
                              ),
                              Padding(padding: EdgeInsets.only(left: 10.0),),
                              Container(
                                child: Text(" : ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.black54),),
                              ),
                              Padding(padding: EdgeInsets.only(left: 10.0),),
                              Expanded(
                                flex: 2,
                                child: Text("${dataRuas[index]['Panjang_kontruksi']} Km", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.black54),),
                              )
                            ],
                          ),
                          Padding(padding: EdgeInsets.only(top: 8.0),),
                          Row(
                            children: <Widget>[
                              Padding(padding: EdgeInsets.only(left: 20.0),),
                              Expanded(
                                flex: 1,
                                child: Text("Panjang Operasi", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.black54),),
                              ),
                              Padding(padding: EdgeInsets.only(left: 10.0),),
                              Container(
                                child: Text(" : ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.black54),),
                              ),
                              Padding(padding: EdgeInsets.only(left: 10.0),),
                              Expanded(
                                flex: 2,
                                child: Text("${dataRuas[index]['Panjang_operasi']} Km", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.black54),),
                              )
                            ],
                          ),
                          Padding(padding: EdgeInsets.only(top: 8.0),),
                          Row(
                            children: <Widget>[
                              Padding(padding: EdgeInsets.only(left: 20.0),),
                              Expanded(
                                flex: 1,
                                child: Text("Jumlah Seksi", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.black54),),
                              ),
                              Padding(padding: EdgeInsets.only(left: 10.0),),
                              Container(
                                child: Text(" : ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.black54),),
                              ),
                              Padding(padding: EdgeInsets.only(left: 10.0),),
                              Expanded(
                                flex: 2,
                                child: Text("${dataRuas[index]['JumlahSeksi']} Seksi", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.black54),),
                              )
                            ],
                          ),
                          Padding(padding: EdgeInsets.only(top: 8.0),),
                          Row(
                            children: <Widget>[
                              Padding(padding: EdgeInsets.only(left: 20.0),),
                              Expanded(
                                flex: 1,
                                child: Text("LHR dalam PPJT", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.black54),),
                              ),
                              Padding(padding: EdgeInsets.only(left: 10.0),),
                              Container(
                                child: Text(" : ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.black54),),
                              ),
                              Padding(padding: EdgeInsets.only(left: 10.0),),
                              Expanded(
                                flex: 2,
                                child: Text("${dataRuas[index]['JumlahKendaraanPerhari']}", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.black54),),
                              )
                            ],
                          ),
                          Padding(padding: EdgeInsets.only(top: 8.0),),
                          Row(
                            children: <Widget>[
                              Padding(padding: EdgeInsets.only(left: 20.0),),
                              Expanded(
                                flex: 1,
                                child: Text("Target Operasi PPJT", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.black54),),
                              ),
                              Padding(padding: EdgeInsets.only(left: 10.0),),
                              Container(
                                child: Text(" : ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.black54),),
                              ),
                              Padding(padding: EdgeInsets.only(left: 10.0),),
                              Expanded(
                                flex: 2,
                                child: Text("${dataRuas[index]['TargetOperasi']}", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.black54),),
                              )
                            ],
                          ),
                          Padding(padding: EdgeInsets.only(top: 8.0),),
                          Row(
                            children: <Widget>[
                              Padding(padding: EdgeInsets.only(left: 20.0),),
                              Expanded(
                                flex: 1,
                                child: Text("Biaya Investasi", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.black54),),
                              ),
                              Padding(padding: EdgeInsets.only(left: 10.0),),
                              Container(
                                child: Text(" : ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.black54),),
                              ),
                              Padding(padding: EdgeInsets.only(left: 10.0),),
                              Expanded(
                                flex: 2,
                                child: Text("${nfr.format(double.parse(dataRuas[index]['BiayaInvestasi']))}", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.black54),),
                              )
                            ],
                          ),
                          Padding(padding: EdgeInsets.only(top: 8.0),),
                          Row(
                            children: <Widget>[
                              Padding(padding: EdgeInsets.only(left: 20.0),),
                              Expanded(
                                flex: 1,
                                child: Text("Biaya Konstruksi", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.black54),),
                              ),
                              Padding(padding: EdgeInsets.only(left: 10.0),),
                              Container(
                                child: Text(" : ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.black54),),
                              ),
                              Padding(padding: EdgeInsets.only(left: 10.0),),
                              Expanded(
                                flex: 2,
                                child: Text("${nfr.format(double.parse(dataRuas[index]['BiayaKonstruksi']))}", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.black54),),
                              )
                            ],
                          ),
                          Padding(padding: EdgeInsets.only(top: 8.0),),
                          Row(
                            children: <Widget>[
                              Padding(padding: EdgeInsets.only(left: 20.0),),
                              Expanded(
                                flex: 1,
                                child: Text("Biaya Tanah", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.black54),),
                              ),
                              Padding(padding: EdgeInsets.only(left: 10.0),),
                              Container(
                                child: Text(" : ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.black54),),
                              ),
                              Padding(padding: EdgeInsets.only(left: 10.0),),
                              Expanded(
                                flex: 2,
                                child: Text("${nfr.format(double.parse(dataRuas[index]['BiayaTanah']))}", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.black54),),
                              )
                            ],
                          ),
                          Padding(padding: EdgeInsets.only(top: 8.0),),
                          Row(
                            children: <Widget>[
                              Padding(padding: EdgeInsets.only(left: 20.0),),
                              Expanded(
                                flex: 1,
                                child: Text("Masa Konsesi", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.black54),),
                              ),
                              Padding(padding: EdgeInsets.only(left: 10.0),),
                              Container(
                                child: Text(" : ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.black54),),
                              ),
                              Padding(padding: EdgeInsets.only(left: 10.0),),
                              Expanded(
                                flex: 2,
                                child: Text("${dataRuas[index]['MasaKonsesi']} Tahun", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.black54),),
                              )
                            ],
                          ),
                          Padding(padding: EdgeInsets.only(top: 8.0),),
                          Row(
                            children: <Widget>[
                              Padding(padding: EdgeInsets.only(left: 20.0),),
                              Expanded(
                                flex: 1,
                                child: Text("Tarif Tol", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.black54),),
                              ),
                              Padding(padding: EdgeInsets.only(left: 10.0),),
                              Container(
                                child: Text(" : ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.black54),),
                              ),
                              Padding(padding: EdgeInsets.only(left: 10.0),),
                              Expanded(
                                flex: 2,
                                child: Text("Rp. ${dataRuas[index]['TarifTol']}/Km", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.black54),),
                              )
                            ],
                          ),
                          Padding(padding: EdgeInsets.only(top: 8.0),),
                          Row(
                            children: <Widget>[
                              Padding(padding: EdgeInsets.only(left: 20.0),),
                              Expanded(
                                flex: 1,
                                child: Text("SPMK", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.black54),),
                              ),
                              Padding(padding: EdgeInsets.only(left: 10.0),),
                              Container(
                                child: Text(" : ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.black54),),
                              ),
                              Padding(padding: EdgeInsets.only(left: 10.0),),
                              Expanded(
                                flex: 2,
                                child: Text("${dataRuas[index]['spmk']}", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.black54),),
                              )
                            ],
                          ),
                          Padding(padding: EdgeInsets.only(top: 8.0),),
                          Row(
                            children: <Widget>[
                              Padding(padding: EdgeInsets.only(left: 20.0),),
                              Expanded(
                                flex: 1,
                                child: Text("Tenaga Kerja BUJT", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.black54),),
                              ),
                              Padding(padding: EdgeInsets.only(left: 10.0),),
                              Container(
                                child: Text(" : ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.black54),),
                              ),
                              Padding(padding: EdgeInsets.only(left: 10.0),),
                              Expanded(
                                flex: 2,
                                child: Text("${dataRuas[index]['tenaga_kerja_bujt']}", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.black54),),
                              )
                            ],
                          ),
                          Padding(padding: EdgeInsets.only(bottom: 50.0),),
                        ],
                      ),
                    );
                  },
                ) : Center(
                  child: CircularProgressIndicator(),
                ),
              )
            ],
          )
        ),
      ),
      ConstrainedBox(
        constraints: const BoxConstraints.expand(),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.black12,
                Colors.white24,
                Colors.white,
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            borderRadius: BorderRadius.only(
                topRight: const Radius.circular(20.0),
                topLeft: const Radius.circular(20.0),
                bottomRight: const Radius.circular(10.0),
                bottomLeft: const Radius.circular(10.0)
            ),
          ),
          child: dataRuasKonst.length > 0
              ? ListView.builder(
            itemCount: dataRuasKonst.length,
            itemBuilder: (BuildContext context, int index){
              return Column(
                children: <Widget>[
                  Container(
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.only(left: 35.0),
                    child: Text("Progres Konstruksi", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87, fontSize: 16),),
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 30, top: 30, right: 30),
                    child: Column(
                      children: [
                        Container(
                          height: 230,
                          child: dataRuasKonstSeksi.length > 0
                              ? ListView.builder(
                            itemCount: dataRuasKonstSeksi.length,
                            itemBuilder: (BuildContext context, int index){
                              if(widget.ruas=="1001"){
                                  nama_seksi = dataRuasKonstSeksi[index]['nama_seksi'];
                                  panjang = dataRuasKonstSeksi[index]['panjang'];
                                  prog_tanah = dataRuasKonstSeksi[index]['progres_tanah_bebas']+"%";
                                  target_opr = dataRuasKonstSeksi[index]['penyelesaian'];
                                  status_prog = "Konstruksi";
                              }
                              else{
                                  nama_seksi = dataRuasKonstSeksi[index]['seksi'];
                                  panjang = dataRuasKonstSeksi[index]['panjang'];
                                  prog_tanah = dataRuasKonstSeksi[index]['LuasTanah'];
                                  target_opr = dataRuasKonstSeksi[index]['target'];

                                  realisasiTanah = dataRuasKonstSeksi[index]['realisasi'];
                                  if(realisasiTanah==null){
                                    valuerealisasiTanah = 0;
                                  }else{
                                    valuerealisasiTanah = double.parse(realisasiTanah)*0.01;
                                  }

                                  rencanaKonst = dataRuasKonstSeksi[index]['rencana'];
                                  if(rencanaKonst==null){
                                    valuerencanaKonst = 0;
                                  }else{
                                    valuerencanaKonst = double.parse(rencanaKonst)*0.01;
                                  }

                                  realisasiKonst = dataRuasKonstSeksi[index]['realisasikonst'];
                                  if(realisasiKonst==null){
                                    valuerealisasiKonst = 0;
                                  }else{
                                    valuerealisasiKonst = double.parse(realisasiKonst)*0.01;
                                  }

                                  deviasi = dataRuasKonstSeksi[index]['deviasi'];
                                  if(deviasi==null){
                                    valuedeviasiKonst = 0;
                                  }else{
                                    valuedeviasiKonst = double.parse(deviasi)* -0.01;
                                  }


                              }
                              return Column(
                                children: [
                                  Container(
                                    height: 240,
                                    child: Column(
                                      children: [
                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text("${nama_seksi}", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),),
                                        ),
                                        Padding(padding: EdgeInsets.only(top: 10)),
                                        Row(
                                          children: [
                                            Expanded(
                                              flex: 1,
                                              child: Text("Panjang", style: TextStyle(fontSize: 10),),
                                            ),
                                            Expanded(
                                              flex: 1,
                                              child: Text(":", style: TextStyle(fontSize: 10),),
                                            ),
                                            Expanded(
                                              flex: 1,
                                              child: Text("${panjang} Km", style: TextStyle(fontSize: 10),),
                                            )
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Expanded(
                                              flex: 1,
                                              child: Text("Luas", style: TextStyle(fontSize: 10),),
                                            ),
                                            Expanded(
                                              flex: 1,
                                              child: Text(":", style: TextStyle(fontSize: 10),),
                                            ),
                                            Expanded(
                                              flex: 1,
                                              child: Text("${prog_tanah}", style: TextStyle(fontSize: 10),),
                                            )
                                          ],
                                        ),
                                        Padding(padding: EdgeInsets.only(top: 10)),
                                        Row(
                                          children: [
                                            Expanded(
                                              flex: 1,
                                              child: Text("Target Operasi", style: TextStyle(fontSize: 10),),
                                            ),
                                            Expanded(
                                              flex: 1,
                                              child: Text(":", style: TextStyle(fontSize: 10),),
                                            ),
                                            Expanded(
                                              flex: 1,
                                              child: Text("${target_opr}", style: TextStyle(fontSize: 10),),
                                            )
                                          ],
                                        ),
                                        Padding(padding: EdgeInsets.only(top: 10)),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Expanded(
                                              flex: 1,
                                              child: Text("Progres Tanah", style: TextStyle(fontSize: 10),),
                                            ),
                                            Expanded(
                                              flex: 1,
                                              child: Text("Progres Konstruksi", style: TextStyle(fontSize: 10),),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Padding(padding: EdgeInsets.only(left: 0)),
                                            SizedBox(
                                              height: 120,
                                              child: Stack(
                                                children: [
                                                  Center(
                                                    child: SizedBox(
                                                      child: CircularProgressIndicator(
                                                        value: valuerealisasiTanah,
                                                        valueColor: AlwaysStoppedAnimation(Colors.greenAccent),
                                                        backgroundColor: Colors.black12,
                                                        strokeWidth: 10,
                                                      ),
                                                      height: 60,
                                                      width: 60,
                                                    ),
                                                  ),
                                                  Container(
                                                    width: 60,
                                                    alignment: Alignment.center,
                                                    child: Text("${realisasiTanah}%", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.greenAccent),),
                                                  ),
                                                  Container(
                                                    width: 60,
                                                    height: 120,
                                                    alignment: Alignment.bottomCenter,
                                                    child: Text("Tanah", style: TextStyle(fontSize: 10),),
                                                  )
                                                ],
                                              ),
                                            ),
                                            Padding(padding: EdgeInsets.only(left: 60)),
                                            SizedBox(
                                              height: 100,
                                              child: Stack(
                                                children: [
                                                  Center(
                                                    child: SizedBox(
                                                      child: CircularProgressIndicator(
                                                        value: valuerencanaKonst,
                                                        valueColor: AlwaysStoppedAnimation(Colors.blue[300]),
                                                        backgroundColor: Colors.black12,
                                                        strokeWidth: 5,
                                                      ),
                                                      height: 40,
                                                      width: 40,
                                                    ),
                                                  ),
                                                  Container(
                                                    width: 40,
                                                    alignment: Alignment.center,
                                                    child: Text("${rencanaKonst}%", style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold, color: Colors.blue[300]),),
                                                  ),
                                                  Container(
                                                    width: 40,
                                                    height: 100,
                                                    alignment: Alignment.bottomCenter,
                                                    child: Text("Rencana", style: TextStyle(fontSize: 9),),
                                                  )
                                                ],
                                              ),
                                            ),
                                            Padding(padding: EdgeInsets.only(right: 5, left: 5)),
                                            SizedBox(
                                              height: 100,
                                              child: Stack(
                                                children: [
                                                  Center(
                                                    child: SizedBox(
                                                      child: CircularProgressIndicator(
                                                        value: valuerealisasiKonst,
                                                        valueColor: AlwaysStoppedAnimation(Colors.yellow[600]),
                                                        backgroundColor: Colors.black12,
                                                        strokeWidth: 5,
                                                      ),
                                                      height: 40,
                                                      width: 40,
                                                    ),
                                                  ),
                                                  Container(
                                                    width: 40,
                                                    alignment: Alignment.center,
                                                    child: Text("${realisasiKonst}%", style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold, color: Colors.yellow[600]),),
                                                  ),
                                                  Container(
                                                    width: 40,
                                                    height: 100,
                                                    alignment: Alignment.bottomCenter,
                                                    child: Text("Realisasi", style: TextStyle(fontSize: 9),),
                                                  )
                                                ],
                                              ),
                                            ),
                                            Padding(padding: EdgeInsets.only(right: 10)),
                                            SizedBox(
                                              height: 100,
                                              child: Stack(
                                                children: [
                                                  Center(
                                                    child: SizedBox(
                                                      child: CircularProgressIndicator(
                                                        value: valuedeviasiKonst,
                                                        valueColor: AlwaysStoppedAnimation(Colors.red),
                                                        backgroundColor: Colors.black12,
                                                        strokeWidth: 5,
                                                      ),
                                                      height: 40,
                                                      width: 40,
                                                    ),
                                                  ),
                                                  Container(
                                                    width: 40,
                                                    alignment: Alignment.center,
                                                    child: Text("${deviasi}%", style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold, color: Colors.red),),
                                                  ),
                                                  Container(
                                                    width: 40,
                                                    height: 100,
                                                    alignment: Alignment.bottomCenter,
                                                    child: Text("Deviasi", style: TextStyle(fontSize: 9),),
                                                  )
                                                ],
                                              ),
                                            ),
                                            Padding(padding: EdgeInsets.only(right: 10)),
                                          ],
                                        ),
                                        Padding(padding: EdgeInsets.only(top: 20)),
                                      ],
                                    ),
                                  ),
                                ],
                              );
                            },
                          )
                              : Container(
                            child: Center(
                              child: CircularProgressIndicator(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 30, right: 30),
                    child: Row(
                      children: [
                        Expanded(
                          child: OutlineButton(
                            borderSide: BorderSide(
                                color: col_utama
                            ),
                            onPressed: (){
                              setState(() {
                                btn_utama = true;
                                btn_elevated = false;
                                col_utama = Colors.black87;
                                col_lelevated = Colors.black38;
                              });
                            },
                            child: Text("Pekerjaan Utama", style: TextStyle(fontSize: 11, color: col_utama),),
                          ),
                        ),
                        Padding(padding: EdgeInsets.only(left: 5, right: 5)),
                        Expanded(
                            child: OutlineButton(
                              borderSide: BorderSide(
                                  color: col_lelevated
                              ),
                              onPressed: (){
                                setState(() {
                                  btn_utama = false;
                                  btn_elevated = true;
                                  col_utama = Colors.black38;
                                  col_lelevated = Colors.black87;
                                });
                              },
                              child: Text("Pekerjaan Elevated", style: TextStyle(fontSize: 11, color: col_lelevated),),
                            )
                        ),
                      ],
                    ),
                  ),
                  btn_utama == true
                      ?
                  Container(
                    height: 400,
                    child: Column(
                      children: [
                        Container(
                          alignment: Alignment.centerLeft,
                          padding: EdgeInsets.only(left: 35.0, top: 20.0),
                          child: Text("Progres Pekerjaan Utama", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),),
                        ),
                        Padding(padding: EdgeInsets.only(top: 20.0),),
                        Container(
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                flex: 1,
                                child: Padding(
                                  padding: EdgeInsets.only(left: 40, top: 10),
                                  child: Image.network('http://i_cons.bpjt.pu.go.id/image/overpass.png', width: 10, color: Colors.lightBlue,),
                                ),
                              ),
                              Padding(padding: EdgeInsets.only(left: 40),),
                              Expanded(
                                flex: 3,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Container(
                                      padding: EdgeInsets.only(left: 35),
                                      alignment: Alignment.centerLeft,
                                      child: Text("Overpass", style: TextStyle(fontWeight: FontWeight.bold),),
                                    ),
                                    Padding(padding: EdgeInsets.only(top: 6),),
                                    Container(
                                      padding: EdgeInsets.only(left: 35),
                                      alignment: Alignment.centerLeft,
                                      child: Text("${dataRuasKonst[index]['progres_selesai_overpass']} dari ${dataRuasKonst[index]['progres_struktur_overpass']} buah", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.black54),),
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                        Padding(padding: EdgeInsets.only(top: 10.0),),
                        Container(
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                flex: 1,
                                child: Padding(
                                  padding: EdgeInsets.only(left: 40, top: 10),
                                  child: Image.network('http://i_cons.bpjt.pu.go.id/image/underpass.png', width: 10, color: Colors.lightBlue,),
                                ),
                              ),
                              Padding(padding: EdgeInsets.only(left: 40),),
                              Expanded(
                                flex: 3,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Container(
                                      padding: EdgeInsets.only(left: 35),
                                      alignment: Alignment.centerLeft,
                                      child: Text("Underpass", style: TextStyle(fontWeight: FontWeight.bold),),
                                    ),
                                    Padding(padding: EdgeInsets.only(top: 6),),
                                    Container(
                                      padding: EdgeInsets.only(left: 35),
                                      alignment: Alignment.centerLeft,
                                      child: Text("${dataRuasKonst[index]['progres_selesai_underpass']} dari ${dataRuasKonst[index]['progres_struktur_underpass']} buah", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.black54),),
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                        Padding(padding: EdgeInsets.only(top: 10.0),),
                        Container(
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                flex: 1,
                                child: Padding(
                                  padding: EdgeInsets.only(left: 40, top: 10),
                                  child: Image.network('http://i_cons.bpjt.pu.go.id/image/jembatan.png', width: 10, color: Colors.lightBlue,),
                                ),
                              ),
                              Padding(padding: EdgeInsets.only(left: 40),),
                              Expanded(
                                flex: 3,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Container(
                                      padding: EdgeInsets.only(left: 35),
                                      alignment: Alignment.centerLeft,
                                      child: Text("Jembatan", style: TextStyle(fontWeight: FontWeight.bold),),
                                    ),
                                    Padding(padding: EdgeInsets.only(top: 6),),
                                    Container(
                                      padding: EdgeInsets.only(left: 35),
                                      alignment: Alignment.centerLeft,
                                      child: Text("${dataRuasKonst[index]['progres_selesai_jembatan']} dari ${dataRuasKonst[index]['progres_struktur_jembatan']} buah", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.black54),),
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                        Padding(padding: EdgeInsets.only(top: 10.0),),
                        Container(
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                flex: 1,
                                child: Padding(
                                  padding: EdgeInsets.only(left: 40, top: 10),
                                  child: Image.network('http://i_cons.bpjt.pu.go.id/image/box_culvert.png', width: 10, color: Colors.lightBlue,),
                                ),
                              ),
                              Padding(padding: EdgeInsets.only(left: 40),),
                              Expanded(
                                flex: 3,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Container(
                                      padding: EdgeInsets.only(left: 35),
                                      alignment: Alignment.centerLeft,
                                      child: Text("Box Culvert", style: TextStyle(fontWeight: FontWeight.bold),),
                                    ),
                                    Padding(padding: EdgeInsets.only(top: 6),),
                                    Container(
                                      padding: EdgeInsets.only(left: 35),
                                      alignment: Alignment.centerLeft,
                                      child: Text("${dataRuasKonst[index]['progres_selesai_box_culvert']} dari ${dataRuasKonst[index]['progres_struktur_box_culvert']} buah", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.black54),),
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                        Padding(padding: EdgeInsets.only(top: 10.0),),
                        Container(
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                flex: 1,
                                child: Padding(
                                  padding: EdgeInsets.only(left: 40, top: 10),
                                  child: Image.network('http://i_cons.bpjt.pu.go.id/image/sm2.png', width: 10, color: Colors.lightBlue,),
                                ),
                              ),
                              Padding(padding: EdgeInsets.only(left: 40),),
                              Expanded(
                                flex: 3,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Container(
                                      padding: EdgeInsets.only(left: 35),
                                      alignment: Alignment.centerLeft,
                                      child: Text("Simpang Susun", style: TextStyle(fontWeight: FontWeight.bold),),
                                    ),
                                    Padding(padding: EdgeInsets.only(top: 6),),
                                    Container(
                                      padding: EdgeInsets.only(left: 35),
                                      alignment: Alignment.centerLeft,
                                      child: Text("${dataRuasKonst[index]['progres_selesai_simpang']} dari ${dataRuasKonst[index]['progres_struktur_simpang']} buah", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.black54),),
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                        Padding(padding: EdgeInsets.only(top: 20.0),),
                      ],
                    ),
                  )
                      :
                  Container(
                    padding: EdgeInsets.only(left: 30),
                    child: Column(
                      children: [
                        Padding(padding: EdgeInsets.only(top: 20)),
                        Container(
                          alignment: Alignment.centerLeft,
                          child: Text("Girder (PCU/I Girder/Box Girder)", style: TextStyle(fontWeight: FontWeight.bold),),
                        ),
                        Padding(padding: EdgeInsets.only(top: 5)),
                        Row(
                          children: [
                            Expanded(
                              child: Text("Jalan Utama", style: TextStyle(fontSize: 11),),
                            ),
                            Expanded(
                              child: Text(".... buah", style: TextStyle(fontSize: 11),),
                            )
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Text("Jalur Ramp", style: TextStyle(fontSize: 11),),
                            ),
                            Expanded(
                              child: Text(".... buah", style: TextStyle(fontSize: 11),),
                            )
                          ],
                        ),
                        Padding(padding: EdgeInsets.only(top: 10)),
                        Container(
                          alignment: Alignment.centerLeft,
                          child: Text("Slab", style: TextStyle(fontWeight: FontWeight.bold),),
                        ),
                        Padding(padding: EdgeInsets.only(top: 5)),
                        Row(
                          children: [
                            Expanded(
                              child: Text("Jalan Utama", style: TextStyle(fontSize: 11),),
                            ),
                            Expanded(
                              child: Text(".... buah", style: TextStyle(fontSize: 11),),
                            )
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Text("Jalur Ramp", style: TextStyle(fontSize: 11),),
                            ),
                            Expanded(
                              child: Text(".... buah", style: TextStyle(fontSize: 11),),
                            )
                          ],
                        ),
                        Padding(padding: EdgeInsets.only(top: 10)),
                        Container(
                          alignment: Alignment.centerLeft,
                          child: Text("LRB", style: TextStyle(fontWeight: FontWeight.bold),),
                        ),
                        Padding(padding: EdgeInsets.only(top: 5)),
                        Row(
                          children: [
                            Expanded(
                              child: Text("Jalan Utama", style: TextStyle(fontSize: 11),),
                            ),
                            Expanded(
                              child: Text(".... buah", style: TextStyle(fontSize: 11),),
                            )
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Text("Jalur Ramp", style: TextStyle(fontSize: 11),),
                            ),
                            Expanded(
                              child: Text(".... buah", style: TextStyle(fontSize: 11),),
                            )
                          ],
                        ),
                        Padding(padding: EdgeInsets.only(top: 10)),
                        Container(
                          alignment: Alignment.centerLeft,
                          child: Text("Pier Head", style: TextStyle(fontWeight: FontWeight.bold),),
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Text("", style: TextStyle(fontSize: 11),),
                            ),
                            Expanded(
                              child: Text(".... titik", style: TextStyle(fontSize: 11),),
                            )
                          ],
                        ),
                        Padding(padding: EdgeInsets.only(top: 10)),
                        Container(
                          alignment: Alignment.centerLeft,
                          child: Text("Kolom", style: TextStyle(fontWeight: FontWeight.bold),),
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Text("", style: TextStyle(fontSize: 11),),
                            ),
                            Expanded(
                              child: Text(".... titik", style: TextStyle(fontSize: 11),),
                            )
                          ],
                        ),
                        Padding(padding: EdgeInsets.only(top: 10)),
                        Container(
                          alignment: Alignment.centerLeft,
                          child: Text("Pile Cap", style: TextStyle(fontWeight: FontWeight.bold),),
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Text("", style: TextStyle(fontSize: 11),),
                            ),
                            Expanded(
                              child: Text(".... titik", style: TextStyle(fontSize: 11),),
                            )
                          ],
                        ),
                        Padding(padding: EdgeInsets.only(top: 10)),
                        Container(
                          alignment: Alignment.centerLeft,
                          child: Text("Border Pile", style: TextStyle(fontWeight: FontWeight.bold),),
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Text("", style: TextStyle(fontSize: 11),),
                            ),
                            Expanded(
                              child: Text(".... titik", style: TextStyle(fontSize: 11),),
                            )
                          ],
                        ),
                        Padding(padding: EdgeInsets.only(top: 10)),
                        Container(
                          alignment: Alignment.centerLeft,
                          child: Text("Abutment", style: TextStyle(fontWeight: FontWeight.bold),),
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Text("", style: TextStyle(fontSize: 11),),
                            ),
                            Expanded(
                              child: Text(".... titik", style: TextStyle(fontSize: 11),),
                            )
                          ],
                        ),
                        Padding(padding: EdgeInsets.only(bottom: 20)),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 20, right: 20),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black12,
                        borderRadius: BorderRadius.only(
                            topRight: const Radius.circular(10.0),
                            topLeft: const Radius.circular(10.0),
                            bottomRight: const Radius.circular(10.0),
                            bottomLeft: const Radius.circular(10.0)
                        ),
                      ),
                      padding: EdgeInsets.only(top: 15, left: 20, right: 10, bottom: 15),
                      child: Column(
                        children: <Widget>[
                          Text("Perkerasan Rigid", style: TextStyle(fontWeight: FontWeight.bold),),
                          Container(
                            height: 80,
                            child: chartRigid,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(padding: EdgeInsets.only(top: 10.0),),
                  Padding(
                    padding: EdgeInsets.only(left: 20, right: 20),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black12,
                        borderRadius: BorderRadius.only(
                            topRight: const Radius.circular(10.0),
                            topLeft: const Radius.circular(10.0),
                            bottomRight: const Radius.circular(10.0),
                            bottomLeft: const Radius.circular(10.0)
                        ),
                      ),
                      padding: EdgeInsets.only(top: 15, left: 20, right: 10, bottom: 15),
                      child: Column(
                        children: <Widget>[
                          Text("Perkerasan Fleksible", style: TextStyle(fontWeight: FontWeight.bold),),
                          Container(
                            height: 80,
                            child: chartSubbase,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(padding: EdgeInsets.only(top: 10.0),),
                  Padding(
                    padding: EdgeInsets.only(left: 20, right: 20),
                    child: Container(
                      padding: EdgeInsets.only(top: 15, bottom: 15),
                      child: Column(
                        children: <Widget>[
                          Text("Pekerjaan Tanah", style: TextStyle(fontWeight: FontWeight.bold),),
                          Padding(padding: EdgeInsets.only(top: 10),),
                          Container(
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  child: Column(
                                    children: <Widget>[
                                      Text("Galian", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11),),
                                      Padding(padding: EdgeInsets.only(top: 5),),
                                      Container(
                                        alignment: Alignment.center,
                                        width: double.infinity,
                                        padding: EdgeInsets.only(top: 10, bottom: 10, left: 10, right: 10),
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                              colors: [
                                                Color(0xffc4f8ef),
                                                Color(0xffe4f1cb),
                                                Color(0xffffffe1)
                                              ],
                                              begin: Alignment.centerLeft,
                                              end: Alignment.centerRight
                                          ),
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        child: Text("${selGalian} dari ${totalGalian}", style: TextStyle(color: Colors.black38, fontWeight: FontWeight.bold),),
                                      )
                                    ],
                                  ),
                                ),
                                Padding(padding: EdgeInsets.only(left: 5, right: 5),),
                                Expanded(
                                  child: Column(
                                    children: <Widget>[
                                      Text("Timbunan", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11),),
                                      Padding(padding: EdgeInsets.only(top: 5),),
                                      Container(
                                        alignment: Alignment.center,
                                        width: double.infinity,
                                        padding: EdgeInsets.only(top: 10, bottom: 10, left: 10, right: 10),
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                              colors: [
                                                Color(0xffffddbd),
                                                Color(0xffffffe1),
                                                Color(0xffe4f1cb)
                                              ],
                                              begin: Alignment.centerLeft,
                                              end: Alignment.centerRight
                                          ),
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        child: Text("${selTimbunan} dari ${totalTimbunan}", style: TextStyle(color: Colors.black38, fontWeight: FontWeight.bold),),
                                      )
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
                  Padding(padding: EdgeInsets.only(top: 40.0),),
                ],
              );
            },
          )
              : Center(
            child: CircularProgressIndicator(),
          ),
        ),
      ),
      ConstrainedBox(
        constraints: const BoxConstraints.expand(),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.black12,
                Colors.white24,
                Colors.white,
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            borderRadius: BorderRadius.only(
                topRight: const Radius.circular(20.0),
                topLeft: const Radius.circular(20.0),
                bottomRight: const Radius.circular(10.0),
                bottomLeft: const Radius.circular(10.0)
            ),
          ),
          child: Column(
            children: <Widget>[
              Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.only(left: 35.0, top: 20.0),
                child: Text("Drone/Gambar", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87, fontSize: 16),),
              ),
              Container(
                height: 330,
                child: dataDrone.length > 0
                    ? ListView.builder(
                  itemCount: dataDrone.length,
                  itemBuilder: (BuildContext context, int index){
                    return Container(
                      child: GestureDetector(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(
                              builder: (context) => DroneViePage(
                                judulVideo: "${dataDrone[index]['kegiatan']}",
                                urlVideo: "http://i_cons.bpjt.pu.go.id/file_uploads/drone/${dataDrone[index]['drone']}",
                              )
                          ));
                        },
                        child: Row(
                          children: <Widget>[
                            Container(
                              width: 80,
                              child: Padding(
                                padding: EdgeInsets.only(left: 20, top: 10),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.asset('assets/icon/drone.png', color: Colors.black38,),
                                ),
                              ),
                            ),
                            Padding(padding: EdgeInsets.only(left: 10),),
                            Expanded(
                              flex: 3,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                    padding: EdgeInsets.only(left: 10),
                                    alignment: Alignment.centerLeft,
                                    child: Text("${dataDrone[index]['kegiatan']}", style: TextStyle(fontWeight: FontWeight.bold),),
                                  ),
                                  Padding(padding: EdgeInsets.only(top: 6),),
                                  // Container(
                                  //   padding: EdgeInsets.only(left: 10),
                                  //   alignment: Alignment.centerLeft,
                                  //   child: Text("Drone Lokasi Paket 2", style: TextStyle(fontSize: 12, color: Colors.black54),),
                                  // ),
                                  Container(
                                    padding: EdgeInsets.only(left: 10),
                                    alignment: Alignment.centerLeft,
                                    child: Text("${dataDrone[index]['Tanggal_upload']}", style: TextStyle(fontSize: 12, color: Colors.black54),),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  },
                ) : Container(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
              ),
              Padding(padding: EdgeInsets.only(top: 10.0),),

            ],
          ),
        ),
      ),
    ];

    final List<Widget> _pagesTransSumatera = <Widget>[

    ];

    // TODO: implement build
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(padding: EdgeInsets.only(top: 50),),
            Container(
              padding: EdgeInsets.only(left: 35, right: 35),
              child: Center(
                child: Text("${widget.nama_ruas}", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),),
              ),
            ),
            Padding(padding: EdgeInsets.only(top: 5),),
            GestureDetector(
              onTap: (){
                setState(() {
                  if(isFilter==false){
                    this.isFilter = true;
                  }else{
                    this.isFilter = false;
                  }
                  _filterRegionTJ();
                });
              },
              child: Icon(Icons.list, color: Colors.blue[800],),
            ),
            Container(
              child: !isFilter
                  ? Container(height: 0,)
                  : Container(
                child:  widget.id_region=="1"
                    ? Container(
                  height: 163,
                  child: ListView.builder(
                    itemCount: filterSearch.length,
                    itemBuilder: (BuildContext context, int index){
                      return Column(
                        children: <Widget>[
                          GestureDetector(
                            onTap: (){
                              Route myRoute = MaterialPageRoute(builder: (context) => DetailRuas(
                                  ruas: "${filterSearch[index]['id_ruas']}",
                                  nama_ruas: "${filterSearch[index]['NamaRuas']}",
                                  id_region: "${widget.id_region}",
                                  url_region: "${widget.url_region}",
                                  frompage: "${widget.frompage}"
                              ));
                              Navigator.pushReplacement(context, myRoute);
                            },
                            child: Row(
                              children: <Widget>[
                                Padding(padding: EdgeInsets.only(left: 30)),
                                Icon(Icons.arrow_right, color: Colors.blue,),
                                Expanded(
                                  child: Text("${filterSearch[index]['NamaRuas']}", style: TextStyle(color: Colors.blue),),
                                ),
                                Padding(padding: EdgeInsets.only(right: 30)),
                              ],
                            ),
                          )
                        ],
                      );
                    },
                  ),
                )
                    : widget.id_region=="2"
                    ? Container(
                  height: 163,
                  child: ListView.builder(
                    itemCount: filterSearch.length,
                    itemBuilder: (BuildContext context, int index){
                      return Column(
                        children: <Widget>[
                          GestureDetector(
                            onTap: (){
                              Route myRoute = MaterialPageRoute(builder: (context) => DetailRuas(
                                  ruas: "${filterSearch[index]['id_ruas']}",
                                  nama_ruas: "${filterSearch[index]['NamaRuas']}",
                                  id_region: "${widget.id_region}",
                                  url_region: "${widget.url_region}",
                                  frompage: "${widget.frompage}"
                              ));
                              Navigator.pushReplacement(context, myRoute);
                            },
                            child: Row(
                              children: <Widget>[
                                Padding(padding: EdgeInsets.only(left: 30)),
                                Icon(Icons.arrow_right, color: Colors.blue,),
                                Expanded(
                                  child: Text("${filterSearch[index]['NamaRuas']}", style: TextStyle(color: Colors.blue),),
                                ),
                                Padding(padding: EdgeInsets.only(right: 30)),
                              ],
                            ),
                          )
                        ],
                      );
                    },
                  ),
                )
                    : widget.id_region=="3"
                    ? Container(
                  height: 163,
                  child: ListView.builder(
                    itemCount: filterSearch.length,
                    itemBuilder: (BuildContext context, int index){
                      return Column(
                        children: <Widget>[
                          GestureDetector(
                            onTap: (){
                              Route myRoute = MaterialPageRoute(builder: (context) => DetailRuas(
                                  ruas: "${filterSearch[index]['id_ruas']}",
                                  nama_ruas: "${filterSearch[index]['NamaRuas']}",
                                  id_region: "${widget.id_region}",
                                  url_region: "${widget.url_region}",
                                  frompage: "${widget.frompage}"
                              ));
                              Navigator.pushReplacement(context, myRoute);
                            },
                            child: Row(
                              children: <Widget>[
                                Padding(padding: EdgeInsets.only(left: 30)),
                                Icon(Icons.arrow_right, color: Colors.blue,),
                                Expanded(
                                  child: Text("${filterSearch[index]['NamaRuas']}", style: TextStyle(color: Colors.blue),),
                                ),
                                Padding(padding: EdgeInsets.only(right: 30)),
                              ],
                            ),
                          )
                        ],
                      );
                    },
                  ),
                )
                    : widget.id_region=="4"
                    ? Container(
                  height: 163,
                  child: ListView.builder(
                    itemCount: filterSearch.length,
                    itemBuilder: (BuildContext context, int index){
                      return Column(
                        children: <Widget>[
                          GestureDetector(
                            onTap: (){
                              Route myRoute = MaterialPageRoute(builder: (context) => DetailRuas(
                                ruas: "${filterSearch[index]['id_ruas']}",
                                nama_ruas: "${filterSearch[index]['NamaRuas']}",
                                id_region: "${widget.id_region}",
                                url_region: "${widget.url_region}",
                                frompage: "${widget.frompage}"
                              ));
                              Navigator.pushReplacement(context, myRoute);
                            },
                            child: Row(
                              children: <Widget>[
                                Padding(padding: EdgeInsets.only(left: 30)),
                                Icon(Icons.arrow_right, color: Colors.blue,),
                                Expanded(
                                  child: Text("${filterSearch[index]['NamaRuas']}", style: TextStyle(color: Colors.blue),),
                                ),
                                Padding(padding: EdgeInsets.only(right: 30)),
                              ],
                            ),
                          )
                        ],
                      );
                    },
                  ),
                )
                    : Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height*0.32,
              padding: EdgeInsets.only(left: 5, right: 5),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(0),
                child: dataRuas.length > 0
                    ? ListView.builder(
                  itemCount: dataRuas.length,
                  itemBuilder: (BuildContext context, int index){
                    return dataRuas[index]['id_ruas']=="1001"
                        ? Image.network('http://fds-management.com/peta_pettarani.png', height: 230,)
                        : Image.network('http://i_cons.bpjt.pu.go.id/assets/image/peta/${dataRuas[index]['Peta']}', height: 230,);
                  },
                ) : Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            ),
            Padding(padding: EdgeInsets.only(top: 30),),
            Container(
              padding: EdgeInsets.only(left: 25, right: 25),
              height: 400,
              child: Stack(
                children: <Widget>[
                  PageView.builder(
                      physics: AlwaysScrollableScrollPhysics(),
                      controller: _controller,
                      itemBuilder: (BuildContext context, int index){
                        return _pagesPJG_PMLG[index % _pagesPJG_PMLG.length];
                      }
                  ),
                  Positioned(
                    bottom: -20.0,
                    left: 0.0,
                    right: 0.0,
                    child: Container(
                      // color: Colors.grey[800].withOpacity(0.5),
                      padding: const EdgeInsets.all(20.0),
                      child: Center(
                        child: DotsIndicator(
                          controller: _controller,
                          itemCount: _pagesPJG_PMLG.length,
                          onPageSelected: (int page){
                            _controller.animateToPage(page, duration: _kDuration, curve: _kCurve);
                          },
                        ),
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

}

class Konstruksi {
  final String xaxis;
  final int yaxis;
  final charts.Color color;

  Konstruksi(this.xaxis, this.yaxis, Color color)
      : this.color=charts.Color(r: color.red,g: color.green,b: color.blue,a: color.alpha);

}

class Sales {
  final String day;
  var sold;
  final charts.Color color;

  Sales(this.day, this.sold, Color color)
      : this.color=charts.Color(r: color.red,g: color.green,b: color.blue,a: color.alpha);

}
