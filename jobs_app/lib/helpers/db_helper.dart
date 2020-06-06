import 'dart:convert';
import 'dart:io';

import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;
import 'package:random_string/random_string.dart';
import '../models/user.dart';

class DBHelper {
  static Future<sql.Database> database() async {
    final dbPath = await sql.getDatabasesPath();
    return sql.openDatabase(
      path.join(dbPath, 'job8.db'),
      onCreate: (db, version) {
        db.execute(
            'CREATE TABLE users(id TEXT PRIMARY KEY, idToken TEXT, expiryDate TEXT, '
                'email TEXT, password TEXT, firstName TEXT, '
                'lastName TEXT, birthYear INTEGER, gender INTEGER, facebookId TEXT, phone INTEGER, description TEXT);');

        db.execute(
            'CREATE TABLE job_candidates(id TEXT PRIMARY KEY, idJob TEXT, idUser TEXT, accepted INTEGER, finished INTEGER, reviewCandidate TEXT, '
                'reviewEmployer TEXT);');

        return db.execute(
            'CREATE TABLE jobs(id TEXT PRIMARY KEY, userId TEXT, title TEXT, description TEXT, '
            'nrWorkers INTEGER, genderWorkers INTEGER, '
            'location TEXT, detailsLocation TEXT, pricePerWorkerPerHour INTEGER, '
            'dateTimeYear INTEGER, dateTimeMonth INTEGER, '
            'dateTimeDay INTEGER, startHour INTEGER, '
            'startMinutes INTEGER, finishHour INTEGER, '
            'finishMinutes INTEGER, duration DOUBLE); ');
      },
      version: 1,
    );
  }

  static Future<void> insert(String table, Map<String, Object> data) async {
    final db = await DBHelper.database();
    db.insert(
      table,
      data,
      conflictAlgorithm: sql.ConflictAlgorithm.replace,
    );
  }

  static Future<List<Map<String, dynamic>>> getData(
    String table,
    String locationName,
    int chosenDateYear,
    int chosenDateMonth,
    int chosenDateDay,
    int startHour,
    int finishHour,
  ) async {
    final db = await DBHelper.database();
    var result = await db.rawQuery(
        'SELECT * FROM $table WHERE location=? AND dateTimeYear=? AND dateTimeMonth=? '
        'AND dateTimeDay=? AND startHour>=? AND finishHour<=?',
        [
          locationName,
          chosenDateYear,
          chosenDateMonth,
          chosenDateDay,
          startHour,
          finishHour,
        ]);
    return result;
  }

  static Future<String> getJobsCandidate(
      String table,
      String jobId,
      ) async {
    final db = await DBHelper.database();
    var result = await db.rawQuery(
        'SELECT * FROM $table WHERE idJob=?',
        [
          jobId,
        ]);

    var res = json.encode(result);
    return res;
  }

  static Future<String> getJobsCandidateUser(
      String table,
      String jobId,
      ) async {
    final db = await DBHelper.database();
    var result = await db.rawQuery(
        'SELECT * FROM $table WHERE idUser=?',
        [
          jobId,
        ]);
    var res = json.encode(result);
    return res;
  }

  static Future<String> getJobsCandidateToken(
      String table,
      String token,
      ) async {
    final db = await DBHelper.database();
    var result = await db.rawQuery(
        'SELECT * FROM $table WHERE idUser=?',
        [
          token,
        ]);
    var res = json.encode(result);
    return res;
  }

  static Future<void> updateJob(String table, Map<String, Object> data) async {
    // Get a reference to the database.
    final db = await DBHelper.database();

    await db.update(
      table,
      data,
      where: "id = ?",
      whereArgs: [data['id']],
    );
  }

  static Future<void> updateCandidature(String table, Map<String, Object> data) async {
    // Get a reference to the database.
    final db = await DBHelper.database();

    await db.update(
      table,
      data,
      where: "id = ?",
      whereArgs: [data['id']],
    );
  }

  static Future<void> deleteJob(String table, String id) async {
    // Get a reference to the database.
    final db = await DBHelper.database();

    await db.delete(
      table,
      where: "id = ?",
      whereArgs: [id],
    );
  }

