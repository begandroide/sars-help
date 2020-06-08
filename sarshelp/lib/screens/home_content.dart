
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return showHomeContent(context);
  }

}

Widget showHomeContent(BuildContext context) {
  return Center(
      child: Column(children: <Widget>[
        Container(
          alignment: Alignment.centerLeft,
          height: 50.0,
          margin: EdgeInsets.only(left: 15.0, right: 15.0, top: 10.0),
          child:RichText(
            text: TextSpan(
              text:'Bienvenid@ ',
              style: DefaultTextStyle.of(context).style,
              children: <TextSpan>[
                TextSpan(text: 'Benjamín', style: TextStyle(fontWeight: FontWeight.bold)),
                TextSpan(text: ' !')
              ]
            )
          ),
        ),
        Card(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const ListTile(
                leading: Icon(Icons.people),
                contentPadding: EdgeInsets.only(left: 15.0,right: 40.0, top:10.0),
                title: Padding(
                  padding: EdgeInsets.only(bottom:5),
                  child: 
                    Text(
                      'Voluntarios',
                      ),
                  ),
                subtitle: Text('Los voluntarios asisten a los que necesitan de ayuda.'),
              ),
              ButtonBar(
                children: <Widget>[
                  FlatButton(
                    child: const Text('SER VOLUNTARIO'),
                    onPressed: () {/* ... */},
                  ),
                  FlatButton(
                    child: const Text('MÁS INFO'),
                    onPressed: () {/* ... */},
                  ),
                ],
              ),
            ],
          ),
        ),
        Card(

          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const ListTile(
                leading: Icon(Icons.album),
                title: Text('The Enchanted Nightingale'),
                subtitle: Text('Music by Julie Gable. Lyrics by Sidney Stein.'),
              ),
              ButtonBar(
                children: <Widget>[
                  FlatButton(
                    child: const Text('BUY TICKETS'),
                    onPressed: () {/* ... */},
                  ),
                  FlatButton(
                    child: const Text('LISTEN'),
                    onPressed: () {/* ... */},
                  ),
                ],
              ),
            ],
          ),
        ),
  
      ],) 
    );
}