import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';

import '../../models/job.dart';
import '../../widgets/divider.dart';
import 'job_list_screen.dart';

class JobHoursSearchScreen extends StatefulWidget {
  static const routeName = '/job-hours-search';

  @override
  _JobHoursSearchScreenState createState() => _JobHoursSearchScreenState();
}

class _JobHoursSearchScreenState extends State<JobHoursSearchScreen> {
  //var _calendarController = CalendarController();
  DateTime time = DateTime.now();
  DateTime _dateTimeDeLa;
  DateTime _dateTimePanaLa;

  @override
  void initState() {
    super.initState();
    _dateTimeDeLa = DateTime(time.year, time.month, time.day, 8, 0,
        time.second, time.millisecond, time.microsecond);
    _dateTimePanaLa = DateTime(time.year, time.month, time.day, 22, 0,
        time.second, time.millisecond, time.microsecond);
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _saveForm(String locationName, DateTime chosenDate) {
    _dateTimeDeLa = DateTime(chosenDate.year, chosenDate.month, chosenDate.day,
        _dateTimeDeLa.hour, _dateTimeDeLa.minute);
    _dateTimePanaLa = DateTime(chosenDate.year, chosenDate.month, chosenDate.day,
        _dateTimePanaLa.hour, _dateTimePanaLa.minute);
    Navigator.of(context)
        .pushNamed(JobListScreen.routeName, arguments: {
      'locationName': locationName,
      'chosenDate': chosenDate,
      'chosenStartHour': _dateTimeDeLa,
      'chosenFinishHour': _dateTimePanaLa,
    });
  }

  @override
  Widget build(BuildContext context) {
    final list =
        ModalRoute.of(context).settings.arguments as Map<String, Object>;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(
          color: Theme.of(context).primaryColor,
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        height: MediaQuery.of(context).size.height * 0.9,
        child: Container(
          margin: const EdgeInsets.only(
            left: 20,
            right: 20,
            top: 10,
          ),
          child: Form(
            //key: _form,
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.only(
                      bottom: 45,
                    ),
                    child: const Text(
                      'Între ce ore vei putea lucra?',
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.only(
                          left: 30,
                        ),
                        child: Center(
                          child: Text(
                            'De la ora: ',
                            style: TextStyle(
                              color: Colors.black87,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(
                          right: 30,
                        ),
                        child: TimePickerSpinner(
                          is24HourMode: true,
                          normalTextStyle:
                              TextStyle(fontSize: 26, color: Colors.black38),
                          highlightedTextStyle: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColor,
                          ),
                          spacing: 50,
                          itemHeight: 45,
                          isForce2Digits: true,
                          time: DateTime(time.year, time.month, time.day, 8, 0,
                              time.second, time.millisecond, time.microsecond),
                          onTimeChange: (time) {
                            setState(() {
                              _dateTimeDeLa = time;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  DividerWidget(''),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.only(
                          left: 30,
                        ),
                        child: Center(
                          child: Text(
                            'Pana la ora: ',
                            style: TextStyle(
                              color: Colors.black87,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(
                          right: 30,
                        ),
                        child: TimePickerSpinner(
                          is24HourMode: true,
                          normalTextStyle:
                              TextStyle(fontSize: 24, color: Colors.black38),
                          highlightedTextStyle: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColor,
                          ),
                          spacing: 50,
                          itemHeight: 45,
                          isForce2Digits: true,
                          time: DateTime(time.year, time.month, time.day, 22, 0,
                              time.second, time.millisecond, time.microsecond),
                          onTimeChange: (time) {
                            setState(() {
                              _dateTimePanaLa = time;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          _saveForm(list['locationName'], list['chosenDate']);
        },
        label: Row(
          children: <Widget>[
            Text(
              'Înainte',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
            Icon(
              Icons.navigate_next,
              color: Colors.white,
            ),
          ],
        ),
        backgroundColor: Theme.of(context).primaryColor,
        shape: RoundedRectangleBorder(),
      ),
    );
  }
}
