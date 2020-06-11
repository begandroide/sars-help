
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocation/geolocation.dart';
import 'package:location_permissions/location_permissions.dart';

class CreateRequestPage extends StatefulWidget {
  @override
  _CreateRequestPageState createState() => _CreateRequestPageState();
}

class _CreateRequestPageState extends State<CreateRequestPage> {
  // best option for most cases
  static PermissionStatus permission;
  StreamSubscription<LocationResult> subscription = Geolocation.currentLocation(accuracy: LocationAccuracy.best).listen((result) async {
    var perm = await LocationPermissions().checkPermissionStatus(level: LocationPermissionLevel.locationWhenInUse);
    switch (perm) {
      case PermissionStatus.denied:
        permission = await LocationPermissions().requestPermissions(permissionLevel: LocationPermissionLevel.locationWhenInUse);
        if(result.isSuccessful) {
          double latitude = result.location.latitude;
          // todo with result
        } 
        break;
      case PermissionStatus.granted:
          double latitude = result.location.latitude;
          break;
      default:
    }
  });
  final _formKey = GlobalKey<FormState>();
  String _grade;
  String _shortName;
  String _description;

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  bool isProcessingData = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Nueva solicitud'),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Card(
            child: Column(
              children:<Widget>[
                TextFormField(
                  keyboardType: TextInputType.number,
                  maxLength: 1,
                  onSaved: (value) => _grade = value,
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
                  onSaved: (value) => _shortName = value,
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
                  onSaved: (value) => _description = value,
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'La descripción es un campo requerido';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    alignLabelWithHint: true,
                    labelText: 'Descripción *'
                  ),
                ),
                RaisedButton(
                  color: Colors.redAccent,
                  textColor: Colors.white,
                  onPressed: () {
                    if (_formKey.currentState.validate()) {
                        final snackBarOnSuccess = SnackBar(content: Text('Guardado correctamente...!'));
                        final snackBar = SnackBar(content: Text('Procesando datos...'));
                        _scaffoldKey.currentState.showSnackBar(snackBar);
                        _formKey.currentState.save();
                        FirebaseAuth.instance.currentUser().then((value) => {
                          Firestore.instance.collection('HelpRequests/' + value.uid + '/userRequests').add({
                            'datetime': DateTime.now(),
                            'description': _description,
                            'grade': _grade,
                            'shortName': _shortName,
                            'isClosed': false
                          }).whenComplete(() => 
                          {
                            _scaffoldKey.currentState.showSnackBar(snackBarOnSuccess),
                            Navigator.pop(
                              context
                            )
                          }
                          )
                        });
                      }
                    },
                    child: _buttonSave()
                ),
              ]
            )
          ) 
        ),
      )
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
