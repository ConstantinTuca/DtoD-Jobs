import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';

import '../models/job.dart';
import '../models/user.dart';
import '../helpers/db_helper.dart';
import '../providers/users.dart';
import '../exceptions/http_exception.dart';
import 'package:http/http.dart' as http;

class Jobs with ChangeNotifier {
  var time = DateTime.now();
  String userId;
  final String userToken;
  bool _userHasJob = false;
  bool _userHasJobAsCandidate = false;

  List<Job> _items = [];
  List<Job> _userJobs = [];
  List<dynamic> _jobsAsCandidate = [];

  //Map<String, > _userJobs = [];

  List<Job> get userJobs {
    return [..._userJobs];
  }

  List<dynamic> get jobsAsCandidate {
    return [..._jobsAsCandidate];
  }

  List<Job> get items {
    return [..._items];
  }

  bool get userHasJob {
    return _userHasJob;
  }

  bool get userHasJobAsCandidate {
    return _userHasJobAsCandidate;
  }

  Jobs(this.userToken, this._items);

  Future<void> addJob(
      String title,
      String description,
      int nrWorkers,
      int genderWorkers,
      String location,
      double locationLatitude,
      double locationLongitude,
      String detailsLocation,
      int pricePerWorkerPerHour,
      DateTime dateTimeStart,
      DateTime dateTimeFinish) async {
    final url = 'https://constantintuca.com/api/jobs/';
    try {
      final response = await http.post(
        url,
        body: json.encode(
          {
            'title': title,
            'descriptions': description,
            'gender_workers': genderWorkers,
            'nr_workers': nrWorkers,
            'location': location,
            'locationLatitude': locationLatitude,
            'locationLongitude': locationLongitude,
            'price_per_worker': pricePerWorkerPerHour,
            'start_date': dateTimeStart.toString(),
            'finish_date': dateTimeFinish.toString()
          },
        ),
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
          "Authorization": "Token " + userToken,
        },
      );

      final responseData = json.decode(response.body);
      print("Raspunsul este:               ");
      print(responseData);
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> addJobCandidate(String jobId) async {
    int id = int.tryParse(jobId);
    final url = 'https://constantintuca.com/api/jobs/candidates/';
    try {
      final response = await http.post(
        url,
        body: json.encode(
          {'job_id': id},
        ),
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
          "Authorization": "Token " + userToken,
        },
      );
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> addFeedback(
      String provideTo, int feedbackStars, String feedback) async {
    int id = int.tryParse(provideTo);
    final url = 'https://constantintuca.com/api/jobs/feedback/';
    try {
      final response = await http.post(
        url,
        body: json.encode(
          {'provide_to': id, 'text': feedback, 'stars': feedbackStars},
        ),
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
          "Authorization": "Token " + userToken,
        },
      );
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> fetchAndSetPlaces(String locationName, double locationLatitude, double locationLongitude, DateTime chosenDate, DateTime chosenStartHour, DateTime chosenFinishHour) async {
    var _dateTimeStart = chosenStartHour;
    var _dateTimeFinish = chosenFinishHour;

    final url =
        'https://constantintuca.com/api/jobs/?location=$locationName&locationLatitude=$locationLatitude&locationLongitude=$locationLongitude&start_date=$_dateTimeStart&finish_date=$_dateTimeFinish';
    try {
      print(url);
      final response = await http.get(
        url,
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Token ' + userToken,
        },
      );
      try {
        var dataList = json.decode(response.body);
        _items.clear();
        _items = dataList
            .map<Job>(
              (item) => Job(
                id: item['id'].toString(),
                title: item['title'],
                description: item['descriptions'],
                nrWorkers: item['nr_workers'],
                genderWorkers: item['gender_workers'],
                location: item['location'],
                locationLatitude: item['locationLatitude'],
                locationLongitude: item['locationLongitude'],
                pricePerWorkerPerHour: item['price_per_worker'],
                dateTimeStart: DateTime.tryParse(item['start_date']),
                dateTimeFinish: DateTime.tryParse(item['finish_date']),
                userId: item['user_id'].toString(),
              ),
            )
            .toList();
        notifyListeners();
      } catch (er) {
        print('erroarea este:');
        print(er);
      }
      //notifyListeners();
    } catch (error) {
      print("erroarea este " + error.toString());
    }
  }

  Future<void> fetchAndSetJobsByUserId([bool history]) async {
    history ??= false;
    String now = DateTime.now().toIso8601String();
    String url;

    if (history == false) {
      url = 'https://constantintuca.com/api/jobs/?start_date=$now';
    } else {
      url = 'https://constantintuca.com/api/jobs/?finish_date=$now';
    }
    try {
      final response = await http.get(
        url,
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Token ' + userToken,
        },
      );
      var dataList = json.decode(response.body);

      _userJobs.clear();
      if (dataList.length != 0) {
        _userJobs = dataList
            .map<Job>(
              (item) => Job(
                id: item['id'].toString(),
                title: item['title'],
                description: item['descriptions'],
                nrWorkers: item['nr_workers'],
                genderWorkers: item['gender_workers'],
                location: item['location'],
                locationLatitude: item['locationLatitude'],
                locationLongitude: item['locationLongitude'],
                pricePerWorkerPerHour: item['price_per_worker'],
                dateTimeStart: DateTime.parse(item['start_date']),
                dateTimeFinish: DateTime.parse(item['finish_date']),
                userId: item['user_id'].toString(),
              ),
            )
            .toList();
      }
    } catch (e) {}
    notifyListeners();
  }

  Future<void> hasJobs() async {
    final url = 'https://constantintuca.com/api/jobs/has-jobs/';
    try {
      final response = await http.get(
        url,
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Token ' + userToken,
        },
      );
      if (response.statusCode != 204) {
        var responseData = json.decode(response.body);
        _userHasJob = responseData['owner'];
        _userHasJobAsCandidate = responseData['candidate'];
      } else {
        _userHasJob = false;
        _userHasJobAsCandidate = false;
      }
    } catch (error) {
      print('---------------');
      //print(error);
      throw error;
    }
  }

