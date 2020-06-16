import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sarshelp/services/authentication.dart';

class SingUpPage extends StatefulWidget {
  SingUpPage({Key key, this.auth}) : super(key: key);

  final BaseAuth auth;

  @override
  State<StatefulWidget> createState() => new _SignUpPageState();
}
class FormSignup {
  String email;
  String password;
  String names;
  String surnames;
  DateTime birthdate;
  GeoPoint address;
  
  Form() {
    this.email = '';
    this.password = '';
    this.names = '';
  }
}

class _SignUpPageState extends State<SingUpPage> {
  final _formKey = new GlobalKey<FormState>();
  FormSignup userFormInputs = new FormSignup(); 
  
  String _errorMessage;
  int currentStep = 0;
  bool complete = false;

  bool _isLoading;
  List<Step> steps = [];
  DateTime selectedDate = DateTime.now();

  Future<Null> _selectDate() async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(1940, 1),
        lastDate: DateTime(2030),
        cancelText: "CANCELAR",
        
      );
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
  }
  @override
  Widget build(BuildContext context) {
    steps = getSteps();
    return new Scaffold(
        appBar: AppBar(
          title: Text('Crear cuenta'),
        ),
        body: Column(children: <Widget>[
          Expanded(
            child: Stepper(
              steps: steps,
              currentStep: currentStep,
              onStepContinue: next,
              onStepTapped: (step) => goTo(step),
              onStepCancel: cancel,
              controlsBuilder: ( BuildContext context, {VoidCallback onStepContinue, VoidCallback onStepCancel} ) {
                return Row(
                  children: <Widget>[
                    FlatButton(
                      onPressed: onStepContinue,
                      child: const Text('Continuar'),
                    ),
                    FlatButton(
                      onPressed: onStepCancel,
                      child: const Text('Cancelar'),
                    ),
                  ],
                );
              }
            ),
          )
        ]));
  }

  next() {
    currentStep + 1 != steps.length
        ? goTo(currentStep + 1)
        : setState(() => complete = true);
  }

  cancel() {
    if (currentStep > 0) {
      goTo(currentStep - 1);
    }
  }

  goTo(int step) {
    setState(() => currentStep = step);
  }

  
  Widget _showPasswordInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
      child: new TextFormField(
        maxLines: 1,
        obscureText: true,
        autofocus: false,
        decoration: new InputDecoration(
            hintText: 'Contraseña',
            icon: new Icon(
              Icons.lock,
              color: Colors.grey,
            )),
        validator: (value) => value.isEmpty ? 'Debe ingresar una contraseña' : null,
        onSaved: (value) => userFormInputs.password = value,
      ),
    );
  }
  
  Widget _showEmailInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
      child: new TextFormField(
        maxLines: 1,
        keyboardType: TextInputType.emailAddress,
        autofocus: false,
        decoration: new InputDecoration(
            hintText: 'Correo electrónico',
            icon: new Icon(
              Icons.mail,
              color: Colors.grey,
            )),
        validator: (value) => value.isEmpty ? 'Correo no puede ser vacío' : null,
        onSaved: (value) => userFormInputs.email = value,
      ),
    );
  }


  List<Step> getSteps() {
    return [
    Step(
      title: const Text('Nueva Cuenta'),
      isActive: true,
      state: StepState.indexed,
      content: Column(
        children: <Widget>[
          _showEmailInput(),
          _showPasswordInput()
        ],
      ),
    ),
    Step(
      isActive: false,
      state: StepState.indexed,
      title: const Text('Datos Personales'),
      content: Column(
        children: <Widget>[
          TextFormField(
            decoration: InputDecoration(labelText: 'Nombres'),
          ),
          TextFormField(
            decoration: InputDecoration(labelText: 'Apellidos'),
          ),
          TextFormField(
            onTap: () => {
              _selectDate()
            },
            initialValue: "${selectedDate.toLocal()}".split(' ')[0],
            decoration: InputDecoration(labelText: 'Fecha nacimiento'),
          ),
        ],
      ),
    ),
    Step(
      state: StepState.indexed,
      title: const Text('Dirección'),
      subtitle: const Text("Error!"),
      content: Column(
        children: <Widget>[
          CircleAvatar(
            backgroundColor: Colors.red,
          )
        ],
      ),
    ),
  ];
  }
}