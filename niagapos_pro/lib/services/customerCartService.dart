import 'package:http/http.dart' as http;
import 'package:niagapos_pro/models/customerCartModel.dart';
import 'package:niagapos_pro/models/grandTotalModel.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CustomerCartService{
  SharedPreferences prefs;

  Future<List<GrandTotalModel>> grandHarga() async {

    prefs = await SharedPreferences.getInstance();
    String _kodePembeli = prefs.getString('password');
    String _kodeToko = prefs.getString('kode_toko');
    print("ANJENG ${_kodeToko}");

    try{
      http.Response hasil = await http.post(Uri.encodeFull("http://restapi.niagapospro.com/tocart/summaryharga"),
          headers: {"Accept": "application/json"},
          body: {
            "kode_pembeli":_kodePembeli,
            "kode_toko":_kodeToko
          }
      );
      if(hasil.statusCode == 200){
        final data = grandTotalModelFromJson(hasil.body);
        return data;
      }else{
        print("Gagal");
      }
    }catch (e){
      print("error catch $e");
      return null;
    }
  }

  Future<List<CustomerCartModel>> getCart() async {
    prefs = await SharedPreferences.getInstance();
    String _kodePembeli = prefs.getString('password');

    try{
      http.Response hasil = await http.get(
          Uri.encodeFull("http://restapi.niagapospro.com/tocart/cartbypembeli/${_kodePembeli}"),
          headers: {"Accept": "application/json"});
      if (hasil.statusCode == 200) {
        final data = customerCartModelFromJson(hasil.body);
        print("data category success ${prefs.getString('kode_toko')}");
        return data;
      } else {
        print("error status " + hasil.statusCode.toString());
        return null;
      }
    } catch (e) {
      print("error catch $e");
      return null;
    }

  }

  Future<bool> deleteItemCart(String kodeBarang, String satuan) async {
    prefs = await SharedPreferences.getInstance();
    String _kodePembeli = prefs.getString('password');

    try{
      http.Response hasil = await http.post(
        Uri.encodeFull("http://restapi.niagapospro.com/tocart/deleteitemcart"),
        headers: {"Accept": "application/json"},
        body: {
          "kode_pembeli":_kodePembeli,
          "satuan":satuan,
          "kode_barang":kodeBarang
        }
      );
      if (hasil.statusCode == 200) {
        print("data category success ${hasil.statusCode}");
        return true;
      } else {
        print("error status " + hasil.statusCode.toString());
        return false;
      }
    } catch (e) {
      print("error catch $e");
      return null;
    }

  }

  Future<bool> editItemCart(String kodeBarang, String satuan, String qty, String hargaJual) async {
    prefs = await SharedPreferences.getInstance();
    String _kodePembeli = prefs.getString('password');

    try{
      http.Response hasil = await http.post(
          Uri.encodeFull("http://restapi.niagapospro.com/tocart/updateitemcart"),
          headers: {"Accept": "application/json"},
          body: {
            "kode_pembeli":_kodePembeli,
            "kode_barang":kodeBarang,
            "satuan":satuan,
            "qty":qty,
            "harga_jual":hargaJual
          }
      );
      if (hasil.statusCode == 200) {
        print("data category success ${hasil.statusCode}");
        return true;
      } else {
        print("error status " + hasil.statusCode.toString());
        return false;
      }
    } catch (e) {
      print("error catch $e");
      return null;
    }

  }

}