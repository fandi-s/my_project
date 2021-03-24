import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:niagapos_pro/models/badgeModel.dart';
import 'package:niagapos_pro/models/customerCartModel.dart';
import 'package:niagapos_pro/models/grandTotalModel.dart';
import 'package:niagapos_pro/services/badgeServices.dart';
import 'package:niagapos_pro/services/customerCartService.dart';
import 'package:niagapos_pro/services/customerTransaksiService.dart';

class CustomerCartView extends StatefulWidget{

  @override
  _CustomerCartState createState() => _CustomerCartState();
}

class _CustomerCartState extends State<CustomerCartView> {

  Color themeColor = Color(0xff2bcfb1);
  int gt;
  int qt;

  List<CustomerCartModel> dataCart = new List();
  void getDataCart() {
    CustomerCartService().getCart().then((value) {
      print("Di View Cart ${value}");
      setState(() {
        dataCart = value;
      });
    });
  }

  List<GrandTotalModel> dataGrandHarga = new List();
  void getGrandHarga(){
    CustomerCartService().grandHarga().then((value){
      setState(() {
        dataGrandHarga = value;
        print("Di View Cart ANJENG ${dataGrandHarga[0].hargaTotal}");
        // print("Di View Badge ${dataGrandHarga[0].kodeToko}");
        if(dataGrandHarga[0].hargaTotal == null){
          gt = 0;
          print("jika null maka : ${gt}");
        }else{
          gt = dataGrandHarga[0].hargaTotal;
          print("jika not a null maka : ${gt}");
        }
      });
    });
  }

  void createTransaksi(String _idTransaksi, int _qtyItem, int _grandTotal, String _pembayaran) {
    CustomerTransaksiService().createTransaksi(_idTransaksi, _qtyItem, _grandTotal, _pembayaran)
        .then((value){
          if(value == true){
            print("Berhasil buat transaksi ${_idTransaksi}");
            Navigator.pushReplacementNamed(context, '/halaman/customer/TransaksiView');
          }else{
            print("Gagal buat transaksi");
          }
        });
  }

