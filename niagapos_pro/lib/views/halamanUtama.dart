import 'package:flutter/material.dart';
import 'package:niagapos_pro/models/barangModel.dart';
import 'package:niagapos_pro/viewmodels/barangViewModel.dart';

class HalamanUtama extends StatefulWidget{
  @override
  _HalamanUtamaState createState() => _HalamanUtamaState();
}

class _HalamanUtamaState extends State<HalamanUtama> {

  List<BarangModel> dataBarang = new List();
  void getDataBarang() {
    BarangViewModel().getBarang().then((value) {
      setState(() {
        dataBarang = value;
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDataBarang();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("Halaman Utama Ya"),
      ),
      body: Center(
        child: dataBarang == null ? CircularProgressIndicator() : ListView.builder(
          itemCount: dataBarang.length,
          itemBuilder: (context, i){
            return Text('${dataBarang[i].namaBarang}');
          },
        ),
      )
    );
  }
}