import 'package:flutter/material.dart';
import 'package:sarshelp/screens/user_page.dart';
import 'package:sarshelp/services/api_provider.dart';
import 'package:sarshelp/services/authentication.dart';


class HomePage extends StatefulWidget {
  HomePage({Key key, this.auth, this.userId, this.onSignedOut})
      : super(key: key);

  final BaseAuth auth;
  final VoidCallback onSignedOut;
  final String userId;

  @override
  State<StatefulWidget> createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage> {
    List<ItemModel> _todoList;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  int _currentIndex = 0;

  Text appBarTitleText = new Text("AceiteMobil");
  Widget _body = null;

  @override
  void initState() {
    super.initState();
    _todoList = new List();
    // for(int i = 1; i < 6; i++)
    // {
    //   getItem(i).then((ItemModel res){
    //     print("Producto id -> " + i.toString());
    //     print( res.idProducto + " / " + res.plu + " / " + res.descripcion + " / " + res.costoReal);
    //     setState(() {
    //       _todoList.add(res);
    //     });
    //   });
    // }
  }

 _signOut() async {
    try {
      await widget.auth.signOut();
      widget.onSignedOut();
    } catch (e) {
      print(e);
    }
 }


onTabTapped(int index) {
   setState(() {
   switch (index) {
     case 0:
      appBarTitleText = Text('Home');
      _body = null;
      _currentIndex = index;
       break;
     case 1:
      appBarTitleText = Text('Tienda'); 
       _currentIndex = index;
      //  _body = showTodoList(_todoList);
       break;
    case 2:
      appBarTitleText = Text('Facturas');
       _currentIndex = index;
       break;
    case 3:
      appBarTitleText = Text('Carrito');
       _currentIndex = index;
       break;
    case 4:
      appBarTitleText = Text('Perfil');
      _body = showProfile();
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
                icon: Icon(Icons.store_mall_directory),
                title: Text('Tienda') ),
              new BottomNavigationBarItem(
                icon: Icon(Icons.attach_money),
                title: Text('Facturas') ),
              new BottomNavigationBarItem(
                icon: Icon(Icons.shopping_cart),
                title: Text('Carrito') ),
              new BottomNavigationBarItem(
                icon: Icon(Icons.person),
                title: Text('Perfil') ),
          ] 
        ),
    );
  }
  
}


  