  List<BadgeModel> dataBadge = new List();
  void getBadge(){
    BadgeServices().totalQty().then((value){
      setState(() {
        dataBadge = value;
        qt = dataBadge[0].totalQty;
        print("TOTAL QTY : ${qt}");
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDataCart();
    getGrandHarga();
    getBadge();
  }

  String generateRandomString(int len) {
    var r = Random();
    const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    return List.generate(len, (index) => _chars[r.nextInt(_chars.length)]).join();
  }

  @override
  Widget build(BuildContext context) {

    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("Cart", style: TextStyle(fontWeight: FontWeight.bold),),
        backgroundColor: themeColor,
        elevation: 0,
      ),
      body: Container(
        height: double.infinity,
        child: Stack(
          children: [
            Center(
              child: dataCart == null
                  ? Container(
                    width: 100,
                    child: LinearProgressIndicator(
                      backgroundColor: Colors.greenAccent,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                    ),
                  )
                  : ListView.builder(
                      itemCount: dataCart.length,
                      itemBuilder: (context, i){

                        final String _kodeToko        = dataCart[i].kodeToko;
                        final String _kodeBarang      = dataCart[i].kodeBarang;
                        final String _barcodeBarang   = dataCart[i].barcodeBarang;
                        final String _namaBarang      = dataCart[i].namaBarang;
                        final String _satuan          = dataCart[i].satuan;
                        final String _klpBarang       = dataCart[i].klpBarang;
                        final int _hargaJual          = dataCart[i].hargaJual;
                        final String _kodeSatuan      = dataCart[i].kodeSatuan;
                        final int _hargaTotal         = dataCart[i].hargaTotal;
                        final int _qty                = dataCart[i].qty;

                        return CartAdapter(
                          kodeToko: _kodeToko,
                          kodeBarang: _kodeBarang,
                          barcodeBarang: _barcodeBarang,
                          namaBarang: _namaBarang,
                          satuan: _satuan,
                          klpBarang: _klpBarang,
                          hargaJual: _hargaJual,
                          kodeSatuan: _kodeSatuan,
                          hargaTotal: _hargaTotal,
                          qty: _qty,
                        );
                      },
                    ),
            ),
            Container(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.only(left: 20, right: 20, bottom: 15),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            alignment: Alignment.centerLeft,
                            child: Text("Grand total"),
                          ),
                          Padding(padding: EdgeInsets.only(bottom: 4)),
                          Container(
                            alignment: Alignment.centerLeft,
                            padding: EdgeInsets.only(left: 20, bottom: 4),
                            child: GrandTotal(grandTotal: gt,),
                          )
                        ],
                      ),
                    )
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      width: double.infinity,
                      height: 65,
                      padding: EdgeInsets.only(left: 20, right: 20, bottom: 15),
                      child: RaisedButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                          side: BorderSide(color: Colors.green[200]),
                        ),
                        color: themeColor,
                        elevation: 0,
                        onPressed: (){
                          createTransaksi(generateRandomString(5), qt, gt, 'transfer');
                        },
                        child: Text(
                          "Checkout",
                          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
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

class GrandTotal extends StatefulWidget {

  final int grandTotal;

  const GrandTotal({Key key, this.grandTotal}) : super(key: key);

  @override
  _GrandTotalState createState() => _GrandTotalState();
}

class _GrandTotalState extends State<GrandTotal> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Text("Rp. ${widget.grandTotal}", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black54),);
  }
}

class CartAdapter  extends StatefulWidget{

  final String kodeToko;
  final String kodeBarang ;
  final String barcodeBarang;
  final String namaBarang;
  final String satuan;
  final String klpBarang;
  final int hargaJual;
  final String kodeSatuan;
  final int hargaTotal;
  final int qty;

  CartAdapter({
    this.kodeToko,
    this.kodeBarang,
    this.barcodeBarang,
    this.namaBarang,
    this.satuan,
    this.klpBarang,
    this.hargaJual,
    this.kodeSatuan,
    this.hargaTotal,
    this.qty
  });

  @override
  _CartAdapterState createState() => _CartAdapterState();
}

class _CartAdapterState extends State<CartAdapter> {

  int totalQty;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    totalQty = widget.qty;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      child: Column(
        children: [
          Padding(padding: EdgeInsets.only(top: 20)),
          Row(
            children: [
              Padding(padding: EdgeInsets.only(left: 30)),
              Expanded(
                flex: 2,
                child: Column(
                  children: [
                    Container(
                      height: 70,
                      alignment: Alignment.centerLeft,
                      child: Text("${widget.namaBarang}", style: TextStyle(fontSize: 25, color: Colors.black54, fontWeight: FontWeight.bold),),
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      child: Text("${widget.satuan}", style: TextStyle(fontSize: 13),),
                    ),
                    Padding(padding: EdgeInsets.only(top: 8)),
                    Container(
                      alignment: Alignment.centerLeft,
                      child: Text("Rp. ${widget.hargaJual}", style: TextStyle(fontSize: 17, color: Colors.black45),),
                    )
                  ],
                ),
              ),
              Expanded(
                flex: 2,
                child: Column(
                  children: [
                    Container(
                      height: 70,
                      child: ChangeQuantity(
                        valueChanged: (int newValue){
                          setState(() {
                            totalQty = newValue;
                          });
                        },
                        cartQty: totalQty,
                        kodeBarang: widget.kodeBarang,
                        satuan: widget.satuan,
                        hargaTotalPcs: widget.hargaTotal,
                        hargaSatuan: widget.hargaJual,
                        namaBarang: widget.namaBarang,
                        summaryHarga: widget.hargaTotal,
                      ),
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      child: Text("", style: TextStyle(fontSize: 13),),
                    ),
                    Padding(padding: EdgeInsets.only(top: 8)),
                    Container(
                      alignment: Alignment.centerLeft,
                      child: Text("Rp. ${widget.hargaTotal}", style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.black54),),
                    )
                  ],
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}

class ChangeQuantity extends StatefulWidget{

  final int cartQty;
  final ValueChanged<int> valueChanged;
  final String kodeBarang;
  final String satuan;
  final int hargaSatuan;
  final int hargaTotalPcs;
  final String namaBarang;
  final int summaryHarga;

  const ChangeQuantity({Key key, this.cartQty, this.valueChanged, this.kodeBarang, this.satuan, this.hargaSatuan, this.hargaTotalPcs, this.namaBarang, this.summaryHarga}) : super(key: key);

  @override
  _ChangeQuantityState createState() => _ChangeQuantityState();
}

class _ChangeQuantityState extends State<ChangeQuantity> {

  TextEditingController _quantity = new TextEditingController();

  List<CustomerCartModel> dataCartDelete = List();
  void deleteItemCart(){
    CustomerCartService().deleteItemCart(widget.kodeBarang, widget.satuan).then((value) {
      print("Dicart View ${value}");
      if(value == true){
        print("Berhasil");
        Navigator.pushReplacementNamed(context, '/halaman/customer/CartView');
      }else{
        print("Gagal");
      }
    });
  }

  List<CustomerCartModel> dataCartEdited = List();
  void editedItemCart(String cartTotalQty){
    CustomerCartService().editItemCart(widget.kodeBarang, widget.satuan, cartTotalQty, widget.hargaSatuan.toString()).then((value){
      if(value == true){
        print("Berhasil Update");
        Navigator.pushReplacementNamed(context, '/halaman/customer/CartView');
      }else{
        print("gagal Update");
      }
    });
  }

  _add(){
    int cartTotalQty = int.parse(_quantity.text);
    cartTotalQty++;
    widget.valueChanged(cartTotalQty);
    print("Hasilnya : ${cartTotalQty}");
    editedItemCart(cartTotalQty.toString());
  }

  _subtract(){
    int cartTotalQty = int.parse(_quantity.text);
    cartTotalQty--;
    widget.valueChanged(cartTotalQty);
    print("Hasilnya : ${cartTotalQty}");
    editedItemCart(cartTotalQty.toString());
  }

  @override
  Widget build(BuildContext context) {
    _quantity = TextEditingController(text: "${widget.cartQty}");
    // TODO: implement build
    return Row(
      children: [
        Padding(padding: EdgeInsets.only(left: 30)),
        Container(
          child: GestureDetector(
            onTap: (){
              deleteItemCart();
            },
            child: Image.asset('assets/iconcart/trash.png', width: 15, color: Colors.red,),
          ),
        ),
        Expanded(
          child: Container(
            padding: EdgeInsets.only(left: 10, right: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  alignment: Alignment.centerLeft,
                  child: GestureDetector(
                    onTap: (){
                      _subtract();
                      print(widget.cartQty);
                    },
                    child: Icon(Icons.remove_circle, size: 15, color: Colors.grey,),
                  ),
                ),
                Container(
                  width: 50,
                  child: TextFormField(
                    textAlign: TextAlign.center,
                    controller: _quantity,
                    style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blueGrey),
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly
                    ],
                  ),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  child: GestureDetector(
                    onTap: (){
                      _add();
                      print(widget.cartQty);
                    },
                    child: Icon(Icons.add_circle, size: 15, color: Colors.grey,),
                  ),
                )
              ],
            ),
          ),
        )
      ],
    );
  }

}