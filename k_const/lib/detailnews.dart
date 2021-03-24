import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class DetailNewsPage extends StatefulWidget{

  final String url;
  DetailNewsPage({Key key, @required this.url}) : super(key: key);

  @override
  DetailState createState() => DetailState();
}

class DetailState extends State<DetailNewsPage> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: WebView(
            javascriptMode: JavascriptMode.unrestricted,
            initialUrl: widget.url,
          ),
        ),
      ),
    );
  }
}