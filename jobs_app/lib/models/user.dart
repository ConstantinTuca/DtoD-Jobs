import 'package:flutter/material.dart';

class User {

  final String id;
  final String token;
  final DateTime expiryDate;
  final String email;
  String password;
  final String firstName;
  final String lastName;
  final int birthYear;
  final int gender;
  int phone;
  String description;

  User ({
    @required this.id,
    @required this.token,
    @required this.expiryDate,
    @required this.email,
    this.password,
    @required this.firstName,
    @required this.lastName,
    @required this.birthYear,
    @required this.gender,
    this.phone,
    this.description
  });
}