  Future<void> updateJob(String jobId, Job newJob) async {
    final jobIndex = _userJobs.indexWhere((job) => job.id == jobId);
    DateTime _dateTimeStart = _userJobs[jobIndex].dateTimeStart;
    DateTime _dateTimeFinish = _userJobs[jobIndex].dateTimeFinish;

    var tempJob = {
      'id': _userJobs[jobIndex].id,
      'title': _userJobs[jobIndex].title,
      'description': _userJobs[jobIndex].description,
      'nrWorkers': _userJobs[jobIndex].nrWorkers,
      'genderWorkers': _userJobs[jobIndex].genderWorkers,
      'location': _userJobs[jobIndex].location,
      'locationLatitude': _userJobs[jobIndex].locationLatitude,
      'locationLongitude': _userJobs[jobIndex].locationLongitude,
      'pricePerWorkerPerHour': _userJobs[jobIndex].pricePerWorkerPerHour,
      'dateTimeStart': _userJobs[jobIndex].dateTimeStart,
      'dateTimeFinish': _userJobs[jobIndex].dateTimeFinish
    };
    print(tempJob);

    if (newJob.title != '') {
      tempJob['title'] = newJob.title;
    }

    if (newJob.description != '') {
      tempJob['description'] = newJob.description;
    }

    if (newJob.nrWorkers != 0) {
      tempJob['nrWorkers'] = newJob.nrWorkers;
    }

    tempJob['genderWorkers'] = newJob.genderWorkers;

    if (newJob.pricePerWorkerPerHour != 0) {
      tempJob['pricePerWorkerPerHour'] = newJob.pricePerWorkerPerHour;
    }

    if (newJob.location != '') {
      tempJob['location'] = newJob.location;
    }

    if (newJob.locationLatitude != 0) {
      tempJob['locationLatitude'] = newJob.locationLatitude;
    }

    if (newJob.locationLongitude != 0) {
      tempJob['locationLongitude'] = newJob.locationLongitude;
    }

    if (newJob.dateTimeStart != null) {
      tempJob['dateTimeStart'] = newJob.dateTimeStart;
    }

    if (newJob.dateTimeFinish != null) {
      tempJob['dateTimeFinish'] = newJob.dateTimeFinish;
    }
    final myJob = Job(
        id: tempJob['id'],
        title: tempJob['title'],
        description: tempJob['description'],
        nrWorkers: tempJob['nrWorkers'],
        genderWorkers: tempJob['genderWorkers'],
        location: tempJob['location'],
        locationLatitude: tempJob['locationLatitude'],
        locationLongitude: tempJob['locationLongitude'],
        detailsLocation: tempJob['detailsLocation'],
        pricePerWorkerPerHour: tempJob['pricePerWorkerPerHour'],
        dateTimeStart: tempJob['dateTimeStart'],
        dateTimeFinish: tempJob['dateTimeFinish']);

    int id = int.tryParse(myJob.id);

    try {
      final url = 'https://constantintuca.com/api/jobs/?id=$id';
      final response = await http.put(
        url,
        body: json.encode(
          {
            'id': tempJob['id'],
            'title': tempJob['title'],
            'descriptions': tempJob['description'],
            'nr_workers': tempJob['nrWorkers'],
            'gender_workers': tempJob['genderWorkers'],
            'location': tempJob['location'],
            'locationLatitude': tempJob['locationLatitude'],
            'locationLongitude': tempJob['locationLongitude'],
            'price_per_worker': tempJob['pricePerWorkerPerHour'],
            'start_date': tempJob['dateTimeStart'].toString(),
            'finish_date': tempJob['dateTimeFinish'].toString(),
          },
        ),
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Token ' + userToken,
        },
      );
    } catch (error) {
      print(error);
      throw error;
    }

