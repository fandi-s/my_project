import 'dart:convert';

import 'package:customer_satisfaction/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:select_form_field/select_form_field.dart';
import 'package:http/http.dart' as http;

class HomeAdmin extends StatefulWidget {
  @override
  _HomeAdminState createState() => _HomeAdminState();
}

class _HomeAdminState extends State<HomeAdmin> {

  TextEditingController _ctrNama  = new TextEditingController();
  TextEditingController _ctrUsername  = new TextEditingController();
  TextEditingController _ctrPassword  = new TextEditingController();
  TextEditingController _ctrLokasi  = new TextEditingController();

  final List<Map<String, dynamic>> _itemKategoriUser = [
    {
      'value':'1',
      'label':' Toilet Wanita',
      'icon': Icon(Icons.arrow_forward_ios_outlined, size: 8, color: Colors.deepOrange,),
      'textStyle': TextStyle(color: Colors.black54),
    },
    {
      'value':'2',
      'label':' Toilet Pria',
      'icon': Icon(Icons.arrow_forward_ios_outlined, size: 8, color: Colors.deepOrange,),
      'textStyle': TextStyle(color: Colors.black54),
    },
    {
      'value':'3',
      'label':' Masjid',
      'icon': Icon(Icons.arrow_forward_ios_outlined, size: 8, color: Colors.deepOrange,),
      'textStyle': TextStyle(color: Colors.black54),
    }
  ];

  String _valueChangeKategori = '';

  bool _showPassword = false;
  void _togglevisibility(){
    setState(() {
      _showPassword = !_showPassword;
    });
  }

  ProgressDialog pr;

  List user     = [];
  getAllUser()async{
    var url = Constant.ALL_USER;
    final response = await http.post(
      url,
      headers: {'Accept':'Application/json'}
    );

    return json.decode(response.body);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAllUser().then((data){
      setState(() {
        user = data;
      });
    });
  }

