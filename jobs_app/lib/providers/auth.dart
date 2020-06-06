import 'dart:async';
import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../exceptions/http_exception.dart';
import '../helpers/db_helper.dart';
import '../models/user.dart';

class Auth with ChangeNotifier {
  String _token;
  DateTime _expiryDate;
  String _userId;
  Timer _authTimer;

  bool get isAuth {
    return token != null;
  }

  String get token {
    if (_expiryDate != null &&
        _expiryDate.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }
    return null;
  }

  String get userId {
    return _userId;
  }

  Future<void> login(String email, String password,
      [String facebookId = '']) async {

    final url = 'https://tucanu.com/api/user/login/';
    try {
      final response = await http.post(
        url,
        body: json.encode(
          {
            'username': email,
            'password': password,
          },
        ),
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
        },
      );

      final responseData = json.decode(response.body);
      //print(responseData);
      if (responseData.containsKey('token') == false) {
        throw HttpException('wrong_credentials');
      }
      _token = responseData['token'];
      _expiryDate = DateTime.now().add(
        Duration(
          seconds: int.tryParse(
            '1800',
          ),
        ),
      );
      // _autoLogout();
      notifyListeners();
      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode({
        'token': _token,
        'expiryDate': _expiryDate.toIso8601String(),
      });
      prefs.setString('userData', userData);
    } catch (error) {
      //print(error);
      throw error;
    }
  }

  Future<void> signup(String email, String password, String firstName,
      String lastName, String birthYear, String gender,
      [String facebookId = '']) async {
    final url = 'https://tucanu.com/api/user/register/';
    try {
      final response = await http.post(
        url,
        body: json.encode(
          {
            'email': email,
            'password': password,
            'first_name': firstName,
            'last_name': lastName,
            'birth_year': int.tryParse(birthYear),
            'gender': int.tryParse(gender),
            'facebook_id': facebookId,
          },
        ),
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
        },
      );

      final responseData = json.decode(response.body);
       //print(responseData);
       var errorMessage = '';
      if(responseData != 201) {
        if(responseData.containsKey('email')) {
          for(int i=0; i<responseData['email'].length; i++) {
            errorMessage += responseData['email'][i].toString();
          }
        }
        if(responseData.containsKey('password')) {
          for(int i=0; i<responseData['password'].length; i++) {
            errorMessage += responseData['password'][i].toString();
          }
        }
        print(errorMessage);
        if(errorMessage == '') {
          throw HttpException('other error');
        } else {
          throw HttpException(errorMessage);
        }
      }
    } catch (error) {
      //print(error);
      throw error;
    }
  }

//  Future<bool> existsFacebookAccount([String facebookId = '']) async {
//    try {
//      final response = await DBHelper.existsFacebookId('users', {
//        'facebookId': facebookId,
//      });
//
//      final responseData = json.decode(response);
//      return responseData['exists'];
//    } catch (error) {
//      print(error);
//      throw error;
//    }
//  }
//
//  Future<void> loginWithFacebook(String email, String password,
//      String firstName, String lastName, String birthYear, String gender,
//      [String facebookId = '']) async {
//    try {
//      final response = await DBHelper.loginFacebook('users', {
//        'id': DateTime.now().toString(),
//        'email': email,
//        'password': password,
//        'firstName': firstName,
//        'lastName': lastName,
//        'birthYear': int.tryParse(birthYear),
//        'gender': int.tryParse(gender),
//        'facebookId': facebookId,
//      });
//
//      final responseData = json.decode(response);
//      // print(responseData);
//      if (responseData['error']['message'] != '') {
//        throw HttpException(responseData['error']['message']);
//      }
//      _token = responseData['idToken'];
//      _userId = responseData['localId'];
//      _expiryDate = DateTime.now().add(
//        Duration(
//          seconds: int.tryParse(
//            responseData['expiresIn'],
//          ),
//        ),
//      );
//      _autoLogout();
//      notifyListeners();
//      final prefs = await SharedPreferences.getInstance();
//      final userData = json.encode({
//        'token': _token,
//        'userId': _userId,
//        'expiryDate': _expiryDate.toIso8601String(),
//      });
//      prefs.setString('userData', userData);
//    } catch (error) {
//      print(error);
//      throw error;
//    }
//  }

  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')) {
      return false;
    }
    final extractedUserData =
        json.decode(prefs.getString('userData')) as Map<String, Object>;
    final expiryDate = DateTime.parse(extractedUserData['expiryDate']);
    if (expiryDate.isBefore(DateTime.now())) {
      return false;
    }
    _token = extractedUserData['token'];
    _userId = extractedUserData['userId'];
    _expiryDate = expiryDate;
    notifyListeners();
    _autoLogout();

    return true;
  }

  Future logout() async {
    _token = null;
    _userId = null;
    _expiryDate = null;
    if (_authTimer != null) {
      _authTimer.cancel();
      _authTimer = null;
    }
    notifyListeners();
    //facebookLogin.logOut();
    final prefs = await SharedPreferences.getInstance();
    // prefs.remove('userData');
    prefs.clear();
  }

  void _autoLogout() {
    if (_authTimer != null) {
      _authTimer.cancel();
    }
    final timeToExpiry = _expiryDate.difference(DateTime.now()).inSeconds;

    _authTimer = Timer(Duration(seconds: timeToExpiry), logout);
  }
}
