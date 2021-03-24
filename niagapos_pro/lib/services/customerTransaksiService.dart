import 'package:http/http.dart' as http;
import 'package:niagapos_pro/models/customerTransaksiModel.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CustomerTransaksiService{

  SharedPreferences prefs;

  Future<bool> createTransaksi(
      String _idTransaksi,
      int _qtyItem,
      int _grandTotal,
      String _pembayaran
      ) async {

    prefs = await SharedPreferences.getInstance();

    String _kodePembeli = prefs.getString('password');
    String _kodeToko    = prefs.getString('kode_toko');
    String _status      = '1';
    String _idt         = "${_kodePembeli}-${_idTransaksi}";

    try{
      http.Response hasil = await http.post(
        Uri.encodeFull("http://restapi.niagapospro.com/transaksi/create"),
        headers: {"Accept": "application/json"},
        body: {
          'id_transaksi': _idt,
          'kode_pembeli': _kodePembeli,
          'kode_toko': _kodeToko,
          'qty_item': _qtyItem.toString(),
          'grand_total': _grandTotal.toString(),
          'pembayaran': _pembayaran,
          'status': _status
        }
      );
      if(hasil.statusCode == 200){
        print("Transaksi created ${_idt}");
        return true;
      }else{
        print("Transaksi failed ${_idt}");
        return false;
      }
    } catch (e) {
      print("error catch $e");
      return null;
    }
  }

  Future<List<CustomerTransaksiModel>> getTransaksi() async {

    prefs = await SharedPreferences.getInstance();

    String _kodePembeli = prefs.getString('password');
    String _kodeToko    = prefs.getString('kode_toko');

    try{
      http.Response hasil = await http.post(
          Uri.encodeFull("http://restapi.niagapospro.com/transaksi/getbypembeli"),
          headers: {"Accept": "application/json"},
          body: {
            "kode_pembeli":_kodePembeli,
            "kode_toko":_kodeToko
          }
      );
      if (hasil.statusCode == 200) {
        final data = customerTransaksiModelFromJson(hasil.body);
        print("data category success ${prefs.getString('kode_toko')}");
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

}