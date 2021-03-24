import 'package:customer_satisfaction/screens/admin/home_admin.dart';
import 'package:customer_satisfaction/screens/choice_rate.dart';
import 'package:customer_satisfaction/screens/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIOverlays([]);
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight])
      .then((_){
        runApp(MyApp());
      }
  );
  // runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Login(),
      routes: <String,WidgetBuilder>{
        '/screens/choice_rate':(BuildContext context)=> ChoiceRate(),
        '/screens/admin/home_admin':(BuildContext context)=> HomeAdmin()
      },
    );
  }
}