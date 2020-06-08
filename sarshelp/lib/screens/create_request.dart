
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CreateRequestPage extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                      Scaffold
                          .of(context)
                          .showSnackBar(SnackBar(content: Text('Processing Data')));
                    }
                  },
                  child: Text('Enviar'),
              ),
            ]
      )) 
),
    );
  }
  
}
