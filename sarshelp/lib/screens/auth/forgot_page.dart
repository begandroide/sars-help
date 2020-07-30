import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sarshelp/screens/auth/signup_page.dart';
import 'package:sarshelp/services/authentication.dart';

class ForgotPage extends StatefulWidget {
  ForgotPage({this.auth});

  final BaseAuth auth;

  @override
  State<StatefulWidget> createState() => new _ForgotPageState();
}

class _ForgotPageState extends State<ForgotPage> {
  final _formKey = new GlobalKey<FormState>();

  String _email;
  String _errorMessage;
  bool _hasErrors;
  bool _isIos;
  bool _isLoading;

  // Check if form is valid before perform login or signup
  bool _validateAndSave() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  // Perform login or signup
  _validateAndSubmit() async {
    setState(() {
      _hasErrors = false;
      _errorMessage = "";
      _isLoading = true;
    });
    if (_validateAndSave()) {
      try {
        widget.auth
            .forgotPassword(_email)
            .catchError((er) => {
                  print(er),
                  setState(() {
                    _isLoading = false;
                    _hasErrors = true;
                    if (_isIos) {
                      _errorMessage = er.details;
                    } else
                      _errorMessage = "Hemos tenido un problema con tu correo";
                  })
                })
            .whenComplete(() => {
                  setState(() {
                    _isLoading = false;
                  }),
                  if (!_hasErrors)
                    {
                      print("Email enviado o denegado"),
                      Navigator.pushNamedAndRemoveUntil(
                          context, '/', (_) => false)
                    }
                });
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

  @override
  void initState() {
    _errorMessage = "";
    _isLoading = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _isIos = Theme.of(context).platform == TargetPlatform.iOS;
    return new Scaffold(
        appBar: new AppBar(
          title: Text('Sars Help'),
        ),
        body: Stack(
          children: <Widget>[
            _showBody(),
            _showCircularProgress(),
          ],
        ));
  }

  Widget _showCircularProgress() {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    }
    return Container(
      height: 0.0,
      width: 0.0,
    );
  }

  Widget _showBody() {
    return new Container(
        padding: EdgeInsets.all(16.0),
        child: new Form(
          key: _formKey,
          child: new ListView(
            shrinkWrap: true,
            children: <Widget>[
              _showLogo(),
              _showEmailInput(),
              _showPrimaryButton(),
              _showErrorMessage(),
            ],
          ),
        ));
  }

  Widget _showErrorMessage() {
    if (_errorMessage.length > 0 && _errorMessage != null) {
      return new Container(
          padding: EdgeInsets.all(10.0),
          child: Text(
            _errorMessage,
            style: TextStyle(
                fontSize: 13.0,
                color: Colors.red,
                height: 1.0,
                fontWeight: FontWeight.w300),
          ));
    } else {
      return new Container(
        height: 0.0,
      );
    }
  }

  Widget _showLogo() {
    return new Hero(
      tag: 'hero',
      child: Padding(
        padding: EdgeInsets.fromLTRB(0.0, 70.0, 0.0, 0.0),
        child: CircleAvatar(
          backgroundColor: Colors.transparent,
          radius: 48.0,
          child: Image.asset('assets/logo.png'),
        ),
      ),
    );
  }

  Widget _showEmailInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 100.0, 0.0, 0.0),
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
        validator: (value) =>
            value.isEmpty ? 'Correo no puede ser vacío' : null,
        onSaved: (value) => _email = value,
      ),
    );
  }

  Widget _showPrimaryButton() {
    return new Padding(
        padding: EdgeInsets.fromLTRB(0.0, 45.0, 0.0, 0.0),
        child: SizedBox(
          height: 40.0,
          child: new RaisedButton(
            elevation: 5.0,
            shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(30.0)),
            color: Colors.blue,
            child: new Text('Recuperar contraseña',
                style: new TextStyle(fontSize: 20.0, color: Colors.white)),
            onPressed: _validateAndSubmit,
          ),
        ));
  }
}
