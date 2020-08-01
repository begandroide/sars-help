import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class VoluntierEnrollmentPage extends StatefulWidget {
  @override
  _VoluntierEnrollmentPageState createState() =>
      _VoluntierEnrollmentPageState();
}

class _VoluntierEnrollmentPageState extends State<VoluntierEnrollmentPage> {
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  bool isProcessingData = false;
  final String beVoluntierTitle = "Ser voluntario";
  final String voluntierMessage =
      "Los voluntarios ayudan a la comunidad atendiento las solicitudes de ayuda dentro de su misma comunidad.";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text(beVoluntierTitle),
        ),
        body: SingleChildScrollView(
            child: Form(
                key: _formKey,
                child: Card(
                    margin: EdgeInsets.all(20.0),
                    elevation: 10.0,
                    child: Column(children: <Widget>[
                      Icon(Icons.group,
                          size: 150.0,
                          color: Theme.of(context).primaryColorLight),
                      Container(
                          alignment: Alignment.bottomLeft,
                          padding: EdgeInsets.all(15.0),
                          child: Column(children: <Widget>[
                            Text(voluntierMessage,
                                textAlign: TextAlign.justify),
                            Padding(
                                padding: EdgeInsets.only(top: 10.0),
                                child: Text(
                                  "¡Anímate y únete a la red de voluntarios!",
                                  style: TextStyle(fontSize: 20.0),
                                  textAlign: TextAlign.center,
                                ))
                          ])),
                      Padding(
                        padding: EdgeInsets.all(20),
                        child: RaisedButton(
                            color: Colors.redAccent,
                            textColor: Colors.white,
                            padding: EdgeInsets.all(10),
                            onPressed: () {
                              final snackBar = SnackBar(
                                  content: Text('Procesando datos...'));
                              _scaffoldKey.currentState.showSnackBar(snackBar);
                              _enroll();
                            },
                            child: _buttonSave()),
                      )
                    ])))));
  }

  _enroll() {
    String userUID;
    String userName;
    String email;
    final snackBarOnSuccess =
        SnackBar(content: Text('Bienvenido al programa! Redirigiendo...'));
    final snackBarOnFailure =
        SnackBar(content: Text('Tu ya eres parte del programa'));

    FirebaseAuth.instance.currentUser().then((value) => {
          userUID = value.uid,
          userName = value.displayName,
          email = value.email,
          Firestore.instance
              .document('Voluntiers/' + value.uid)
              .get()
              .then((value) => {
                    print(value),
                    if (!value.exists)
                      {
                        Firestore.instance
                            .collection('Voluntiers')
                            .document(userUID)
                            .setData({
                          'enrollTime': DateTime.now(),
                          'attended': 0,
                          'displayName': userName,
                          'emailAddress': email
                        }).whenComplete(() => {
                                  _scaffoldKey.currentState
                                      .showSnackBar(snackBarOnSuccess),
                                  Timer(Duration(seconds: 5),
                                      () => {Navigator.pop(context)})
                                })
                      }
                    else
                      {
                        _scaffoldKey.currentState
                            .showSnackBar(snackBarOnFailure)
                      }
                  })
              .catchError((error) => {print(error)})
        });
  }

  _buttonSave() {
    Widget contentButton;
    if (this.isProcessingData) {
      contentButton = CircularProgressIndicator();
    } else {
      contentButton = Text(
        'Unirse al voluntariado',
        style: TextStyle(fontSize: 20.0),
      );
    }
    return contentButton;
  }
}
