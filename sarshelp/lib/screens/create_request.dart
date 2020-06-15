
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
  double _grade = 1.0;
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
                FormField(
                  builder: (FormFieldState state) {
                    return
                      Container(
                        decoration: BoxDecoration(border: Border.all(color: Colors.grey), borderRadius: BorderRadius.circular(5)),
                        margin: EdgeInsets.only(top:20.0, bottom: 20.0),
                        child:
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                margin: EdgeInsets.only(left: 15, top: 10),
                                child: Text('Grado *', style: TextStyle(fontWeight: FontWeight.w400),),
                              ),
                              Row(
                                children: <Widget>[
                                  Container(
                                    width: MediaQuery.of(context).size.width - MediaQuery.of(context).size.width/6,
                                    child: 
                                      Slider(
                                        min: 1.0,
                                        max: 5.0,
                                        divisions: 4,
                                        label: _grade.round().toString(),
                                        activeColor: Colors.redAccent,
                                        value: _grade,
                                        onChanged: (value) => {
                                          setState(() => {
                                            _grade = value,
                                          })
                                        }
                                      ),
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.help),
                                    onPressed: () => {
                                      showDialog(
                                        context: context,
                                        builder: (_) => AlertDialog(
                                            title: Text('¿Qué es el Grado?'),
                                            content: SingleChildScrollView(
                                              child: ListBody(
                                                children: <Widget>[
                                                  Text('Es una puntuación de la estimación de la gravedad o urgencia de una petición.'),
                                                  Container(
                                                    alignment: Alignment.centerLeft,
                                                    child: Row(children: <Widget>[
                                                      Text('● Nivel 1:')
                                                    ],
                                                    )
                                                  )
                                                ],
                                              ),
                                            ),
                                            actions: <Widget>[
                                              FlatButton(
                                                child: Text('Approve'),
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                              ),
                                            ],
                                        )
                                    )
                                    },
                                    color: Colors.blueGrey
                                  ),
                                ],
                              ),]));
                  }),
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
                            'grade': _grade.floor(),
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
        )
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
