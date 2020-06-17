import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sarshelp/screens/requests_page.dart';
import 'package:sarshelp/screens/user_page.dart';
import 'package:sarshelp/widgets/common.dart';

import 'home_content.dart';

final auth = FirebaseAuth.instance;

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage> {
  AuthStatus authStatus = AuthStatus.NOT_DETERMINED;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  int _currentIndex = 0;

  Text appBarTitleText = new Text("Sars Help");
  Widget _body = new HomeContent();

  @override
  void initState() {
    super.initState();
  }

 _signOut() async {
    try {
      await auth.signOut();
      
    setState(() {
      authStatus = AuthStatus.NOT_LOGGED_IN;
    });
    } catch (e) {
      print(e);
    }
    Navigator.pushReplacementNamed(context, '/Auth');
 }


onTabTapped(int index) {
   setState(() {
   if(index == _currentIndex) return;
   switch (index) {
     case 0:
      appBarTitleText = Text('Home');
      _body = new HomeContent();
      _currentIndex = index;
       break;
     case 1:
      appBarTitleText = Text('Solicitudes'); 
       _currentIndex = index;
       _body = new RequestsPage();
       break;
    case 2:
      appBarTitleText = Text('Perfil');
      _body = new UserPage();
       _currentIndex = index;
       break;
   }});
}

 void _select(String selected){
   if(selected.compareTo('Cerrar Sesion') == 0){
    _signOut();
   }
 }


@override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Center(child:Text('Sars Help')),
        actions: [
          PopupMenuButton<String>(
  				onSelected: this._select,
          // onSelected: home_page._select,
          itemBuilder: (BuildContext context) => <PopupMenuItem<String>>[
            const PopupMenuItem<String>(
            value: 'Cerrar Sesion',
            child: Text('Cerrar Sesion')
            ),
            const PopupMenuItem<String>(
            value: 'Right here',
            child: Text('Ayuda')
            ),
            const PopupMenuItem<String>(
            value: 'Hooray!',
            child: Text('Donar!')
            ),],
        ),
        ]
      ),
      body: _body,
      bottomNavigationBar:  BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          onTap: onTabTapped, // new
          currentIndex: _currentIndex,
          items: [
              new BottomNavigationBarItem(
                icon: Icon(Icons.home),
                title: Text('Inicio') ),
              new BottomNavigationBarItem(
                icon: Icon(Icons.book),
                title: Text('Solicitudes') ),
              new BottomNavigationBarItem(
                icon: Icon(Icons.person),
                title: Text('Perfil') ),
          ] 
        ),
    );
  }
  
}


  