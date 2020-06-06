import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';

import '../../models/job.dart';
import '../../widgets/divider.dart';
import 'job_observations_input_screen.dart';

class JobHoursInputScreen extends StatefulWidget {
  static const routeName = '/job-hours';

  @override
  _JobHoursInputScreenState createState() => _JobHoursInputScreenState();
}

class _JobHoursInputScreenState extends State<JobHoursInputScreen> {
  //var _calendarController = CalendarController();
  DateTime _dateTimeDeLa;
  DateTime _dateTimePanaLa;
  DateTime time = DateTime.now();

  var _editedJob = Job(
    id: null,
    title: '',
    description: '',
    nrWorkers: 0,
    genderWorkers: 0,
    location: '',
    detailsLocation: '',
    pricePerWorkerPerHour: 0,
    dateTimeStart: null,
    dateTimeFinish: null,
    duration: 0.0,
  );

  @override
  void initState() {
    super.initState();
    _dateTimeDeLa = DateTime(time.year, time.month, time.day, 9, 0,
        time.second, time.millisecond, time.microsecond);
    _dateTimePanaLa = DateTime(time.year, time.month, time.day, 17, 0,
        time.second, time.millisecond, time.microsecond);
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _saveForm(Job job) {
    print(_dateTimeDeLa.toIso8601String());
    print(_dateTimePanaLa.toIso8601String());

      _editedJob = Job(
        id: null,
        title: job.title,
        description: job.description,
        nrWorkers: job.nrWorkers,
        genderWorkers: job.genderWorkers,
        location: job.location,
        detailsLocation: job.detailsLocation,
        pricePerWorkerPerHour: job.pricePerWorkerPerHour,
        dateTimeStart: _dateTimeDeLa,
        dateTimeFinish: _dateTimePanaLa,
        duration: job.duration,
      );

    Navigator.of(context).pushNamed(JobObservationsInputScreen.routeName, arguments: _editedJob);
  }

  @override
  Widget build(BuildContext context) {
    final job = ModalRoute.of(context).settings.arguments as Job;
    final jobDate = job.dateTimeStart;

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
                      'Care este intervalul orar al jobului?',
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
                        padding: EdgeInsets.only(left: 30,),
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
                        padding: EdgeInsets.only(right: 30,),
                        child: TimePickerSpinner(
                          is24HourMode: true,
                          normalTextStyle: TextStyle(
                              fontSize: 26,
                              color: Colors.black38
                          ),
                          highlightedTextStyle: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).primaryColor,
                          ),
                          spacing: 50,
                          itemHeight: 45,
                          isForce2Digits: true,
                          time: DateTime(jobDate.year, jobDate.month, jobDate.day, 9, 0, time.second, time.millisecond, time.microsecond),
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
                        padding: EdgeInsets.only(left: 30,),
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
                        padding: EdgeInsets.only(right: 30,),
                        child: TimePickerSpinner(
                          is24HourMode: true,
                          normalTextStyle: TextStyle(
                              fontSize: 24,
                              color: Colors.black38
                          ),
                          highlightedTextStyle: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColor,
                          ),
                          spacing: 50,
                          itemHeight: 45,
                          isForce2Digits: true,
                          time: DateTime(jobDate.year, jobDate.month, jobDate.day, 17, 0, time.second, time.millisecond, time.microsecond),
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
          _saveForm(job);
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
