import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/jobs.dart';
import '../../widgets/job_container_edit.dart';
import './job_details_edit_screen.dart';
import './job_workers_edit_screen.dart';
import './job_date_edit_screen.dart';
import './job_hours_edit_screen.dart';
import './job_location_edit_screen.dart';
import '../../models/job.dart';

class YourPostScreen extends StatefulWidget {
  static const routeName = '/your-post';

  @override
  _YourPostScreenState createState() => _YourPostScreenState();
}

class _YourPostScreenState extends State<YourPostScreen> {
  var _isLoading = false;
  var _isInit = true;
  Job job;
  final globalKey = GlobalKey<ScaffoldState>();

  @override
  Future<void> didChangeDependencies() async {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      final jobId = ModalRoute.of(context).settings.arguments as String;
      print(jobId);
      await Provider.of<Jobs>(context).getJobByJobId(jobId).then((value) {
        setState(() {
          _isLoading = false;
          job = value;
          //print(job.title);
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  TextStyle getSmallTitleTextStyle(BuildContext context) {
    return TextStyle(
      fontSize: 17,
      color: Theme.of(context).primaryColor,
      fontWeight: FontWeight.w700,
    );
  }

  TextStyle getContentTextStyle(BuildContext context) {
    return TextStyle(
      fontSize: 20,
      color: Colors.black87,
      fontWeight: FontWeight.w400,
    );
  }

  Icon getIcon(BuildContext context, IconData iconName) {
    return Icon(
      iconName,
      color: Colors.black87,
      size: 21,
    );
  }

  void fun() {
    // ceva pentru fiecare functie
  }

  Future<void> goToDetails(BuildContext context, Job job) async{
    var nav = await Navigator.of(context)
        .pushNamed(
      JobDetailsEditScreen.routeName,
      arguments: job,
    )
        .then((_) {
      setState(() {
        _isInit = true;
        _isLoading = false;
      });
      globalKey.currentState..removeCurrentSnackBar()
        ..showSnackBar(SnackBar(
          backgroundColor: Colors.green,
          content: Text(
            "Modificările salvate cu succes!",
            style: TextStyle(color: Colors.white),
          )));
    });

    print(nav);
  }

  Future<void> goToWorkers(BuildContext context, Job job) async{
    final navigationResult = await Navigator.of(context)
        .pushNamed(
      JobWorkersEditScreen.routeName,
      arguments: job,
    )
        .then((_) {
      setState(() {
        _isInit = true;
        _isLoading = false;
      });
      globalKey.currentState..removeCurrentSnackBar()
        ..showSnackBar(SnackBar(
            backgroundColor: Colors.green,
            content: Text(
              "Modificările salvate cu succes!",
              style: TextStyle(color: Colors.white),
            )));
    });
  }

  Future<void> goToDate(BuildContext context, Job job) async{
    await Navigator.of(context)
        .pushNamed(
      JobDateEditScreen.routeName,
      arguments: job,
    )
        .then((_) {
      setState(() {
        _isInit = true;
        _isLoading = false;
      });
      globalKey.currentState..removeCurrentSnackBar()
        ..showSnackBar(SnackBar(
            backgroundColor: Colors.green,
            content: Text(
              "Modificările salvate cu succes!",
              style: TextStyle(color: Colors.white),
            )));
    });
  }

  Future<void> goToHours(BuildContext context, Job job) async{
    await Navigator.of(context)
        .pushNamed(
      JobHoursEditScreen.routeName,
      arguments: job,
    )
        .then((_) {
      setState(() {
        _isInit = true;
        _isLoading = false;
      });
      globalKey.currentState..removeCurrentSnackBar()
        ..showSnackBar(SnackBar(
            backgroundColor: Colors.green,
            content: Text(
              "Modificările salvate cu succes!",
              style: TextStyle(color: Colors.white),
            )));
    });
  }

  Future<void> goToLocation(BuildContext context, Job job) async{
    await Navigator.of(context)
        .pushNamed(
      JobLocationEditScreen.routeName,
      arguments: job,
    )
        .then((_) {
      setState(() {
        _isInit = true;
        _isLoading = false;
      });
      globalKey.currentState..removeCurrentSnackBar()
        ..showSnackBar(SnackBar(
            backgroundColor: Colors.green,
            content: Text(
              "Modificările salvate cu succes!",
              style: TextStyle(color: Colors.white),
            )));
    });
  }

  String returnTypeOfWorker(int genderWorker) {
    switch (genderWorker) {
      case 0:
        return 'Fete si băieți';
      case 1:
        return 'Doar fete';
      case 2:
        return 'Doar băieți';
      default:
        return 'Fete si băieți';
    }
  }

  @override
  Widget build(BuildContext context) {
    //final job = ModalRoute.of(context).settings.arguments as Job;
    return Scaffold(
      key: globalKey,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(
          color: Theme.of(context).primaryColor,
        ),
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back, color: Theme.of(context).primaryColor,),
          onPressed: () => Navigator.of(context).pop(job),
        ),
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Container(
              padding: EdgeInsets.only(
                top: 20,
                left: 25,
                right: 25,
              ),
              color: Colors.white,
              child: ListView(
                children: <Widget>[
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Postarea ta',
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontSize: 31,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Container(
                    child: Text(
                      '  Puteti modifica toate detaliile jobului '
                      'până în momentul în care va incepe jobul.',
                      style: TextStyle(
                        fontSize: 17,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(children: <Widget>[
                    Expanded(
                      child: new Container(
                          margin: const EdgeInsets.only(right: 20.0),
                          child: Divider(
                            color: Colors.black54,
                            height: 50,
                          )),
                    ),
                    Text(
                      "administrează postarea",
                      style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 15,
                          fontWeight: FontWeight.bold),
                    ),
                    Expanded(
                      child: new Container(
                          margin: const EdgeInsets.only(left: 20.0),
                          child: Divider(
                            color: Colors.black54,
                            height: 50,
                          )),
                    ),
                  ]),
                  SizedBox(
                    height: 20,
                  ),
                  JobContainerEdit(
                    () {
                      goToDetails(context, job);
                    },
                    'Profil',
                    job.title,
                    getSmallTitleTextStyle(context),
                    getContentTextStyle(context),
                    getIcon(context, Icons.perm_identity),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  JobContainerEdit(
                        () {
                      goToWorkers(context, job);
                    },
                    'Preț pe candidat',
                    '${job.pricePerWorkerPerHour} lei/h',
                    getSmallTitleTextStyle(context),
                    getContentTextStyle(context),
                    getIcon(context, Icons.attach_money),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  JobContainerEdit(
                        () {
                      goToWorkers(context, job);
                    },
                    'Tipul de persoane',
                    returnTypeOfWorker(job.genderWorkers),
                    getSmallTitleTextStyle(context),
                    getContentTextStyle(context),
                    getIcon(context, Icons.person),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  JobContainerEdit(
                        () {
                      goToWorkers(context, job);
                    },
                    'Număr de persoane',
                    job.nrWorkers.toString(),
                    getSmallTitleTextStyle(context),
                    getContentTextStyle(context),
                    getIcon(context, Icons.people),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  JobContainerEdit(
                        () {
                      goToLocation(context, job);
                    },
                    'Locația',
                    '${job.location}',
                    getSmallTitleTextStyle(context),
                    getContentTextStyle(context),
                    getIcon(context, Icons.location_on),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  JobContainerEdit(
                        () {
                      goToDate(context, job);
                    },
                    'Data',
                    '${job.dateTimeStart.day.toString().padLeft(2, '0')}'
                        '.${job.dateTimeStart.month.toString().padLeft(2, '0')}'
                        '.${job.dateTimeStart.year}',
                    getSmallTitleTextStyle(context),
                    getContentTextStyle(context),
                    getIcon(context, Icons.date_range),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  JobContainerEdit(
                        () {
                      goToHours(context, job);
                    },
                    'Interval orar',
                    '${job.dateTimeStart.hour.toString().padLeft(2, '0')}'
                        ':${job.dateTimeStart.minute.toString().padLeft(2, '0')} - '
                        '${job.dateTimeFinish.hour.toString().padLeft(2, '0')}'
                        ':${job.dateTimeFinish.minute.toString().padLeft(2, '0')}',
                    getSmallTitleTextStyle(context),
                    getContentTextStyle(context),
                    getIcon(context, Icons.hourglass_empty),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  JobContainerEdit(
                    () {
                      goToDetails(context, job);
                    },
                    'Descriere',
                    ' ${job.description}',
                    getSmallTitleTextStyle(context),
                    getContentTextStyle(context),
                    getIcon(context, Icons.description),
                  ),
                ],
              ),
            ),
    );
  }
}
