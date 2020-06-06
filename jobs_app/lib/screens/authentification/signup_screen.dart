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
import './facebook_email_screen.dart';
import 'login_screen.dart';

class SignUpScreen extends StatefulWidget {
  static const routeName = '/signup';

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  int dropdownAgeValue;
  String dropdownGenderValue;
  var _isLoading = false;
  final _passwordController = TextEditingController();
  var _expanded = true;
  final facebookLogin = FacebookLogin();
  bool _isLoggedIn = false;
  Map userProfile = null;

  List<int> _years = [];
  List<String> _genders = [
    'Bărbat',
    'Femeie',
  ];

  Map<String, String> _authData = {
    'email': '',
    'firstName': '',
    'lastName': '',
    'birthYear': '',
    'gender': '',
    'password': '',
  };

  void _loginWithFB() async {


    final result = await facebookLogin
        .logInWithReadPermissions(['public_profile', 'email', 'user_gender', 'user_age_range', 'user_birthday']);
    switch (result.status) {
      case FacebookLoginStatus.loggedIn:
        final token = result.accessToken.token;
        final graphResponse = await http.get(
            'https://graph.facebook.com/v2.12/me?fields=birthday,email,first_name,last_name,picture.height(200),gender,age_range&access_token=${token}');
        final profile = JSON.jsonDecode(graphResponse.body);

        //bool find = await Provider.of<Auth>(context, listen: false).existsFacebookAccount(profile['id'],);

        Navigator.of(context).pushNamed(FacebookEmailScreen.routeName, arguments: graphResponse.body);
        break;

      case FacebookLoginStatus.cancelledByUser:
        break;
      case FacebookLoginStatus.error:
        break;
    }
  }

  void populateAges() {
    for (int i = 1900; i <= 2002; i++) {
      _years.add(i);
    }
  }

  @override
  void initState() {
    super.initState();
    populateAges();
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
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
      builder: (ctx) => AlertDialog(
        title: Text('Hurray! You now have an account!'),
        content: Text('Now you can start search for new jobs or offer '
            'some amazing oportunities to other candidates.'),
        actions: <Widget>[
          FlatButton(
            child: Text('Okay'),
            onPressed: () {
              Navigator.of(context)
                  .pushReplacementNamed(LoginScreen.routeName);
            },
          )
        ],
      ),
    );
    //print(returnVal);
    if (returnVal == null) {
      Navigator.of(context)
          .pushReplacementNamed(LoginScreen.routeName);
    }
  }

  void _logout(){
    print('sal');
    facebookLogin.logOut();
    setState(() {
      _isLoggedIn = false;
    });
  }

  Future<void> _submit() async {
    if (!_expanded) {
      setState(() {
        _expanded = !_expanded;
      });
    }
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
      await Provider.of<Auth>(context, listen: false).signup(
        _authData['email'],
        _authData['password'],
        _authData['firstName'],
        _authData['lastName'],
        _authData['birthYear'],
        _authData['gender'],
      );
    } on HttpException catch (error) {
      foundError = true;
      var errorMessage = 'Authentication failed';
      if (error.toString().contains('already exists')) {
        errorMessage = 'This email adress is already in use.';
      } else if (error.toString().contains('valid email')) {
        errorMessage = 'This is not a valid email adress.';
      } else if (error.toString().contains('other error')) {
        errorMessage = 'Could not authenticate you. Please try again later.';
      }
      _showErrorDialog(errorMessage);
    } catch (errorMessage) {
      foundError = true;
      print(errorMessage);
      var error = 'Could not authenticate you. Please try again later.';
      _showErrorDialog(error);
    }
