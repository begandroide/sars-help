import 'package:flutter/material.dart';
import 'package:sarshelp/screens/home_page.dart';
import 'package:sarshelp/screens/root_page.dart';
import 'package:sarshelp/services/authentication.dart';

class Routes {
  // final routes = <String, WidgetBuilder>{
  //   '/': (BuildContext context) => new RootPage(auth: new Auth()),
  //   '/Home': (BuildContext context) => new HomePage()
  // };

  Routes () {
    runApp(new MyApp());
  }
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return new  MaterialApp(
      title: 'SarsHelp',
      home: new RootPage(auth: new Auth()),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primaryColor: Colors.blue[900],
          primaryColorLight: Colors.blue[700],
          accentColor: Colors.redAccent[700]
      ),
    );
  }
}