import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:sarshelp/screens/home_page.dart';
import 'package:sarshelp/screens/root_page.dart';
import 'package:sarshelp/services/authentication.dart';

class Routes {

  Routes () {
    runApp(new MyApp());
  }
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final routes = <String, WidgetBuilder>{
    '/Auth': (BuildContext context) => new RootPage(auth: new Auth()),
    '/Home': (BuildContext context) => new HomePage()
  };
  @override
  Widget build(BuildContext context) {
    return new  MaterialApp(
      debugShowCheckedModeBanner: false,
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate
      ],
      routes: routes,
      supportedLocales: [
        const Locale('en'),
        const Locale('es')
      ],
      title: 'SarsHelp',
      home: new RootPage(auth: new Auth()),
      theme: ThemeData(
         primaryColor: Colors.blue[900],
         primaryColorLight: Colors.blue[700],
         accentColor: Colors.redAccent[700]
      ),
    );
  }
}