import 'package:flutter/material.dart';
import 'package:flutter_plugin_pdf_viewer/flutter_plugin_pdf_viewer.dart';

class ViewLaporanPage extends StatefulWidget{

  final String urlParsing;
  ViewLaporanPage({Key key, @required this.urlParsing}) : super(key: key);

  @override
  ViewLaporanPageState createState() => ViewLaporanPageState();

}

class ViewLaporanPageState extends State<ViewLaporanPage> {

  bool _isLoading = true;
  PDFDocument document;

  void initState(){
    super.initState();
    loadDocument();
  }

  void loadDocument() async {
    document = await PDFDocument.fromURL(widget.urlParsing);
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(top: 20.0),
        child: Center(
          child: _isLoading
              ? Center(child: CircularProgressIndicator())
              : PDFViewer(document: document),
        ),
      )
    );
  }

}

//
//