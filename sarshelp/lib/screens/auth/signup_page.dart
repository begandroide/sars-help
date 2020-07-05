import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sarshelp/services/authentication.dart';
import 'package:search_map_place/search_map_place.dart';

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
  bool _isIos;
  bool _isLoading;
  List<Step> steps = [];
  DateTime selectedDate;

  Future<Null> _selectDate() async {
    final DateTime picked = await showDatePicker(
        locale: Locale('es', 'CL'),
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1940, 1),
        lastDate: DateTime(2030),
        helpText: "Ingresa tu fecha de nacimiento"
      );
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        userFormInputs.birthdate = selectedDate;
      });
  }
  @override
  Widget build(BuildContext context) {
    steps = getSteps();
    _isIos = Theme.of(context).platform == TargetPlatform.iOS;
    return new Scaffold(
        appBar: AppBar(
          title: Text('Crear cuenta'),
        ),
        body: SingleChildScrollView(
          child:
        new Form(
          key: _formKey,
          child:
         Column(children: <Widget>[
          new SizedBox(
          height: MediaQuery.of(context).size.height - MediaQuery.of(context).size.height/5,
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
          ),
          _showPrimaryButton()
        ]))));
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
Widget _getDatePickerEnabled() {
    return InkWell(
      onTap: () {
        _selectDate();
      },
      child: InputDecorator(
        decoration: InputDecoration(labelText: 'Fecha nacimiento'),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Text(
              selectedDate == null ? '' :
              "${selectedDate.toLocal()}".split(' ')[0],
            ),
            Icon(Icons.arrow_drop_down,
                color: Theme.of(context).brightness == Brightness.light
                    ? Colors.grey.shade700
                    : Colors.white70),
          ],
        ),
      ),
    );
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
              maxLines: 1,
              keyboardType: TextInputType.text,
              autofocus: false,
              decoration: new InputDecoration(
                  hintText: 'Nombres',
                  ),
              validator: (value) => value.isEmpty ? 'El nombre es requerido' : null,
              onSaved: (value) => userFormInputs.names= value,
            ),
            TextFormField(
              maxLines: 1,
              keyboardType: TextInputType.text,
              autofocus: false,
              decoration: new InputDecoration(
                  hintText: 'Apellidos',
                  ),
              validator: (value) => value.isEmpty ? 'El apellido es requerido' : null,
              onSaved: (value) => userFormInputs.surnames = value,
            ),
            _getDatePickerEnabled(),
          ],
        ),
      ),
    ];
  }
    Widget _showPrimaryButton() {
    return new SizedBox(
          // height: MediaQuery.of(context).size.height/6,
          child: new RaisedButton(
            elevation: 5.0,
            shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
            color: Colors.blue,
            child: new Text('Registrarse',
                    style: new TextStyle(fontSize: 20.0, color: Colors.white) ),
            onPressed: _validateAndSubmit,
          ),
        );
  }

  
  // Perform login or signup
  _validateAndSubmit() async {
    setState(() {
      _errorMessage = "";
      _isLoading = true;
    });
    if (_validateAndSave()) {
      String userId = "";
      try {
        userId = await widget.auth.signUp(userFormInputs.email, userFormInputs.password);
        print('Signed up user: $userId');
        Firestore.instance.collection('Users').document(userId).setData({
          'birthdate': userFormInputs.birthdate,
          'name': userFormInputs.names,
          'lastName': userFormInputs.surnames, 
          'address': GeoPoint(-33.04, -71.59)
        });
        setState(() {
          _isLoading = false;
        });

        if (userId.length > 0 && userId != null) {
          // mostrar pantalla de registro de datos de usuario y luego mostrar onSignedId          
          // widget.onSignedIn();
          Navigator.pushNamedAndRemoveUntil(context, '/Home', (_)=>false);
        }

      } catch (e) {
        print('Error: $e');
        setState(() {
          _isLoading = false;
          if (_isIos) {
            _errorMessage = e.details;
          } else
            _errorMessage = e.message;
        });
      }
    }
  }
  // Check if form is valid before perform login or signup
  bool _validateAndSave() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }
}