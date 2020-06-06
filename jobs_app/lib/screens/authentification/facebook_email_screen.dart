import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as JSON;

import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:jobs_app/providers/users.dart';
import 'package:provider/provider.dart';

import '../../widgets/auth_button.dart';
import '../../widgets/divider.dart';
import '../../exceptions/http_exception.dart';
import '../../providers/auth.dart';
import 'login_screen.dart';

class FacebookEmailScreen extends StatefulWidget {
  static const routeName = '/facebook_email';

  @override
  _FacebookEmailScreenState createState() => _FacebookEmailScreenState();
}

class _FacebookEmailScreenState extends State<FacebookEmailScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  int dropdownAgeValue;
  String dropdownGenderValue;
  var _isLoading = false;
  var _expanded = false;
  final facebookLogin = FacebookLogin();
  bool _isLoggedIn = false;
  Map userProfile = null;

  Map<String, String> _authData = {
    'email': '',
    'firstName': '',
    'lastName': '',
    'birthYear': '',
    'gender': '',
    'password': '',
    'facebook_id': '',
  };

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) =>
          AlertDialog(
            title: Text('An Error Occurred'),
            content: Text(message),
            actions: <Widget>[
              FlatButton(
                child: Text('Okay'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          ),
    );
  }

  Future<Null> _showSuccessDialog() async {
    var returnVal = await showDialog(
      context: context,
      barrierDismissible: true,
      builder: (ctx) =>
          AlertDialog(
            title: Text('Hurray! You now have an account!'),
            content: Text('Now you can start search for new jobs or offer '
                'some amazing oportunities to other candidates.'),
            actions: <Widget>[
              FlatButton(
                child: Text('Okay'),
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pushReplacementNamed(
                      LoginScreen.routeName);
                },
              )
            ],
          ),
    );
    //print(returnVal);
    if (returnVal == null) {
      Navigator.of(context).pushReplacementNamed(LoginScreen.routeName);
    }
  }

  void _logout() {
    print('sal');
    facebookLogin.logOut();
    setState(() {
      _isLoggedIn = false;
    });
  }

  Future<void> _submit(String data) async {
    var rez = JSON.json.decode(data);
    //print(rez);

    _authData['firstName'] = rez['first_name'];
    _authData['lastName'] = rez['last_name'];
    var year = rez['birthday'].substring(rez['birthday'].length - 4);
    print(year);
    _authData['birthYear'] = year;
    if(rez['gender'] == 'male') {
    _authData['gender'] = '0';
    } else if (rez['gender'] == 'female') {
    _authData['gender'] = '1';
    } else {
    _authData['gender'] = '2';
    }
    _authData['facebook_id'] = rez['id'];

    if (!_formKey.currentState.validate()) {
    // Invalid!
    return;
    }
    _formKey.currentState.save();
    if (mounted) {
    setState(() {
    _isLoading = true;
    });
    }
    var foundError = false;
    try {
//      await Provider.of<Auth>(context, listen: false).loginWithFacebook(
//        _authData['email'],
//        _authData['password'],
//        _authData['firstName'],
//        _authData['lastName'],
//        _authData['birthYear'],
//        _authData['gender'],
//        _authData['facebook_id'],
//      );
    } on HttpException catch (error) {
    foundError = true;
    var errorMessage = 'Authentication failed';
    if (error.toString().contains('EMAIL_EXISTS')) {
    errorMessage = 'This email adress is already in use.';
    } else if (error.toString().contains('INVALID_EMAIL')) {
    errorMessage = 'This is not a valid email adress.';
    } else if (error.toString().contains('WEAK_PASSWORD')) {
    errorMessage = 'This password is too weak.';
    } else if (error.toString().contains('EMAIL_NOT_FOUND')) {
    errorMessage = 'Could not found an user with that email.';
    } else if (error.toString().contains('INVALID_PASSWORD')) {
    errorMessage = 'Invalid password.';
    }
    _showErrorDialog(errorMessage);
    } catch (errorMessage) {
    foundError = true;
    print(errorMessage);
    var error = 'Could not authenticate you. Please try again later.';
    _showErrorDialog(error);
    }

    await Provider.of<Users>(
      context,
      listen: false,
    ).fetchAndSetUser();

    if (foundError == false) {
    _showSuccessDialog();
    }

    if (mounted) {
    setState(() {
    _isLoading = false;
    });
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery
        .of(context)
        .size;
    final data = ModalRoute
        .of(context)
        .settings
        .arguments as String;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(
          color: Theme
              .of(context)
              .primaryColor,
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          height: deviceSize.height,
          color: Colors.white,
          child: Column(
            children: <Widget>[
              Container(
                margin: const EdgeInsets.only(
                  top: 60,
                  left: 25,
                  right: 25,
                ),
                child: const Text(
                  'Introdu adresa de email pentru a creea contul!',
                  style: TextStyle(
                    fontSize: 33,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(
                  top: 40,
                  left: 25,
                  right: 25,
                ),
                color: Colors.white,
                //height: deviceSize.height,
                width: deviceSize.width,
                child: Form(
                  key: _formKey,

                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        height: 5,
                      ),
                      Container(
                        color: Colors.white,
                        child: TextFormField(
                          decoration: InputDecoration(
                            //contentPadding: EdgeInsets.only(top: 5, bottom: 5),
                            labelText: 'E-Mail',
                            prefixIcon: Icon(Icons.mail_outline),
                            border: OutlineInputBorder(
                              borderRadius: new BorderRadius.circular(30.0),
                              borderSide: const BorderSide(
                                  color: Colors.grey, width: 0.0),
                            ),
                            fillColor: Colors.white,
                            focusColor: Colors.white,
                          ),
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value.isEmpty || !value.contains('@')) {
                              return 'Invalid email!';
                            }
                          },
                          onSaved: (value) {
                            _authData['email'] = value;
                          },
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Container(
                        width: double.infinity,
                        child: RaisedButton(
                          onPressed: () {
                            _submit(data);
                          },
                          color: Theme
                              .of(context)
                              .primaryColor,
                          textColor: Color(0xff075E54),
                          padding:
                          EdgeInsets.symmetric(vertical: 16, horizontal: 30),
                          child: Text(
                            'ÎNSCRIE-TE',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white,
                            ),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(30.0),
                            side: BorderSide(
                              color: Color(0xff075E54),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
