import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';
import 'package:provider/provider.dart';

import '../../models/job.dart';
import '../../widgets/divider.dart';
import '../../providers/jobs.dart';

class JobHoursEditScreen extends StatefulWidget {
  static const routeName = '/job-hours-edit';

  @override
  _JobHoursEditScreenState createState() => _JobHoursEditScreenState();
}

class _JobHoursEditScreenState extends State<JobHoursEditScreen> {
  DateTime _dateTimeDeLa;
  DateTime _dateTimePanaLa;
  var _isLoading = false;
  var _isInit = true;
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
  Future<void> didChangeDependencies() async {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      final job =
      ModalRoute.of(context).settings.arguments as Job;
      setState(() {
        _dateTimeDeLa = job.dateTimeStart;
        _dateTimePanaLa = job.dateTimeFinish;
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _saveForm(Job job) async{
    _editedJob = Job(
      id: job.id,
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
      userId: job.userId,
    );

    try {
      await Provider.of<Jobs>(context, listen: false)
          .updateJob(_editedJob.id, _editedJob);
    } catch (error) {
      print(error);
    }

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final job = ModalRoute.of(context).settings.arguments as Job;

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
                        padding: EdgeInsets.only(
                          left: 30,
                        ),
                        child: Center(
                          child: Text(
                            'De la ora: ',
                            style: TextStyle(
                              color: Colors.black87,
                              fontSize: 24,
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
                          time: _dateTimeDeLa,
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
                              fontSize: 24,
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
                          time: _dateTimePanaLa,
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
              'Salvează',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
            SizedBox(width: 10,),
            Icon(
              Icons.check,
              color: Colors.white,
              size: 25,
            ),
          ],
        ),
        backgroundColor: Theme.of(context).primaryColor,
        shape: RoundedRectangleBorder(),
      ),
    );
  }
}
