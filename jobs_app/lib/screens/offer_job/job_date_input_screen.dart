import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../models/job.dart';
import 'job_hours_input_screen.dart';

class JobDateInputScreen extends StatefulWidget {
  static const routeName = '/job-date';

  @override
  _JobDateInputScreenState createState() => _JobDateInputScreenState();
}

class _JobDateInputScreenState extends State<JobDateInputScreen> {
  var _calendarController = CalendarController();
  DateTime _chosenDate = DateTime.now();

  var _editedJob = Job(
    id: null,
    title: '',
    description: '',
    nrWorkers: 0,
    genderWorkers: 0,
    location: '',
    locationLatitude: 0.0,
    locationLongitude: 0.0,
    detailsLocation: '',
    pricePerWorkerPerHour: 0,
    dateTimeStart: null,
    dateTimeFinish: null,
    duration: 0.0,
  );

  @override
  void initState() {
    super.initState();
    _calendarController = CalendarController();
  }

  @override
  void dispose() {
    _calendarController.dispose();
    super.dispose();
  }

  void _saveForm(Job job) {
    //print(_chosenDate.toIso8601String());

      _editedJob = Job(
        id: null,
        title: job.title,
        description: job.description,
        nrWorkers: job.nrWorkers,
        genderWorkers: job.genderWorkers,
        location: job.location,
        locationLatitude: job.locationLatitude,
        locationLongitude: job.locationLongitude,
        detailsLocation: job.detailsLocation,
        pricePerWorkerPerHour: job.pricePerWorkerPerHour,
        dateTimeStart: _chosenDate,
        dateTimeFinish: _editedJob.dateTimeFinish,
        duration: job.duration,
      );

    Navigator.of(context).pushNamed(JobHoursInputScreen.routeName, arguments: _editedJob);
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
                      'Care este data in care va avea loc jobul?',
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  TableCalendar(
                    locale: 'ro_RO',
                    calendarController: _calendarController,
                    startDay: DateTime.now(),
                    initialSelectedDay: DateTime.now(),
                    startingDayOfWeek: StartingDayOfWeek.monday,
                    onDaySelected: (date, events) {
                      setState(() {
                        _chosenDate = date;
                      });
                      print(date.toIso8601String());
                    },
                    headerStyle: HeaderStyle(
                      centerHeaderTitle: true,
                      formatButtonVisible: false,
                      titleTextBuilder: (date, _) => Text(
                        DateFormat.MMMM('ro_RO').format(date).replaceFirst(
                              RegExp('[ifmaisond]'),
                              DateFormat.MMMM('ro_RO')
                                  .format(date)
                                  .substring(0, 1)
                                  .toUpperCase(),
                            ),
                        style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                      ).data,
                    ),
                    builders: CalendarBuilders(
                      selectedDayBuilder: (context, date, events) => Container(
                        margin: const EdgeInsets.all(4.0),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            borderRadius: BorderRadius.circular(20.0)),
                        child: Text(
                          date.day.toString(),
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      todayDayBuilder: (context, date, events) => Container(
                        margin: const EdgeInsets.all(4.0),
                        alignment: Alignment.center,
                        child: Text(
                          date.day.toString(),
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).primaryColor),
                        ),
                      ),
                      dayBuilder: (context, date, events) => Container(
                        margin: const EdgeInsets.all(4.0),
                        alignment: Alignment.center,
                        child: Text(
                          date.day.toString(),
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      unavailableDayBuilder: (context, date, events) =>
                          Container(
                        margin: const EdgeInsets.all(4.0),
                        alignment: Alignment.center,
                        child: Text(
                          date.day.toString(),
                          style: TextStyle(
                              color: Colors.black38,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      outsideWeekendDayBuilder: (context, date, events) =>
                          Container(
                        margin: const EdgeInsets.all(4.0),
                        alignment: Alignment.center,
                        child: Text(
                          date.day.toString(),
                          style: TextStyle(
                              color: Colors.black38,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      outsideDayBuilder: (context, date, events) => Container(
                        margin: const EdgeInsets.all(4.0),
                        alignment: Alignment.center,
                        child: Text(
                          date.day.toString(),
                          style: TextStyle(color: Colors.black38),
                        ),
                      ),
                      weekendDayBuilder: (context, date, events) => Container(
                        margin: const EdgeInsets.all(4.0),
                        alignment: Alignment.center,
                        child: Text(
                          date.day.toString(),
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      dowWeekdayBuilder: (context, dayName) => Container(
                        margin: const EdgeInsets.only(
                          top: 4.0,
                          left: 4.0,
                          right: 4.0,
                          bottom: 20.0,
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          dayName,
                          style: TextStyle(color: Colors.black, fontSize: 16),
                        ),
                      ),
                    ),
                  )
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
