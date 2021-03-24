import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:niagapos_pro/models/customerOrderModel.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CustomerOrderService {

  SharedPreferences prefs;

  Future<List<CustomerOrderModel>> getOrder() async {

    prefs = await SharedPreferences.getInstance();

    try {
      http.Response hasil = await http.get(
          Uri.encodeFull("http://restapi.niagapospro.com/data_toko/barangbytoko/${prefs.getString('kode_toko')}"),
          headers: {"Accept": "application/json"});
      if (hasil.statusCode == 200) {
        final data = customerOrderModelFromJson(hasil.body);
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
}