  static Future<List<Map<String, dynamic>>> getDataByUserId(
      String table,
      String userId,
      ) async {
    final db = await DBHelper.database();
    var result = await db.rawQuery(
        'SELECT * FROM $table WHERE userId=?',
        [
          userId,
        ]);
    return result;
  }

  static Future<List<Map<String, dynamic>>> getUserByEmail(
    String table,
    String email,
  ) async {
    final db = await DBHelper.database();
    var result = await db.rawQuery('SELECT * FROM $table WHERE email=?', [
      email,
    ]);
    return result;
  }

  static Future<List<Map<String, dynamic>>> getUserByFacebookId(
    String table,
    String facebookId,
  ) async {
    final db = await DBHelper.database();
    var result = await db.rawQuery('SELECT * FROM $table WHERE facebookId=?', [
      facebookId,
    ]);
    return result;
  }

  static Future<List<Map<String, dynamic>>> getJobsByUserId(
      String table,
      String userId,
      ) async {
    final db = await DBHelper.database();
    var result = await db.rawQuery('SELECT * FROM $table WHERE userId=?', [
      userId,
    ]);
    return result;
  }

  static Future<String> getJobByJobId(String table, Map<String, Object> data) async {
    final db = await DBHelper.database();
    var result = await db.rawQuery('SELECT * FROM $table WHERE id=?', [
      data['id'],
    ]);

    var res = json.encode(result);
    return res;
  }

  static Future<String> getJobsByJobId(String table, String jobId) async {
    final db = await DBHelper.database();
    var result = await db.rawQuery('SELECT * FROM $table WHERE id=?', [
      jobId,
    ]);

    var res = json.encode(result);
    return res;
  }

  static Future<String> signup(String table, Map<String, Object> data) async {
    final db = await DBHelper.database();
    data['idToken'] = randomAlphaNumeric(30);
    Map<String, dynamic> response = {
      'error': {'message': ''},
      'localId': data['id'],
      'idToken': data['idToken'],
      'email': '',
      'firstName': '',
      'lastName': '',
      'birthYear': null,
      'gender': null,
      'password': '',
      'facebookId': '',
    };

    var user = await getUserByEmail(table, data['email']);

    if (user.length != 0) {
      if (user[0]['email'] != '') {
        response['error']['message'] += ', EMAIL_EXISTS';
      } else if (user[0]['password'].length < 8) {
        response['error']['message'] += ', WEAK_PASSWORD';
      }
      response['idToken'] = user[0]['idToken'];
      response['localId'] = user[0]['id'];
    } else {
      db.insert(
        table,
        data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace,
      );

      user = await getUserByEmail(table, data['email']);
    }

    if (user.length != 0) {
      response['expiresIn'] = '1800';
      response['email'] = user[0]['email'];
      response['password'] = user[0]['password'];
      response['firstName'] = user[0]['firstName'];
      response['lastName'] = user[0]['lastName'];
      response['birthYear'] = user[0]['birthYear'];
      response['gender'] = user[0]['gender'];
      response['facebookId'] = user[0]['facebookId'];
    }
    var res = json.encode(response);
    return res;
  }

  static Future<String> login(String table, Map<String, Object> data) async {
    final db = await DBHelper.database();

    Map<String, dynamic> response = {
      'error': {'message': ''},
      'localId': data['id'],
      'idToken': data['idToken'],
      'email': '',
      'firstName': '',
      'lastName': '',
      'birthYear': null,
      'gender': null,
      'password': '',
      'facebookId': '',
    };

    var user = await getUserByEmail(table, data['email']);

    if (user.length != 0) {
      if (user[0]['password'] != data['password']) {
        response['error']['message'] += ', INVALID_PASSWORD';
      }
      response['idToken'] = user[0]['idToken'];
      response['localId'] = user[0]['id'];
    } else {
      response['error']['message'] += ', EMAIL_NOT_FOUND';
    }

    if (user.length != 0 && user[0]['password'] == data['password']) {
      response['expiresIn'] = '1800';
      response['email'] = user[0]['email'];
      response['password'] = user[0]['password'];
      response['firstName'] = user[0]['firstName'];
      response['lastName'] = user[0]['lastName'];
      response['birthYear'] = user[0]['birthYear'];
      response['gender'] = user[0]['gender'];
      response['facebookId'] = user[0]['facebookId'];
    }
    var res = json.encode(response);
    return res;
  }

