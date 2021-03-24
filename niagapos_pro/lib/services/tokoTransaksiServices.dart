import 'package:http/http.dart' as http;
import 'package:niagapos_pro/models/tokoTransaksiModel.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TokoTransaksiServices{

  SharedPreferences prefs;

  Future<List<TokoTransaksiModel>> getAllTransaksi() async {
    prefs = await SharedPreferences.getInstance();

    String _kodeToko = prefs.getString('password');

    try{
      http.Response hasil = await http.post(
          Uri.encodeFull("http://restapi.niagapospro.com/transaksi/getbytoko"),
          headers: {"Accept": "application/json"},
          body: {
            "kode_toko":_kodeToko
          }
      );
      if (hasil.statusCode == 200) {
        final data = tokoTransaksiModelFromJson(hasil.body);
        print("data category success ${prefs.getString('password')}");
        return data;
      } else {
        print("error status " + hasil.statusCode.toString());
        return null;
      }
    }catch(e) {
      print("error catch $e");
      return null;
    }

  }

  Future<bool> updateTransaksi(String _idTransaksi, String _status) async {
    prefs = await SharedPreferences.getInstance();

    String _kodeToko = prefs.getString('password');
    
    try{
      http.Response hasil = await http.post(
        Uri.encodeFull('http://restapi.niagapospro.com/transaksi/konfirmasi'),
          headers: {"Accept": "application/json"},
          body: {
            "kode_toko":_kodeToko,
            "id_transaksi":_idTransaksi,
            "status":_status
          }
      );
      if(hasil.statusCode == 200){
        print("Update Status Transaksi Berhasil");
        return true;
      }else{
        print("Update Status Transaksi gagal");
        return false;
      }
    }catch(e) {
      print("error catch $e");
      return null;
    }
  }

}