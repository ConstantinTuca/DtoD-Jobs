import 'package:flutter/material.dart';

class Job {
  final String id;
  String userId;
  final String title;
  final String description;
  final int nrWorkers;
  final int genderWorkers;
  final String location;
  String detailsLocation;
  final int pricePerWorkerPerHour;
  final DateTime dateTimeStart;
  final DateTime dateTimeFinish;
  double duration;

  Job({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.nrWorkers,
    @required this.genderWorkers,
    @required this.location,
    @required this.pricePerWorkerPerHour,
    @required this.dateTimeStart,
    @required this.dateTimeFinish,
    this.userId,
    this.detailsLocation,
    this.duration,
  });
}
