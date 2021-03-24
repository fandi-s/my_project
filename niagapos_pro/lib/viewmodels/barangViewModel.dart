import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:niagapos_pro/models/barangModel.dart';

class BarangViewModel {

  Future<List<BarangModel>> getBarang() async {
    try {
      http.Response hasil = await http.get(
          Uri.encodeFull("http://fds-management.com/rest_mypos/index.php/api_niaga/inventory"),
          headers: {"Accept": "application/json"});
      if (hasil.statusCode == 200) {
        print("data category success");
        final data = barangModelFromJson(hasil.body);
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