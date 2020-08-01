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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text('Ser voluntario'),
        ),
        body: SingleChildScrollView(
            child: Form(
                key: _formKey,
                child: Card(
                  child: Column(children: <Widget>[
                    Text("Los voluntarios nos ayudan a atender las solicitudes de ayuda"),
                    RaisedButton(
                        color: Colors.redAccent,
                        textColor: Colors.white,
                        onPressed: () {
                          final snackBarOnSuccess = SnackBar(
                              content: Text('Guardado correctamente...!'));
                          final snackBar =
                              SnackBar(content: Text('Procesando datos...'));
                          _scaffoldKey.currentState.showSnackBar(snackBar);
                        },
                        child: _buttonSave()),
                ])))));
  }

  _buttonSave() {
    Widget contentButton;
    if (this.isProcessingData) {
      contentButton = CircularProgressIndicator();
    } else {
      contentButton = Text('Enviar');
    }
    return contentButton;
  }
}