  @override
  Widget build(BuildContext context) {

    pr = new ProgressDialog(context, showLogs: true);
    pr.style(message: 'Submiting user...');

    return Scaffold(
      body: Container(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(top: 20, bottom: 10),
              child: Row(
                children: [
                  Expanded(
                    child: Container(),
                  ),
                  Expanded(
                    child: Container(),
                  ),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.only(left: 40, right: 40),
                      child: OutlineButton(
                        onPressed: (){
                          _showDialogPop();
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("  Tambah User  ", style: TextStyle(color: Colors.blue, fontSize: 9),),
                            Icon(Icons.account_circle, color: Colors.orange,size: 15,),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: 300,
              child: user.length > 0 ?
              ListView.builder(
                itemCount: user.length,
                itemBuilder: (BuildContext context, int index){
                  return Container(
                    padding: EdgeInsets.only(left: 40, right: 40),
                    child: Card(
                      elevation: 0.1,
                      child: Container(
                        padding: EdgeInsets.only(left: 30, right: 30, bottom: 8, top: 4),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 4,
                              child: Column(
                                children: [
                                  Container(
                                    padding: EdgeInsets.only(top: 10),
                                    alignment: Alignment.centerLeft,
                                    child: Text(user[index]['nama'], style: TextStyle(color: Colors.black54, fontSize: 12),),
                                  ),
                                  Container(
                                    padding: EdgeInsets.only(top: 5),
                                    alignment: Alignment.centerLeft,
                                    child: Text(user[index]['lokasi'], style: TextStyle(color: Colors.black38, fontSize: 9),),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: FlatButton(
                                      onPressed: (){},
                                      child: MaterialButton(
                                        onPressed: () {},
                                        color: Colors.orange,
                                        textColor: Colors.white,
                                        child: Icon(
                                          Icons.visibility,
                                          size: 12,
                                        ),
                                        padding: EdgeInsets.all(6),
                                        shape: CircleBorder(),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: MaterialButton(
                                      onPressed: () {},
                                      color: Colors.blue,
                                      textColor: Colors.white,
                                      child: Icon(
                                        Icons.edit_outlined,
                                        size: 12,
                                      ),
                                      padding: EdgeInsets.all(6),
                                      shape: CircleBorder(),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: MaterialButton(
                                      onPressed: () {},
                                      color: Colors.red,
                                      textColor: Colors.white,
                                      child: Icon(
                                        Icons.delete_forever,
                                        size: 12,
                                      ),
                                      padding: EdgeInsets.all(6),
                                      shape: CircleBorder(),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ) :
              Container(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void _showDialogPop() {
    showDialog(
      context: context,
      builder: (BuildContext context){
        return Dialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0)
          ),
          child: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.only(left: 40, right: 40),
              child: Column(
                children: [
                  Padding(padding: EdgeInsets.only(top: 25)),
                  Text("Tambah User"),
                  Padding(padding: EdgeInsets.only(top: 15)),
                  TextFormField(
                    decoration: InputDecoration(
                        prefixIcon: Icon(Icons.account_circle),
                        labelText: 'Nama',
                        border: OutlineInputBorder()
                    ),
                    controller: _ctrNama,
                  ),
                  Padding(padding: EdgeInsets.only(top: 8)),
                  TextFormField(
                    decoration: InputDecoration(
                        prefixIcon: Icon(Icons.account_circle_outlined),
                        labelText: 'Username',
                        border: OutlineInputBorder()
                    ),
                    controller: _ctrUsername,
                  ),
                  Padding(padding: EdgeInsets.only(top: 8)),
                  TextFormField(
                    obscureText: !_showPassword,
                    decoration: InputDecoration(
                        labelText: 'Password',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.vpn_key),
                        suffixIcon: GestureDetector(
                          onTap: (){
                            _togglevisibility();
                          },
                          child: Icon(
                            _showPassword ? Icons.visibility : Icons.visibility_off, color: Colors.blue,
                          ),
                        )
                    ),
                    controller: _ctrPassword,
                  ),
                  Padding(padding: EdgeInsets.only(top: 8)),
                  TextFormField(
                    decoration: InputDecoration(
                        prefixIcon: Icon(Icons.location_searching_rounded),
                        labelText: 'Lokasi',
                        border: OutlineInputBorder()
                    ),
                    minLines: 3,
                    maxLines: 5,
                    controller: _ctrLokasi,
                  ),
                  Padding(padding: EdgeInsets.only(top: 8)),
                  SelectFormField(
                    initialValue: '',
                    icon: Icon(Icons.category),
                    labelText: 'Kategori Tempat',
                    items: _itemKategoriUser,
                    onChanged: (val){
                      setState(() {
                        _valueChangeKategori = val;
                        print("AYOLAH "+_valueChangeKategori);
                      });
                    },
                  ),
                  Padding(padding: EdgeInsets.only(top: 8)),
                  Row(
                    children: [
                      Expanded(
                        child: OutlineButton(
                          onPressed: (){
                            pr.show();
                            submitUser(_ctrNama.text, _ctrUsername.text, _ctrPassword.text, _ctrLokasi.text, _valueChangeKategori);
                          },
                          child: Text("Submit", style: TextStyle(color: Colors.deepOrange),),
                        ),
                      )
                    ],
                  ),
                  Padding(padding: EdgeInsets.only(bottom: 15)),

                ],
              ),
            ),
          ),
        );
      }
    );
  }

  void submitUser(String nama, String username, String password, String lokasi, String kategori) async {
    var url = Constant.ADD_USER;
    final response = await http.post(
        url,
        body: {
          'kategori':kategori,
          'nama':nama,
          'lokasi':lokasi,
          'username':username,
          'password':password
        },
        headers: {"Accept": "application/json"}
    );

    var dataUser = json.decode(response.body);
    if(dataUser.length!=0){
      if(dataUser['status']=='fail'){
        print('Gagal Soon');
        pr.hide();
      }else{
        print('Berhasil Soon');
        pr.hide();
        setState(() {
          _ctrNama.clear();
          _ctrUsername.clear();
          _ctrPassword.clear();
          _ctrLokasi.clear();
        });
      }
    }else{
      print('Ada Kesalahan Soon');
      pr.hide();
    }
  }
}