    _userJobs[jobIndex] = myJob;
    notifyListeners();
  }

  Future<Job> getJobByJobId(String jobId) async {
    int id = int.parse(jobId);
    var url = 'https://constantintuca.com/api/jobs/?id=$id';

    final response = await http.get(
      url,
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        "Authorization": "Token " + userToken,
      },
    );

    final responseData = json.decode(response.body);
    if (responseData.length != 0) {
      final responseJob = Job(
        id: responseData[0]['id'].toString(),
        title: responseData[0]['title'],
        description: responseData[0]['descriptions'],
        nrWorkers: responseData[0]['nr_workers'],
        genderWorkers: responseData[0]['gender_workers'],
        location: responseData[0]['location'],
        locationLatitude: responseData[0]['locationLatitude'],
        locationLongitude: responseData[0]['locationLongitude'],
        pricePerWorkerPerHour: responseData[0]['price_per_worker'],
        dateTimeStart: DateTime.parse(responseData[0]['start_date']),
        dateTimeFinish: DateTime.parse(responseData[0]['finish_date']),
        userId: responseData[0]['user_id'].toString(),
      );
      notifyListeners();
      return responseJob;
    } else {
      return null;
    }
  }

  Future deleteJob(String jobId) async {
    final existingJobIndex = _userJobs.indexWhere((prod) => prod.id == jobId);

    int id = int.parse(jobId);
    var url = 'https://constantintuca.com/api/jobs/?id=$id';

    final response = await http.delete(
      url,
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        "Authorization": "Token " + userToken,
      },
    );

    final responseData = json.decode(response.body);

    print(responseData);
    _userJobs.removeAt(existingJobIndex);
    notifyListeners();
  }

  Future<User> getUserByUserId(String userId) async {
    int id = int.tryParse(userId);

    final url = 'https://constantintuca.com/api/user/profile/?id=$id';
    final response = await http.get(
      url,
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        "Authorization": "Token " + userToken,
      },
    );
    if (response.statusCode != 204) {
      final responseData = json.decode(response.body);

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
  }

  Future<List<Map<String, dynamic>>> getJobCandidates() async {
    List<Map<String, dynamic>> jobCandidates = [];

    final jobs = _userJobs;
    for (var currentJob in jobs) {
      int id = int.parse(currentJob.id);
      var url = 'https://constantintuca.com/api/jobs/candidates/?job_id=$id';

      final response = await http.get(
        url,
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
          "Authorization": "Token " + userToken,
        },
      );

      var responseData = [];
      try {
        responseData = json.decode(response.body);
      } catch (e) {}
      for (int j = 0; j < responseData.length; j++) {
        jobCandidates.add(responseData[j]);
      }
    }
    return jobCandidates;
  }

  Future<Map<String, dynamic>> getJobUsers(String jobId,
      [bool feedback]) async {
    feedback ??= false;
    Map<String, dynamic> jobCandidates = {};
    final jobs = _userJobs;

    int id = int.tryParse(jobId);
    var url = 'https://constantintuca.com/api/jobs/candidates/?job_id=$id';

    final response = await http.get(
      url,
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        "Authorization": "Token " + userToken,
      },
    );

    var responseData = [];
    try {
      responseData = json.decode(response.body);
    } catch (e) {}

    if (feedback == false) {
      for (int j = 0; j < responseData.length; j++) {
        int k =0;
        Map<String, dynamic> currentItem = {};
        currentItem.putIfAbsent('accepted', () => responseData[j]['accepted']);
        currentItem.putIfAbsent('idRow', () => responseData[j]['id']);
        await getFeedbackStars(responseData[j]['user_id']).then((value) {
          currentItem.putIfAbsent('starlete', () => value);
          k++;
        });
        if(k==1) {
          await getUserByUserId(responseData[j]['user_id'].toString())
              .then((value) {
            currentItem.putIfAbsent('user', () => value);
            jobCandidates.putIfAbsent(value.id, () => currentItem);
          });
        }
      }
    } else {
      for (int j = 0; j < responseData.length; j++) {
        int k =0;
        Map<String, dynamic> currentItem = {};
        currentItem.putIfAbsent('accepted', () => responseData[j]['accepted']);
        currentItem.putIfAbsent('idRow', () => responseData[j]['id']);
        await getFeedbackStars(responseData[j]['user_id']).then((value) {
          currentItem.putIfAbsent('starlete', () => value);
          k++;
        });

        await hasFeedback(responseData[j]['user_id']).then((value) {
          currentItem.putIfAbsent('hasFeedback', () => value);
          k++;
        });

        if(k == 2) {
          await getUserByUserId(responseData[j]['user_id'].toString())
              .then((value) {
            currentItem.putIfAbsent('user', () => value);
            jobCandidates.putIfAbsent(value.id, () => currentItem);
          });
        }
      }
    }

    return jobCandidates;
  }

  Future<void> acceptCandidature(String idJob, String idUser, int idRow) async {
    int id = idRow;
    final url = 'https://constantintuca.com/api/jobs/candidates/?id=$id';

    final response = await http.put(
      url,
      body: json.encode(
        {
          'job_id': int.tryParse(idJob),
          'accepted': 'true',
        },
      ),
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Token ' + userToken,
      },
    );

    notifyListeners();
  }

  Future<void> rejectCandidature(int idRow) async {
    int id = idRow;
    var url = 'https://constantintuca.com/api/jobs/candidates/?id=$id';

    final response = await http.delete(
      url,
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        "Authorization": "Token " + userToken,
      },
    );

    final responseData = json.decode(response.body);

    notifyListeners();
  }

  Future<void> getJobsAsCandidate([bool history]) async {
    history ??= false;
    String now = DateTime.now().toIso8601String();
    var url;

    if (history == false) {
      url = 'https://constantintuca.com/api/jobs/candidates-jobs/?start_date=$now';
    } else {
      url = 'https://constantintuca.com/api/jobs/candidates-jobs/?finish_date=$now';
    }

    final response = await http.get(
      url,
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        "Authorization": "Token " + userToken,
      },
    );
    _jobsAsCandidate = [];
    try {
      _jobsAsCandidate = json.decode(response.body);
    } catch (e) {}

    notifyListeners();
  }

  Future<bool> hasFeedback(int provide_to_id) async {
    int id = -1;
    final url =
        'https://constantintuca.com/api/jobs/feedback/?provide_to=$provide_to_id&provide_by=$id';

    final response = await http.get(
      url,
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        "Authorization": "Token " + userToken,
      },
    );

    if (response.statusCode == 204) {
      return false;
    } else if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<List<Map<String, dynamic>>> getFeedbacks([int provide_to_id]) async {
    provide_to_id ??= -1;
    List<Map<String, dynamic>> userFeedbacks = [];
    String url;

    if (provide_to_id == -1) {
      url = 'https://constantintuca.com/api/jobs/feedback/';
    } else {
      url = 'https://constantintuca.com/api/jobs/feedback/?provide_to=$provide_to_id';
    }

    final response = await http.get(
      url,
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        "Authorization": "Token " + userToken,
      },
    );

    var responseData = [];
    if (response.statusCode == 200) {
      responseData = json.decode(response.body);
    }

    for (int j = 0; j < responseData.length; j++) {
      Map<String, dynamic> currentItem = {};
      currentItem.putIfAbsent('stars', () => responseData[j]['stars']);
      currentItem.putIfAbsent('text', () => responseData[j]['text']);
      await getUserByUserId(responseData[j]['provide_by'].toString())
          .then((value) {
        currentItem.putIfAbsent('user', () => value);
        userFeedbacks.add(currentItem);
      });
    }

    return userFeedbacks;
  }

  Future<Map<String, dynamic>> getFeedbackStars([int id]) async {
    id ??= -1;
    Map<String, dynamic> feedbackStars = {};
    var responseData = [];
    var url;

    if(id != -1) {
      url = 'https://constantintuca.com/api/jobs/feedback/?provide_to=$id';
    } else {
      url = 'https://constantintuca.com/api/jobs/feedback/';
    }

    final response = await http.get(
      url,
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        "Authorization": "Token " + userToken,
      },
    );

    if (response.statusCode == 200) {
      responseData = json.decode(response.body);
    }
    feedbackStars = calculateFeedback(responseData);

    return feedbackStars;
  }

  Map<String, dynamic> calculateFeedback(List feedbacks) {
    Map<String, dynamic> feedbackStars = {};
    double media = 0;
    int dezamagitoare = 0;
    int slaba = 0;
    int buna = 0;
    int foarte_buna = 0;
    int excelenta = 0;
    int length = feedbacks.length;
    for (int j = 0; j < length; j++) {
      media += feedbacks[j]['stars'];
      if (feedbacks[j]['stars'] == 1) {
        dezamagitoare += 1;
      } else if (feedbacks[j]['stars'] == 2) {
        slaba += 1;
      } else if (feedbacks[j]['stars'] == 3) {
        buna += 1;
      } else if (feedbacks[j]['stars'] == 4) {
        foarte_buna += 1;
      } else if (feedbacks[j]['stars'] == 5) {
        excelenta += 1;
      }
    }
    if(media != 0) {
      media /= length;
    } else {
      media = 5;
    }
    feedbackStars.putIfAbsent('media', () => media);
    feedbackStars.putIfAbsent('length', () => length);
    feedbackStars.putIfAbsent('dezamagitoare', () => dezamagitoare);
    feedbackStars.putIfAbsent('slaba', () => slaba);
    feedbackStars.putIfAbsent('buna', () => buna);
    feedbackStars.putIfAbsent('foarte_buna', () => foarte_buna);
    feedbackStars.putIfAbsent('excelenta', () => excelenta);

    return feedbackStars;
  }
}