//    await Provider.of<Users>(
//      context,
//      listen: false,
//    ).fetchAndSetUser();
//
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
    final deviceSize = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        height: deviceSize.height,
        color: Colors.white,
        child: ListView(
          children: <Widget>[
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
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      child: const Text(
                        'Hai să începem!',
                        style: TextStyle(
                          fontSize: 33,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(
                        top: 7,
                      ),
                      child: const Text(
                        'Creează-ți un cont pe platforma DtoD Jobs',
                        style: TextStyle(
                          fontSize: 15,
                          //fontWeight: FontWeight.bold,
                          color: Colors.black38,
                        ),
                      ),
                    ),
//                    Container(
//                      margin: EdgeInsets.only(
//                        top: 30,
//                      ),
//                      width: double.infinity,
//                      child: SignInButton(
//                        Buttons.Facebook,
//                        text: "CONTINUĂ CU FACEBOOK",
//                        shape: RoundedRectangleBorder(
//                          borderRadius: new BorderRadius.circular(30.0),
//                        ),
//                        padding: EdgeInsets.symmetric(
//                          vertical: 13,
//                          horizontal: 30,
//                        ),
//                        onPressed: () {
//                          //_loginWithFB();
//                        },
//                      ),
//                    ),
                    DividerWidget('înregistreaza-te', 1),
                    AnimatedContainer(
                      duration: Duration(milliseconds: 300),
                      height: !_expanded ? 0 : null,
                      child: Column(
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
                            height: 10,
                          ),
                          Container(
                            color: Colors.white,
                            child: TextFormField(
                              decoration: InputDecoration(
                                labelText: 'Prenumele',
                                prefixIcon: Icon(Icons.person_outline),
                                border: OutlineInputBorder(
                                  borderRadius: new BorderRadius.circular(30.0),
                                  borderSide: const BorderSide(
                                      color: Colors.grey, width: 0.0),
                                ),
                                fillColor: Colors.white,
                                focusColor: Colors.white,
                              ),
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Prenume invalid!';
                                }
                              },
                              onSaved: (value) {
                                _authData['firstName'] = value;
                              },
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            color: Colors.white,
                            child: TextFormField(
                              decoration: InputDecoration(
                                labelText: 'Numele',
                                prefixIcon: Icon(Icons.person),
                                border: OutlineInputBorder(
                                  borderRadius: new BorderRadius.circular(30.0),
                                  borderSide: const BorderSide(
                                      color: Colors.grey, width: 0.0),
                                ),
                                fillColor: Colors.white,
                                focusColor: Colors.white,
                              ),
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Nume invalid!';
                                }
                              },
                              onSaved: (value) {
                                _authData['lastName'] = value;
                              },
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.only(
                              left: 10,
                              right: 10,
                            ),
                            height: 56,
                            decoration: ShapeDecoration(
                              shape: RoundedRectangleBorder(
                                side: BorderSide(
                                    width: 1.0, color: Colors.black45),
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                            ),
                            child: DropdownButton<int>(
                              value: dropdownAgeValue,
                              icon: Icon(
                                Icons.arrow_drop_down,
                                color: Theme.of(context).primaryColor,
                              ),
                              iconSize: 24,
                              elevation: 16,
                              style: TextStyle(
                                color: Colors.black87,
                                fontSize: 20,
                              ),
                              isExpanded: true,
                              underline: Container(
                                height: 0,
                              ),
                              onChanged: (int newValue) {
                                setState(() {
                                  dropdownAgeValue = newValue;
                                  _authData['birthYear'] = newValue.toString();
                                });
                              },
                              hint: Row(
                                children: <Widget>[
                                  Icon(
                                    Icons.date_range,
                                    color: Colors.black45,
                                  ),
                                  SizedBox(width: 11),
                                  Text(
                                    "Anul nașterii",
                                    style: TextStyle(
                                      color: Colors.black54,
                                      fontSize: 17,
                                    ),
                                  )
                                ],
                              ),
                              items: _years.map<DropdownMenuItem<int>>(
                                  (int chosenValue) {
                                return DropdownMenuItem<int>(
                                  value: chosenValue,
                                  child: Row(
                                    children: <Widget>[
                                      if (dropdownAgeValue == chosenValue)
                                        Icon(
                                          Icons.date_range,
                                          color: Colors.black45,
                                        ),
                                      SizedBox(width: 10),
                                      Text(
                                        chosenValue.toString(),
                                        style: TextStyle(
                                          fontSize: 17,
                                        ),
                                      )
                                    ],
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.only(
                              left: 10,
                              right: 10,
                            ),
                            height: 56,
                            decoration: ShapeDecoration(
                              shape: RoundedRectangleBorder(
                                side: BorderSide(
                                    width: 1.0, color: Colors.black45),
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                            ),
                            child: DropdownButton<String>(
                              value: dropdownGenderValue,
                              icon: Icon(
                                Icons.arrow_drop_down,
                                color: Theme.of(context).primaryColor,
                              ),
                              iconSize: 24,
                              elevation: 16,
                              style: TextStyle(
                                color: Colors.black87,
                                fontSize: 20,
                              ),
                              isExpanded: true,
                              underline: Container(
                                height: 0,
                              ),
                              onChanged: (String newValue) {
                                setState(() {
                                  dropdownGenderValue = newValue;
                                  if (newValue == 'Bărbat') {
                                    _authData['gender'] = '0';
                                  }
                                  if (newValue == 'Femeie') {
                                    _authData['gender'] = '1';
                                  }
                                });
                              },
                              hint: Row(
                                children: <Widget>[
                                  Icon(
                                    Icons.person_pin,
                                    color: Colors.black45,
                                  ),
                                  SizedBox(width: 11),
                                  Text(
                                    "Sexul",
                                    style: TextStyle(
                                      color: Colors.black54,
                                      fontSize: 17,
                                    ),
                                  )
                                ],
                              ),
                              items: _genders.map<DropdownMenuItem<String>>(
                                  (String chosenValueGender) {
                                return DropdownMenuItem<String>(
                                  value: chosenValueGender,
                                  child: Row(
                                    children: <Widget>[
                                      if (dropdownGenderValue ==
                                          chosenValueGender)
                                        Icon(
                                          Icons.person_pin,
                                          color: Colors.black45,
                                        ),
                                      SizedBox(width: 10),
                                      Text(
                                        chosenValueGender,
                                        style: TextStyle(
                                          fontSize: 17,
                                        ),
                                      )
                                    ],
                                  ),
                                );
                              }).toList(),
                            ),
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
                            controller: _passwordController,
                            validator: (value) {
                              if (value.isEmpty || value.length < 8) {
                                return 'Password is too short!';
                              }
                            },
                            onSaved: (value) {
                              _authData['password'] = value;
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
                              if (value != _passwordController.text) {
                                return 'Passwords do not match!';
                              }
                            },
                          ),
                          SizedBox(
                            height: 30,
                          ),
                        ],
                      ),
                    ),
                    AuthButton(_submit, 'ÎNSCRIE-TE CU ADRESA DE E-MAIL'),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      child: FlatButton(
                        onPressed: () {
                          Navigator.of(context)
                              .pushReplacementNamed(LoginScreen.routeName);
                        },
                        child: Text(
                          'Ai deja cont? Contectează-te!',
                          style: TextStyle(
                            fontSize: 14,
                            //fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColor,
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
    );
  }
}
