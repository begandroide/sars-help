import 'package:flutter/material.dart';
import 'package:sarshelp/services/authentication.dart';

class SingUpPage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => new _SignUpPageState();
}

class _SignUpPageState extends State<SingUpPage> {
  final _formKey = new GlobalKey<FormState>();
  String _email;
  String _password;
  String _errorMessage;
  
  int currentStep = 0;
  bool complete = false;

  bool _isLoading;
  List<Step> steps = [];
    
  
  @override
  Widget build(BuildContext context) {
    steps = getSteps();
    return new Scaffold(
        appBar: AppBar(
          title: Text('Create an account'),
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

  Widget _showCircularProgress(){
    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    } return Container(height: 0.0, width: 0.0,);

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
        onSaved: (value) => _password = value,
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
        onSaved: (value) => _email = value,
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