import 'package:flutter/material.dart';
import 'package:flutter_money_formatter/flutter_money_formatter.dart';

class ItemTransaksi extends StatefulWidget{

  final String idTransaksi;
  final String createAt;
  final String updateAt;
  final String qty;
  final String granTot;
  final String payment;

  const ItemTransaksi({this.idTransaksi, this.createAt, this.updateAt, this.qty, this.granTot, this.payment});

  @override
  _ItemTransaksiState createState() => _ItemTransaksiState();
}

class _ItemTransaksiState extends State<ItemTransaksi> {
  @override
  Widget build(BuildContext context) {

    var date = widget.createAt;
    var parts = date.split(' ');
    var tanggal = parts[0].trim();

    var time = parts[1].trim();
    var hasil = time.split(':');
    var jam = hasil[0].trim()+':'+hasil[1].trim();

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
          side: BorderSide(color: Colors.green[200], width: 0.5),
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
                Text("#"+widget.idTransaksi, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
              ],
            ),
            Text('Date '+tanggal+' - at '+jam, style: TextStyle(color: Colors.black45),),
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
            Padding(padding: EdgeInsets.only(bottom: 10))

          ],
        ),
      ),
    );
  }
}