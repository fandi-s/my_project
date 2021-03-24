import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

import 'package:http/http.dart' as http;
import 'package:async/async.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math';
import 'dart:convert';

import 'package:google_maps_flutter/google_maps_flutter.dart';

ProgressDialog pr;

class Post extends StatefulWidget{
  @override
  PostState createState() => PostState();
}

String messageImage = '';

class PostState extends State<Post> {

  BitmapDescriptor myIcon;

  TextEditingController controllerDeskripsi = new TextEditingController();

  String dropdownValue = 'Penerangan Jalan';
  String dropdownValueLevel = 'Ringan';
  String idImage = '';
  String getlat;
  String getlng;

  LatLng pinPosition;
  LatLng positionDefault = LatLng(-1.391569, 113.933722);

  List <String> spinnerItems = [
    'Penerangan Jalan',
    'Sampah',
    'Ketenangan',
    'Listrik',
    'Jalan'
  ] ;

  List <String> spinnerItemsLevel = [
    'Ringan',
    'Sedang',
    'Parah',
  ] ;

  File _image;

  Future getImageGallery() async {
    var imageFile = await ImagePicker.pickImage(source: ImageSource.gallery, imageQuality: 50);
    setState(() {
      _image = imageFile;
    });
  }

  Future getImageCamera() async {
    var imageFile = await ImagePicker.pickImage(source: ImageSource.camera, imageQuality: 50);
    setState(() {
      _image = imageFile;
    });
  }

  double percentage = 0.0;

  Future upload(File imageFile, String deskripsi, String dropdownValue, String dropdownValueLevel, String idimage) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var stream = new http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
    var length = await imageFile.length();
    var uri = Uri.parse("http://fds-management.com/rest_flutter/upload_laporan.php");

    var request = new http.MultipartRequest("POST", uri);
    var multipartFile = new http.MultipartFile("image", stream,length, filename: basename(imageFile.path));
    request.files.add(multipartFile);
    request.fields['username']  = prefs.getString("username");
    request.fields['id_image']     = idimage;
    request.fields['deskripsi'] = deskripsi;
    request.fields['kategori_laporan'] = dropdownValue;
    request.fields['kategori_kerusakan'] = dropdownValueLevel;
    request.fields['lat'] = getlat;
    request.fields['lng'] = getlng;

    var response = await request.send();

    if(response.statusCode==200){
      print("Posted");
    }else{
      print("Failed");
    }
  }

  final Map<String, Marker> _markers = {};

