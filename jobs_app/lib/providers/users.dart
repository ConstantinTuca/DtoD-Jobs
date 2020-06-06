import 'dart:io';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/user.dart';
import '../models/job.dart';
import '../helpers/db_helper.dart';
import 'package:http/http.dart' as http;

class Users with ChangeNotifier {
  var time = DateTime.now();
  User _currentUser;
  String _userId;
  String _token;
  DateTime _expiryDate;

  User getCurrentUser() {
    return _currentUser;
  }

  Future<void> fetchAndSetUser() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')) {
      return;
    }
    final extractedUserData =
        json.decode(prefs.getString('userData')) as Map<String, Object>;
    final expiryDate = DateTime.parse(extractedUserData['expiryDate']);
    if (expiryDate.isBefore(DateTime.now())) {
      return;
    }
    _token = extractedUserData['token'];
    _expiryDate = expiryDate;

    final url = 'https://tucanu.com/api/user/profile/';
    final response = await http.get(
      url,
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        "Authorization": "Token " + _token,
      },
    );

    final responseData = json.decode(response.body);
    print('Userul este: ');
    print(responseData);

    if (responseData.length != 0 && responseData.containsKey('email')) {
      _currentUser = User(
        //id: responseData[0]['id'],
        token: _token,
        expiryDate: _expiryDate,
        email: responseData['email'],
        firstName: responseData['first_name'],
        lastName: responseData['last_name'],
        birthYear: responseData['birth_year'],
        gender: responseData['gender'],
        phone: responseData['phone'],
        description: responseData['descriptions'],
      );
      notifyListeners();
      return;
    } else {
      return;
    }
  }

  Future<void> updateUser(String id, User newUser) async {
    final url = 'https://tucanu.com/api/user/profile/';

    final response = await http.put(
      url,
      body: newUser.description != ''
          ? json.encode(
              {
                'first_name': newUser.firstName,
                'last_name': newUser.lastName,
                'birth_year': newUser.birthYear,
                'phone': newUser.phone,
                'descriptions': newUser.description,
              },
            )
          : json.encode(
              {
                'first_name': newUser.firstName,
                'last_name': newUser.lastName,
                'birth_year': newUser.birthYear,
                'phone': newUser.phone,
              },
            ),
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        "Authorization": "Token " + _token,
      },
    );
    print(response.body);
//    _currentUser = newUser;
//    notifyListeners();
  }

  Future<void> changePassword(
      String currentPassword, String newPassword) async {
    try {
      final url = 'https://tucanu.com/api/user/reset-password/';

      final response = await http.put(
        url,
        body: json.encode(
          {
            'current_password': currentPassword,
            'new_password': newPassword,
          },
        ),
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
          "Authorization": "Token " + _token,
        },
      );
      var res = json.decode(response.body);

      if (res != 202) {
        if (res.containsKey('errors')) {
          if (res['errors'] != '') {
            throw HttpException(res['errors']);
          }
        }
      }

      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<User> getUserByUserId(String userId) async {
    int id = int.tryParse(userId);

    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')) {
      return null;
    }
    final extractedUserData =
    json.decode(prefs.getString('userData')) as Map<String, Object>;
    final expiryDate = DateTime.parse(extractedUserData['expiryDate']);
    if (expiryDate.isBefore(DateTime.now())) {
      return null;
    }
    _token = extractedUserData['token'];

    final url = 'https://tucanu.com/api/user/profile/?id=$id';
    try {
      final response = await http.get(
        url,
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
          "Authorization": "Token " + _token,
        },
      );

      final responseData = json.decode(response.body);
//      print('Userul este: ');
//      print(responseData);

      if (responseData != null) {
        final user = User(
          id: userId,
          email: responseData['email'],
          firstName: responseData['first_name'],
          lastName: responseData['last_name'],
          birthYear: responseData['birth_year'],
          gender: responseData['gender'],
          phone: responseData['phone'],
          description: responseData['descriptions'],
        );
        return user;
      } else {
        return null;
      }
    } catch (e) {
      print(e);
    }
  }

  Future<Map<String, User>> getJobUsers(List<Job> items) async {
    Map<String, User> jobUsers = {};
    final jobs = items;
    Job currentJob;
    for (currentJob in jobs) {
      await getUserByUserId(currentJob.userId).then((value) {
        jobUsers.putIfAbsent(currentJob.userId, () => value);
      });
    }
    return jobUsers;
  }
}
