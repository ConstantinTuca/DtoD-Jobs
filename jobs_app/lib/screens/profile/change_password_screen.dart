import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as JSON;

import 'package:provider/provider.dart';

import '../../providers/users.dart';
import '../../exceptions/http_exception.dart';
import '../../models/user.dart';
import '../navigation_screen.dart';

class ChangePasswordScreen extends StatefulWidget {
  static const routeName = '/change-password';

  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  var _isLoading = false;
  var _expanded = false;
  String _newPassword;
  String _oldPassword;


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
            title: Text('You have succesfully changed your password!'),
            actions: <Widget>[
              FlatButton(
                child: Text('Okay'),
                onPressed: () {
                  Navigator.of(context).popUntil((route) => route.isFirst);
                },
              )
            ],
          ),
    );
    //print(returnVal);
    if (returnVal == null) {
      Navigator.of(context).popUntil((route) => route.isFirst);
    }
  }

  Future<void> _submit(User currentUser) async {

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
      await Provider.of<Users>(context, listen: false).changePassword(_oldPassword, _newPassword);
    } on HttpException catch (error) {
      foundError = true;
      var errorMessage = 'Pssword change failed';
      if (error.toString().contains('not correct')) {
        errorMessage = 'Invalid password.';
      }
      _showErrorDialog(errorMessage);
    } catch (errorMessage) {
      foundError = true;
      var error = 'Could not change password. Please try again later.';

      if (errorMessage.toString().contains('not correct')) {
        error = 'Invalid password.';
      }

      _showErrorDialog(error);
    }

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
    final _cureentUser = ModalRoute
        .of(context)
        .settings
        .arguments as User;

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
                  'Schimbă parola',
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
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Parola curentă',
                          prefixIcon: Icon(Icons.lock_outline),
                          border: OutlineInputBorder(
                            borderRadius: new BorderRadius.circular(30.0),
                            borderSide: const BorderSide(
                                color: Colors.grey, width: 0.0),
                          ),
                          fillColor: Colors.white,
                          focusColor: Colors.white,
                        ),
                        obscureText: true,
                        controller: _oldPasswordController,
                        validator: (value) {
                          if (value.isEmpty || value.length < 8) {
                            return 'Password is too short!';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _oldPassword = value;
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Parolă (minim 8 caractere)',
                          prefixIcon: Icon(Icons.lock_outline),
                          border: OutlineInputBorder(
                            borderRadius: new BorderRadius.circular(30.0),
                            borderSide: const BorderSide(
                                color: Colors.grey, width: 0.0),
                          ),
                          fillColor: Colors.white,
                          focusColor: Colors.white,
                        ),
                        obscureText: true,
                        controller: _newPasswordController,
                        validator: (value) {
                          if (value.isEmpty || value.length < 8) {
                            return 'Password is too short!';
                          }
                        },
                        onSaved: (value) {
                          _newPassword = value;
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Confirmă parola',
                          prefixIcon: Icon(Icons.lock),
                          border: OutlineInputBorder(
                            borderRadius: new BorderRadius.circular(30.0),
                            borderSide: const BorderSide(
                                color: Colors.grey, width: 0.0),
                          ),
                          fillColor: Colors.white,
                          focusColor: Colors.white,
                        ),
                        obscureText: true,
                        validator: (value) {
                          if (value != _newPasswordController.text) {
                            return 'Parolele nu se potrivesc!';
                          }
                        },
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Container(
                        width: double.infinity,
                        child: RaisedButton(
                          onPressed: () {
                            _submit(_cureentUser);
                          },
                          color: Theme
                              .of(context)
                              .primaryColor,
                          textColor: Color(0xff075E54),
                          padding:
                          EdgeInsets.symmetric(vertical: 16, horizontal: 30),
                          child: Text(
                            'SCHIMBĂ PAROLA',
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
