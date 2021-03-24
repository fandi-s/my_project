import 'package:http/http.dart' as http;
import 'package:niagapos_pro/models/keranjangModel.dart';

class KeranjangService{
  Future<bool> masukanBarang(
      String kodePembeli,
      String namaPembeli,
      String kodeToko,
      String kodeBarang,
      String barcodeBarang,
      String namaBarang,
      String satuan,
      String klpBarang,
      String hargaJual,
      String kodeSatuan,
      String hargaTotal
      ) async {
    try {
      http.Response hasil = await http.post(
          Uri.encodeFull("http://restapi.niagapospro.com/tocart/cekkeranjang"),
          headers: {"Accept": "application/json"},
          body: {
            "kode_pembeli":kodePembeli,
            "nama_customer":namaPembeli,
            "kode_toko":kodeToko,
            "kode_barang":kodeBarang,
            "barcode_barang":barcodeBarang,
            "nama_barang":namaBarang,
            "satuan":satuan,
            "klp_barang":klpBarang,
            "harga_jual":hargaJual,
            "kode_satuan":kodeSatuan,
            "harga_total":hargaTotal,
          }
      );
      if (hasil.statusCode == 201) {
        print("data category success Insert");
        return true;
      } else if(hasil.statusCode == 200){
        print("data category success Update");
        return true;
      } else {
        print("error status " + hasil.statusCode.toString());
        return null;
      }
    } catch (e) {
      print("error catch $e");
      return null;
    }
  }
}