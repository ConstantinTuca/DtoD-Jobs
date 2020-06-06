import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:provider/provider.dart';

import '../../models/job.dart';
import '../../providers/jobs.dart';

class JobDateEditScreen extends StatefulWidget {
  static const routeName = '/job-date-edit';

  @override
  _JobDateEditScreenState createState() => _JobDateEditScreenState();
}

class _JobDateEditScreenState extends State<JobDateEditScreen> {
  var _calendarController = CalendarController();
  DateTime _chosenDate = DateTime.now();

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
    _calendarController = CalendarController();
  }

  @override
  void dispose() {
    _calendarController.dispose();
    super.dispose();
  }

  Future<void> _saveForm(Job job) async {

    _editedJob = Job(
      id: job.id,
      title: job.title,
      description: job.description,
      nrWorkers: job.nrWorkers,
      genderWorkers: job.genderWorkers,
      location: job.location,
      detailsLocation: job.detailsLocation,
      pricePerWorkerPerHour: job.pricePerWorkerPerHour,
      dateTimeStart: DateTime(_chosenDate.year, _chosenDate.month, _chosenDate.day,
          job.dateTimeStart.hour, job.dateTimeStart.minute, 0, 0, 0),
      dateTimeFinish: DateTime(_chosenDate.year, _chosenDate.month, _chosenDate.day,
          job.dateTimeFinish.hour, job.dateTimeFinish.minute, 0, 0, 0),
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
                    initialSelectedDay: job.dateTimeStart,
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
                        style: TextStyle(
                            fontSize: 17, fontWeight: FontWeight.bold),
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