//   void _getLocation() async{
//     var _currenLocation = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
//     pinPosition = LatLng(_currenLocation.latitude, _currenLocation.longitude);
//     setState(() {
//       _markers.clear();
//       final marker = Marker(
//           markerId: MarkerId("cur_loc"),
//           position: pinPosition,
// //        infoWindow: InfoWindow(title: "Your Location"),
//           icon: myIcon
//       );
//       _markers["Current Location"] = marker;
//     });
//
//
//     getlat = _currenLocation.latitude.toString();
//     getlng = _currenLocation.longitude.toString();
//   }

  @override
  void initState(){
    super.initState();
    if(Platform.isIOS){
      BitmapDescriptor.fromAssetImage(ImageConfiguration(
          size: Size(48, 48)
      ), 'assets/images/story.png').then((onValue){
        myIcon = onValue;
      });
    }else if(Platform.isAndroid){
      BitmapDescriptor.fromAssetImage(ImageConfiguration(
          size: Size(100.0, 100.0)
      ), 'assets/images/logout.png').then((onValue){
        myIcon = onValue;
      });
    }

    // _getLocation();
  }

  Completer<GoogleMapController> _controller = Completer();

  static const LatLng _center = const LatLng(45.521563, -122.677433);

  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

  @override
  Widget build(BuildContext context) {

    pr = ProgressDialog(
      context,
      type: ProgressDialogType.Download,
      textDirection: TextDirection.ltr,
      isDismissible: true,
    );

    pr.style(
        message: "Uploading file",
        borderRadius: 10.0,
        backgroundColor: Colors.white,
        elevation: 10.0,
        insetAnimCurve: Curves.easeInOut,
        progress: 0.0,
        progressWidgetAlignment: Alignment.center,
        maxProgress: 100.0,
        progressTextStyle: TextStyle(
            color: Colors.blueAccent, fontSize: 12.0, fontWeight: FontWeight.w400
        ),
        messageTextStyle: TextStyle(
            color: Colors.lightBlueAccent, fontSize: 18.0, fontWeight: FontWeight.w500
        )
    );

    // TODO: implement build
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.only(left: 20.0, right: 20.0),
        child: Column(
          children: <Widget>[
            Center(
              child: _image==null
                  ? new Card(
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  child: Column(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.only(top: 50.0, left: 50.0, right: 50.0),
                        child: Image.asset("assets/images/noimage.png", width: 300.0, color: Colors.lightBlue,),
                      ),
                      Padding(padding: EdgeInsets.all(10.0),),
                      Text("No image selected", style: TextStyle(color: Colors.red),),
                      Padding(padding: EdgeInsets.all(20.0),),
                    ],
                  )
              )
                  : new Card(
                clipBehavior: Clip.antiAliasWithSaveLayer,
                child: Image.file(_image),
              ),
            ),
            Row(
              children: <Widget>[
                FlatButton.icon(onPressed: (){getImageGallery();}, icon: Icon(Icons.folder), label: Text("Gallery")),
                FlatButton.icon(onPressed: (){getImageCamera();}, icon: Icon(Icons.camera_alt), label: Text("Camera")),
              ],
            ),
            TextFormField(
              controller: controllerDeskripsi,
              keyboardType: TextInputType.multiline,
              maxLength: 1000,
              maxLines: null,
              textAlign: TextAlign.start,
              decoration: InputDecoration(
                  labelText: 'Deskripsi',
                  border: OutlineInputBorder()
              ),
            ),
            Padding(padding: EdgeInsets.only(top: 10.0),),
            DropdownButton<String>(
                value: dropdownValue,
                itemHeight: 70,
                icon: Icon(Icons.arrow_drop_down),
                iconSize: 24.0,
                isExpanded: true,
                elevation: 20,
                items: spinnerItems.map<DropdownMenuItem<String>>((String value){
                  return DropdownMenuItem<String>(
                      value: value,
                      child: Row(
                        children: <Widget>[
                          Icon(Icons.check),
                          Padding(padding: EdgeInsets.only(right: 20.0),),
                          Text(value),
                        ],
                      )
                  );
                }).toList(),
                onChanged: (String data){
                  setState(() {
                    dropdownValue = data;
                  });
                }
            ),
            Padding(padding: EdgeInsets.only(top: 10.0),),
            DropdownButton<String>(
                value: dropdownValueLevel,
                itemHeight: 70,
                icon: Icon(Icons.arrow_drop_down),
                iconSize: 24.0,
                isExpanded: true,
                elevation: 20,
                items: spinnerItemsLevel.map<DropdownMenuItem<String>>((String value){
                  return DropdownMenuItem<String>(
                      value: value,
                      child: Row(
                        children: <Widget>[
                          Icon(Icons.check),
                          Padding(padding: EdgeInsets.only(right: 20.0),),
                          Text(value),
                        ],
                      )
                  );
                }).toList(),
                onChanged: (String data){
                  setState(() {
                    dropdownValueLevel = data;
                  });
                }
            ),
            Padding(padding: EdgeInsets.only(top: 10.0),),

            Card(
              child: Container(
                height: 200.0,
                child: GoogleMap(
                  myLocationEnabled: true,
                  mapType: MapType.normal,
                  initialCameraPosition: CameraPosition(
                      target: pinPosition == null ? positionDefault : pinPosition,
                      zoom: 13.0
                  ),
                  markers: _markers.values.toSet(),
                ),
              ),
            ),

            Padding(padding: EdgeInsets.only(top: 30.0),),
            SizedBox(
              width: double.infinity,
              height: 50.0,
              child: RaisedButton(
                child: Text("Laporkan", style: TextStyle(color: Colors.white),),
                color: Colors.lightBlueAccent,
                onPressed: () async{
                  if(_image==null){
                    setState(() {
                      messageImage = "Image tidk boleh kosong";
                    });
                  }else if(controllerDeskripsi.text == ""){
                    setState(() {
                      messageImage = "Deskripsi tidak boleh kosong";
                    });
                  }else{
                    await pr.show();

                    Future.delayed(Duration(seconds: 2)).then((onValue){
                      percentage = percentage + 10.0;

                      pr.update(
                          progress: percentage,
                          message: "Please wait...",
                          progressWidget: Container(
                              padding: EdgeInsets.all(8.0),
                              child: CircularProgressIndicator()
                          ),
                          maxProgress: 100.0,
                          progressTextStyle: TextStyle(
                              color: Colors.red,
                              fontSize: 12.0,
                              fontWeight: FontWeight.w400
                          ),
                          messageTextStyle: TextStyle(
                            color: Colors.deepOrangeAccent,
                            fontSize: 18.0,
                            fontWeight: FontWeight.w500,
                          )
                      );

                      Future.delayed(Duration(seconds: 2)).then((value){
                        percentage = percentage + 10.0;
                        pr.update(
                            progress: percentage, message: "Few more seconds..."
                        );
                        print(percentage);
                        Future.delayed(Duration(seconds: 2)).then((value){
                          percentage = percentage + 10.0;
                          pr.update(progress: percentage, message: "Almost done...");
                          print(percentage);

                          Future.delayed(Duration(seconds: 2)).then((value){
                            pr.hide().whenComplete((){
                              print(pr.isShowing());
                            });
                            percentage = 0.0;
                            setState(() {
                              _image = null;
                            });
                          });
                        });
                      });

                      Future.delayed(Duration(seconds: 10)).then((onValue){
                        print("PR status ${pr.isShowing()}");
                        if(pr.isShowing())
                          pr.hide().then((isHidden){
                            print(isHidden);
                          });
                        print("PR status ${pr.isShowing()}");
                      });

                      setState(() {
                        Random _random = Random.secure();
                        var values = List<int>.generate(32, (i) => _random.nextInt(256));
                        idImage = base64Url.encode(values);
                      });

                      upload(_image, controllerDeskripsi.text, dropdownValue, dropdownValueLevel,idImage);

                    });
                  }

                },
              ),
            ),
            Padding(padding: EdgeInsets.only(top: 2.0),),
            Text(messageImage, style: TextStyle(color: Colors.red),),
            Padding(padding: EdgeInsets.only(top: 50.0),),

          ],
        ),
      ),
    );
  }
}