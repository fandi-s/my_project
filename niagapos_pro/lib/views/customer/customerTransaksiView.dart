import 'package:flutter/material.dart';
import 'package:niagapos_pro/models/customerTransaksiModel.dart';
import 'package:niagapos_pro/services/customerTransaksiService.dart';
import 'package:niagapos_pro/views/customer/adapters/itemTransaksi.dart';

class CustomerTransaksiView extends StatefulWidget{
  @override
  _CustomerTransaksiViewState createState() => _CustomerTransaksiViewState();
}

class _CustomerTransaksiViewState extends State<CustomerTransaksiView> {

  Color themeColor = Color(0xff2bcfb1);

  List fil_search = [];
  List<CustomerTransaksiModel> dataTransaksi = new List();
  void getDatatransaksi() {
    CustomerTransaksiService().getTransaksi().then((value) {
      print("Di View Order ${value}");
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
                          _filtransaksi('0');
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
                              child: Text("Menunggu Konfirmasi", textAlign: TextAlign.center, style: TextStyle(color: Colors.black54, fontSize: 10)),
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
                              child: Text("Pesanan Diproses", textAlign: TextAlign.center, style: TextStyle(color: Colors.black54, fontSize: 10)),
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
                              child: Text("Pesanan Dikirim", textAlign: TextAlign.center, style: TextStyle(color: Colors.black54, fontSize: 10)),
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
                              child: Text("Pesanan Selesai", textAlign: TextAlign.center, style: TextStyle(color: Colors.black54, fontSize: 10)),
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
                child: fil_search != null
                    ? ListView.builder(
                      itemCount: fil_search.length,
                      itemBuilder: (context, i){
                        String _idTransaksi = fil_search[i].idTransaksi;
                        String _createAt = fil_search[i].createdAt.toString();
                        String _updateAt = dataTransaksi[i].updatedAt.toString();
                        int _qty = dataTransaksi[i].qtyItem;
                        int _grandTot = dataTransaksi[i].grandTotal;
                        String _payment = dataTransaksi[i].pembayaran;

                        return ItemTransaksi(idTransaksi: _idTransaksi,createAt: _createAt, updateAt: _updateAt, qty: _qty.toString(), granTot: _grandTot.toString(), payment: _payment,);
                      },
                    ) : Container(
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