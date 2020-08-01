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

  Widget _getVoluntiersCard() {
    return Card(
      elevation: 10.0,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTile(
            leading: Icon(Icons.people),
            contentPadding: EdgeInsets.only(left: 15.0, right: 40.0, top: 10.0),
            title: Text(
              'Voluntarios',
            ),
            subtitle: Text(
                'Los voluntarios asisten a los que necesitan de ayuda ¡Únete al programa!'),
            isThreeLine: true,
          ),
          ButtonBar(
            children: <Widget>[
              FlatButton(
                child: const Text('SER VOLUNTARIO'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => VoluntierEnrollmentPage()),
                  );
                },
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
        height: 380,
        child: Card(
          elevation: 10.0,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const ListTile(
                leading: Icon(Icons.trending_up),
                title: Text('Estadísticas'),
                subtitle: Text('Resumen del estado actual de las alertas'),
                isThreeLine: true,
              ),
              IntrinsicHeight(
                  child: Padding(
                      padding: EdgeInsets.only(bottom: 20.0),
                      child: Row(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Container(
                              height: 260,
                              width: 170,
                              padding: EdgeInsets.all(8),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: <Widget>[
                                  const Text(
                                    "10",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontSize: 80.0),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Text(
                                      "Casos abiertos",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Theme.of(context).accentColor,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 3,
                                    child: Icon(
                                      Icons.warning,
                                      size: 100,
                                      color: Theme.of(context).accentColor,
                                    ),
                                  )
                                ],
                              ),
                              decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5.0)),
                                  border: Border.all(color: Colors.grey[200])),
                            ),
                            Container(
                              height: 260,
                              width: 170,
                              padding: EdgeInsets.all(8),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: <Widget>[
                                  const Text(
                                    "0",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontSize: 80.0),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Text(
                                      "Casos cerrados",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Colors.green[700],
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 3,
                                    child: Icon(
                                      Icons.check_circle_outline,
                                      size: 100,
                                      color: Colors.green[700],
                                    ),
                                  )
                                ],
                              ),
                              decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5.0)),
                                  border: Border.all(color: Colors.grey[200])),
                            ),
                          ])))
            ],
          ),
        ));
  }
}
