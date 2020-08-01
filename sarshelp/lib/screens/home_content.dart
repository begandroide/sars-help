import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sarshelp/screens/voluntier-enrollment.dart';

class HomeContent extends StatefulWidget {
  @override
  _HomeContentState createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  BuildContext context;

  @override
  Widget build(BuildContext context) {
    this.context = context;
    return showHomeContent();
  }

  Widget showHomeContent() {
    return new SingleChildScrollView(
        child: Center(
            child: Column(
      children: <Widget>[
        _getWelcomeHeader(),
        _getVoluntiersCard(),
        _getGeneralStatistics()
      ],
    )));
  }

  Widget _getWelcomeHeader() {
    return Container(
      alignment: Alignment.centerLeft,
      height: 50.0,
      margin: EdgeInsets.only(left: 15.0, right: 15.0, top: 10.0),
      child: RichText(
          text: TextSpan(
              text: 'Bienvenid@ ',
              style: DefaultTextStyle.of(context).style,
              children: <TextSpan>[
            TextSpan(
                text: 'Benjamín',
                style: TextStyle(fontWeight: FontWeight.bold)),
            TextSpan(text: ' !')
          ])),
    );
  }

  void onVoluntierTapped() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => VoluntierEnrollmentPage()),
    );
  }

  Widget _getVoluntiersCard() {
    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const ListTile(
              leading: Icon(Icons.people),
              contentPadding:
                  EdgeInsets.only(left: 15.0, right: 40.0, top: 10.0),
              title: Text(
                'Voluntarios',
              ),
              subtitle: Text(
                  'Los voluntarios asisten a los que necesitan de ayuda ¡Únete al programa!'),
              isThreeLine: true,
              onTap: () {
                onVoluntierTapped()
              } 
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
    );
  }

  Widget _getGeneralStatistics() {
    return SizedBox(
        height: 400,
        child: Card(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const ListTile(
                leading: Icon(Icons.trending_up),
                title: Text('Estadísticas'),
                subtitle: Text('Resumen del estado actual de las alertas'),
                isThreeLine: true,
              )
            ],
          ),
        ));
  }
}
