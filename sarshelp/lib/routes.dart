import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:sarshelp/screens/home_page.dart';
import 'package:sarshelp/screens/root_page.dart';
import 'package:sarshelp/services/authentication.dart';

class Routes {
  final routes = <String, WidgetBuilder>{
    '/Auth': (BuildContext context) => new RootPage(auth: new Auth()),
    '/Base': (BuildContext context) => new HomePage()
  };

  Routes () {
    runApp(new MaterialApp(
      routes: routes,
      home: new MyApp(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
         primaryColor: Colors.blue[900],
         primaryColorLight: Colors.blue[700],
         accentColor: Colors.redAccent[700]
      ),
    ));
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
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate
      ],
      supportedLocales: [
        const Locale('en'),
        const Locale('es')
      ],
      title: 'SarsHelp',
      home: new RootPage(auth: new Auth()),
    );
  }
}