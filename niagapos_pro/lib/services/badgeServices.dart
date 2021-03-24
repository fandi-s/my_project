import 'package:http/http.dart' as http;
import 'package:niagapos_pro/models/badgeModel.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BadgeServices{

  SharedPreferences prefs;

  Future<List<BadgeModel>> totalQty() async {

    prefs = await SharedPreferences.getInstance();

    String _kodePembeli = prefs.getString('password');
    String _kodeToko    = prefs.getString('kode_toko');

    try{
      http.Response hasil = await http.post(Uri.encodeFull("http://restapi.niagapospro.com/tocart/summaryqty"),
        headers: {"Accept": "application/json"},
        body: {
          "kode_pembeli":_kodePembeli,
          "kode_toko":_kodeToko
        }
      );
      if(hasil.statusCode == 200){
        print("BAJINGAN = ${_kodePembeli}");
        final data = badgeModelFromJson(hasil.body);
        return data;
      }else{
        print("Gagal");
      }
    }catch (e){
      print("error catch $e");
      return null;
    }
  }
}