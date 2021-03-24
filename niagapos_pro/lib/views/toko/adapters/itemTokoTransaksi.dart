import 'package:flutter/material.dart';
import 'package:flutter_money_formatter/flutter_money_formatter.dart';
import 'package:niagapos_pro/services/tokoTransaksiServices.dart';

class ItemTokoTransaksi extends StatefulWidget{

  final String idTransaksi;
  final String createAt;
  final String updateAt;
  final String qty;
  final String granTot;
  final String payment;
  final String status;

  const ItemTokoTransaksi({this.idTransaksi, this.createAt, this.updateAt, this.qty, this.granTot, this.payment, this.status});

  @override
  _ItemTokoTransaksiState createState() => _ItemTokoTransaksiState();
}

class _ItemTokoTransaksiState extends State<ItemTokoTransaksi> {

  String sendStatus;
  void updateTransaksiToko() {
    if(widget.status=='1'){
      setState(() {
        sendStatus = '2';
      });
    }else if(widget.status=='2'){
      setState(() {
        sendStatus = '3';
      });
    }else if(widget.status=='3'){
      setState(() {
        sendStatus = '4';
      });
    }else if(widget.status=='4'){
      setState(() {
        sendStatus = '4';
      });
    }
    TokoTransaksiServices().updateTransaksi(widget.idTransaksi, sendStatus).then((value) {
      print("Di View Transaksi ${value}");
      if(value == true){
        Navigator.pushReplacementNamed(context, '/toko/TransaksiView');
      }else{
        print("gagal update");
      }
    });
  }

  @override
  Widget build(BuildContext context) {

    var date = widget.createAt;
    var parts = date.split(' ');
    var tanggal = parts[0].trim();

    var time = parts[1].trim();
    var hasil = time.split(':');
    var jam = hasil[0].trim()+':'+hasil[1].trim();

    Color _borderColor;
    String _warning;
    String _labelButton;

    if(widget.status == '1'){
      setState(() {
        _borderColor = Colors.red;
        _warning = 'Butuh di konfirmasi';
        _labelButton = 'Konfirmasi';
      });
    }else if(widget.status == '2'){
      setState(() {
        _borderColor = Colors.orange;
        _warning = 'Butuh di proses';
        _labelButton = 'Proses';
      });
    }else if(widget.status == '3'){
      setState(() {
        _borderColor = Colors.yellow;
        _warning = 'Butuh di kirim';
        _labelButton = 'Kirim';
      });
    }else if(widget.status == '4'){
      setState(() {
        _borderColor = Colors.green;
        _warning = 'Konfirmasi pembeli';
        _labelButton = 'Send Notif';
      });
    }

    FlutterMoneyFormatter fmf = FlutterMoneyFormatter(
        amount: double.parse(widget.granTot),
        settings: MoneyFormatterSettings(
          symbol: '',
          thousandSeparator: '.',
          decimalSeparator: ',',
          symbolAndNumberSeparator: ' ',
          fractionDigits: 3,
        )
    );

    // TODO: implement build
    return Container(
      padding: EdgeInsets.only(left: 20, top: 6, right: 20),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(color: _borderColor, width: 0.5),
        ),
        elevation: 0,
        color: Colors.white,
        onPressed: (){},
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(padding: EdgeInsets.only(top: 10)),
            Row(
              children: [
                Text("Invoice ", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black54),),
                Text("#"+widget.idTransaksi, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: _borderColor),),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: Text('Date '+tanggal+' - at '+jam, style: TextStyle(color: Colors.black45),),
                ),
                Expanded(
                  child: OutlineButton(
                    onPressed: (){
                      updateTransaksiToko();
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(child: Text(_labelButton, style: TextStyle(color: _borderColor),)),
                        Expanded(child: Icon(Icons.arrow_forward_ios, size: 15,))
                      ],
                    ),
                  ),
                )
              ],
            ),
            Padding(padding: EdgeInsets.only(top: 8)),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Quantity : ', style: TextStyle(color: Colors.black45),),
                      Row(
                        children: [
                          Text(widget.qty, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),),
                          Text(' barang', style: TextStyle(color: Colors.black45),),
                        ],
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Grand total : ', style: TextStyle(color: Colors.black45),),
                      Row(
                        children: [
                          Text('Rp. ', style: TextStyle(color: Colors.black45),),
                          Text(fmf.output.withoutFractionDigits, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),),
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
            Padding(padding: EdgeInsets.only(top: 8)),
            Row(
              children: [
                Expanded(
                  child: Container(),
                ),
                Expanded(
                  child: Row(
                    children: [
                      Text('Pembayaran : ',style: TextStyle(color: Colors.black45),),
                      Text(widget.payment)
                    ],
                  ),
                )
              ],
            ),
            Padding(padding: EdgeInsets.only(top: 8)),
            Row(
              children: [
                Expanded(
                  child: Container(),
                ),
                Expanded(
                  child: Row(
                    children: [
                      Text(_warning, style: TextStyle(color: _borderColor),)
                    ],
                  ),
                )
              ],
            ),
            Padding(padding: EdgeInsets.only(bottom: 10))


          ],
        ),
      ),
    );
  }
}