  static Future<String> loginFacebook(String table, Map<String, Object> data) async {
    final db = await DBHelper.database();
    Map<String, dynamic> response = {
      'error': {'message': ''},
      'localId': data['id'],
      'idToken': '',
      'email': '',
      'firstName': '',
      'lastName': '',
      'birthYear': null,
      'gender': null,
      'password': '',
      'facebookId': '',
    };

    var user = await getUserByFacebookId(table, data['facebookId']);

    if (user.length != 0) {
      response['localId'] = user[0]['id'];
      response['expiresIn'] = '1800';
      response['email'] = user[0]['email'];
      response['idToken'] = user[0]['idToken'];
      response['password'] = user[0]['password'];
      response['firstName'] = user[0]['firstName'];
      response['lastName'] = user[0]['lastName'];
      response['birthYear'] = user[0]['birthYear'];
      response['gender'] = user[0]['gender'];
      response['facebookId'] = user[0]['facebookId'];
    } else {
      signup(table, data);
    }

    var res = json.encode(response);
    return res;
  }
  static Future<String> existsFacebookId(String table, Map<String, Object> data) async {
    var user = await getUserByFacebookId(table, data['facebookId']);
    Map<String, dynamic> response = {
      'exists': '',
    };

    if(user.length != 0) {
      response['exists'] = true;
    } else {
      response['exists'] = false;
    }

    var res = json.encode(response);
    return res;
  }

  // from this part is for querying users only

  static Future<String> getUserByUserId(String table, Map<String, Object> data) async {
    final db = await DBHelper.database();
    var result = await db.rawQuery('SELECT * FROM $table WHERE id=?', [
      data['id'],
    ]);

    var res = json.encode(result);
    return res;
  }

  static Future<void> updateUser(String table, Map<String, Object> data) async {
    // Get a reference to the database.
    final db = await DBHelper.database();

    await db.update(
      table,
      data,
      where: "id = ?",
      whereArgs: [data['id']],
    );
  }
  static Future<void> changePassword(String table, Map<String, Object> data) async {
    // Get a reference to the database.
    final db = await DBHelper.database();

    await db.update(
      table,
      data,
      where: "id = ?",
      whereArgs: [data['id']],
    );
  }

//  static Future<String> hasJobs(String table, Map<String, Object> data) async {
//    var user = await getJobsByUserId(table, data['userId']);
//    Map<String, dynamic> response = {
//      'exists': '',
//    };
//
//    if(user.length != 0) {
//      response['exists'] = true;
//    } else {
//      response['exists'] = false;
//    }
//
//    var res = json.encode(response);
//    return res;
//  }

  static Future<String> hasJobs(String table, Map<String, Object> data) async {
    Map<String, dynamic> response = {
      'exists': '',
      'existsJobAsCandidate': false,
    };

    var res = await getJobsCandidateUser('job_candidates', data['token']);
    var listJobs = json.decode(res);
    if(listJobs.length != 0) {
      response['existsJobAsCandidate'] = true;
    }

    var user = await getJobsByUserId(table, data['userId']);

    if(user.length != 0) {
      response['exists'] = true;
    } else {
      response['exists'] = false;
    }

    var res1 = json.encode(response);
    return res1;
  }

  static Future<String> getJobsAsCandidate(String table, String idUser) async {

    var res = await getJobsCandidateUser('job_candidates', idUser);
    var listJobs = json.decode(res);
    var resJobs = [];

    for(var entry in listJobs) {
      var user = await getJobsByJobId('jobs', entry['idJob']);
      if(user.length != 0) {
        resJobs.add(entry);
      }
    }

    var res1 = json.encode(resJobs);
    return res1;
  }
}
