import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:jobs_app/providers/users.dart';
import 'package:provider/provider.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as JSON;

import '../../widgets/auth_button.dart';
import '../../widgets/divider.dart';
import '../../exceptions/http_exception.dart';
import '../../providers/auth.dart';
import './signup_screen.dart';

class LoginScreen extends StatelessWidget {
  static const routeName = '/login';

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          height: deviceSize.height,
          width: deviceSize.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
//                width: deviceSize.width * 0.55,
//                height: deviceSize.width * 0.50,
                width: deviceSize.width * 0.75,
                height: deviceSize.width * 0.70,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/login_image.png'),
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(
                  left: 25,
                  right: 25,
                ),
                child: Text(
                  'Bine ai revenit!',
                  style: TextStyle(
                    fontSize: 33,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(
                  top: 7,
                  left: 25,
                  right: 25,
                ),
                child: Text(
                  'Conectează-te în contul tău existent de DtoD Jobs',
                  style: TextStyle(
                    fontSize: 15,
                    //fontWeight: FontWeight.bold,
                    color: Colors.black38,
                  ),
                ),
              ),
              Container(
                child: LoginFields(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class LoginFields extends StatefulWidget {
  @override
  _LoginFieldsState createState() => _LoginFieldsState();
}

class _LoginFieldsState extends State<LoginFields> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  Map<String, String> _authData = {
    'email': '',
    'password': '',
    'facebook_id': '',
  };
  var _isLoading = false;
  final _passwordController = TextEditingController();
  final facebookLogin = FacebookLogin();
  bool _isLoggedIn = false;
  Map userProfile = null;

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
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
        title: Text('Bine ai revenit user!'),
        content: Text('Ți-am simțit lipsa cât timp ai fost plecat! '),
      ),
    );
  }

  void _loginWithFB() async {
    final result = await facebookLogin.logInWithReadPermissions([
      'public_profile',
      'email',
      'user_gender',
      'user_age_range',
      'user_birthday'
    ]);
    switch (result.status) {
      case FacebookLoginStatus.loggedIn:
        final token = result.accessToken.token;
        final graphResponse = await http.get(
            'https://graph.facebook.com/v2.12/me?fields=birthday,email,first_name,last_name,picture.height(200),gender,age_range&access_token=${token}');
        final profile = JSON.jsonDecode(graphResponse.body);
        _authData['facebook_id'] = profile['id'];
        _submit();
        break;

      case FacebookLoginStatus.cancelledByUser:
        break;
      case FacebookLoginStatus.error:
        break;
    }
  }

  Future<void> _submit() async {
    if(_authData['facebook_id'] == '') {
      if (!_formKey.currentState.validate()) {
        // Invalid!
        return;
      }
      _formKey.currentState.save();
    }
    if (mounted) {
      setState(() {
        _isLoading = true;
      });
    }

    var foundError = false;
    try {
      await Provider.of<Auth>(context, listen: false).login(
        _authData['email'],
        _authData['password'],
        _authData['facebook_id'],
      );
    } on HttpException catch (error) {
      foundError = true;
      var errorMessage = 'Authentication failed';
      if (error.toString().contains('wrong_credentials')) {
        errorMessage = 'The email or password is not corect.';
      }
      _showErrorDialog(errorMessage);
    } catch (error) {
      foundError = true;
      var errorMessage = 'Could not authenticate you. Please try again later.';
      _showErrorDialog(errorMessage);
    }
    await Provider.of<Users>(
      context,
      listen: false,
    ).fetchAndSetUser();

    if (foundError == false) {
      Navigator.of(context).pushReplacementNamed('/');
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

    return Container(
      margin: EdgeInsets.only(
        top: 25,
        left: 25,
        right: 25,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
//            Container(
//              width: double.infinity,
//              child: SignInButton(
//                Buttons.Facebook,
//                text: "CONTINUĂ CU FACEBOOK",
//                shape: RoundedRectangleBorder(
//                  borderRadius: new BorderRadius.circular(30.0),
//                ),
//                padding: EdgeInsets.symmetric(
//                  vertical: 13,
//                  horizontal: 30,
//                ),
//                onPressed: () {
//                  //_loginWithFB();
//                },
//              ),
//            ),
//            DividerWidget('sau', 1),
            SizedBox(
              height: 5,
            ),
            Container(
              color: Colors.white,
              child: TextFormField(
                decoration: InputDecoration(
                  labelText: 'E-Mail',
                  prefixIcon: Icon(Icons.person_outline),
                  border: OutlineInputBorder(
                    borderRadius: new BorderRadius.circular(30.0),
                    borderSide:
                        const BorderSide(color: Colors.grey, width: 0.0),
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
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Parolă',
                prefixIcon: Icon(Icons.lock_open),
                border: OutlineInputBorder(
                  borderRadius: new BorderRadius.circular(30.0),
                  borderSide: const BorderSide(color: Colors.grey, width: 0.0),
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
            Row(
              //mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Container(
                  child: FlatButton(
                    onPressed: () {
                      Navigator.of(context)
                          .pushReplacementNamed(SignUpScreen.routeName);
                    },
                    child: Text(
                      'Nu ai cont? Înscrie-te!',
                      style: TextStyle(
                        fontSize: 14,
                        //fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                ),
//                Container(
//                  child: FlatButton(
//                    child: Text(
//                      'Ai uitat parola?',
//                      style: TextStyle(
//                        fontSize: 14,
//                        //fontWeight: FontWeight.bold,
//                        color: Colors.black54,
//                      ),
//                    ),
//                  ),
//                ),
              ],
            ),
            if (_isLoading)
              CircularProgressIndicator()
            else
              AuthButton(_submit, 'CONECTEAZĂ-TE'),
            SizedBox(
                //height: 100,
                ),
          ],
        ),
      ),
    );
  }
}
