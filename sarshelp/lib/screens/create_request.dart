
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CreateRequestPage extends StatefulWidget {
  @override
  _CreateRequestPageState createState() => _CreateRequestPageState();
}

class _CreateRequestPageState extends State<CreateRequestPage> {
  final _formKey = GlobalKey<FormState>();

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  bool isProcessingData = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Nueva solicitud'),
      ),
      body: Form(
        key: _formKey,
        child: Card(
          child: Column(
            children:<Widget>[
              TextFormField(
                keyboardType: TextInputType.number,
                maxLength: 1,
                validator: (value) {
                  if (value.isEmpty) {
                    return 'El grado es un campo requerido';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Grado *'
                ),
                 inputFormatters: <TextInputFormatter>[
                    WhitelistingTextInputFormatter.digitsOnly
                ], // Only numbers can be entered
              ),
              TextFormField(
                maxLength: 40,
                validator: (value) {
                  if (value.isEmpty) {
                    return 'El nombre corto es un campo requerido';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Nombre corto *'
                ),
              ),
              TextFormField(
                maxLines: 5,
                maxLength: 500,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  alignLabelWithHint: true,
                  labelText: 'Descripción *'
                ),
              ),
              RaisedButton(
                onPressed: () {
                  if (_formKey.currentState.validate()) {

                      final snackBar = SnackBar(content: Text('Procesando datos...'));
                      _scaffoldKey.currentState.showSnackBar(snackBar);
                      FirebaseAuth.instance.currentUser().then((value) => {
                        // Firestore.instance.collection('HelpRequests').document(value.uid).setData({})

                      });
                    }
                  },
                  child: _buttonSave()
              ),
              _buttonSave()
            ]
      )) 
),
    );
  }

  _buttonSave() {
    Widget contentButton;
    if (this.isProcessingData){
      contentButton = CircularProgressIndicator();
    } else {
      contentButton = Text('Enviar'); 
    }
    return contentButton;
  }

}
