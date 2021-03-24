import 'package:flutter/material.dart';
import 'package:niagapos_pro/models/tokoTransaksiModel.dart';
import 'package:niagapos_pro/services/tokoTransaksiServices.dart';
import 'package:niagapos_pro/views/customer/adapters/itemTransaksi.dart';
import 'package:niagapos_pro/views/toko/adapters/itemTokoTransaksi.dart';

class TransaksiTokoView extends StatefulWidget{
  @override
  _TransaksiTokoState createState() => _TransaksiTokoState();
}

class _TransaksiTokoState extends State<TransaksiTokoView> {

  Color themeColor = Color(0xff2bcfb1);

  List fil_search = [];
  List<TokoTransaksiModel> dataTransaksi = new List();
  void getDatatransaksi() {
    TokoTransaksiServices().getAllTransaksi().then((value) {
      print("Di View Transaksi ${value}");
      setState(() {
        dataTransaksi = fil_search = value;
      });
    });
  }

  void _filtransaksi(value) {
    setState(() {
      fil_search = dataTransaksi.where((ord) =>
          ord.status.toLowerCase().contains(value.toLowerCase()))
          .toList();
    });
  }

  void _fillClear(){
    setState(() {
      fil_search = dataTransaksi;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDatatransaksi();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("Transaksi", style: TextStyle(fontWeight: FontWeight.bold),),
        backgroundColor: themeColor,
        elevation: 0,
      ),
      body: SafeArea(
        child: Container(
          child: Column(
            children: [
              Padding(padding: EdgeInsets.only(top: 20)),
              Container(
                height: 80,
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: FlatButton(
                        onPressed: (){
                          _fillClear();
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              alignment: Alignment.center,
                              child: Image.asset("assets/icontransaksi/all.png", width: 32,),
                            ),
                            Padding(padding: EdgeInsets.only(top: 8)),
                            Container(
                              alignment: Alignment.center,
                              child: Text("Semua Transaksi", textAlign: TextAlign.center, style: TextStyle(color: Colors.black54, fontSize: 10)),
                            )
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: FlatButton(
                        onPressed: (){
                          _filtransaksi('1');
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              alignment: Alignment.center,
                              child: Image.asset("assets/icontransaksi/konfirmasi.png", width: 32,),
                            ),
                            Padding(padding: EdgeInsets.only(top: 8)),
                            Container(
                              alignment: Alignment.center,
                              child: Text("Konfirmasi Pesanan", textAlign: TextAlign.center, style: TextStyle(color: Colors.black54, fontSize: 10)),
                            )
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: FlatButton(
                        onPressed: (){
                          _filtransaksi('2');
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              alignment: Alignment.center,
                              child: Image.asset("assets/icontransaksi/diproses.png", width: 32,),
                            ),
                            Padding(padding: EdgeInsets.only(top: 8)),
                            Container(
                              alignment: Alignment.center,
                              child: Text("Proses Pesanan", textAlign: TextAlign.center, style: TextStyle(color: Colors.black54, fontSize: 10)),
                            )
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: FlatButton(
                        onPressed: (){
                          _filtransaksi('3');
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              alignment: Alignment.center,
                              child: Image.asset("assets/icontransaksi/dikirim.png", width: 32,),
                            ),
                            Padding(padding: EdgeInsets.only(top: 8)),
                            Container(
                              alignment: Alignment.center,
                              child: Text("Kirim Pesanan", textAlign: TextAlign.center, style: TextStyle(color: Colors.black54, fontSize: 10)),
                            )
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: FlatButton(
                        onPressed: (){
                          _filtransaksi('4');
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              alignment: Alignment.center,
                              child: Image.asset("assets/icontransaksi/selesai.png", width: 32,),
                            ),
                            Padding(padding: EdgeInsets.only(top: 8)),
                            Container(
                              alignment: Alignment.center,
                              child: Text("Pesanan Terkirim", textAlign: TextAlign.center, style: TextStyle(color: Colors.black54, fontSize: 10)),
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.height*0.76,
                child: fil_search.length != null
                    ? ListView.builder(
                        itemCount: fil_search.length,
                        itemBuilder: (context, i){
                          String _idTransaksi = fil_search[i].idTransaksi;
                          String _createAt = fil_search[i].createdAt.toString();
                          String _updateAt = fil_search[i].updatedAt.toString();
                          int _qty = fil_search[i].qtyItem;
                          int _grandTot = fil_search[i].grandTotal;
                          String _payment = fil_search[i].pembayaran;
                          String _status = fil_search[i].status;

                          return ItemTokoTransaksi(idTransaksi: _idTransaksi, createAt: _createAt, updateAt: _updateAt, qty: _qty.toString(), granTot: _grandTot.toString(), payment: _payment,status: _status,);
                        },
                      )
                    : Container(
                        width: 100,
                        child: LinearProgressIndicator(
                          backgroundColor: Colors.greenAccent,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                        ),
                      ),
              )
            ],
          ),
        ),
      ),
    );
  }
}