import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../job/posted_job_screen.dart';
import '../../providers/jobs.dart';
import '../../providers/users.dart';
import '../../models/user.dart';

class JobListScreen extends StatefulWidget {
  static const routeName = '/job-list';

  @override
  _JobListScreenState createState() => _JobListScreenState();
}

class _JobListScreenState extends State<JobListScreen> {
  Map<String, User> _jobUsers;

  var _isLoading = true;

  Future<void> getJobUsers(BuildContext context) async {
    final jobs = Provider.of<Jobs>(context, listen: false).items;
    await Provider.of<Users>(context, listen: false)
        .getJobUsers(jobs)
        .then((value) {
          setState(() {
            _jobUsers = value;
            _isLoading = false;
          });

    });
    _isLoading = false;
  }

  Future<void> _goToPostedJobScreen(BuildContext context, String jobId, String userId) async {
    var navigationResult = await Navigator.of(context).pushNamed(
      PostedJobScreen.routeName,
      arguments: [jobId, userId, 'find'],
    );
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
      body: FutureBuilder(
        future: Provider.of<Jobs>(context, listen: false)
            .fetchAndSetPlaces(
          list['locationName'],
          list['locationLatitude'],
          list['locationLongitude'],
          list['chosenDate'],
          list['chosenStartHour'],
          list['chosenFinishHour'],
        )
            .then((_) {
              if(_isLoading == true) {
                getJobUsers(context);
              }
        }),
        builder: (ctx, snapShot) => _isLoading == true
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Consumer<Jobs>(
                child: Center(
                  child: Text(
                      'Got no jobs yet, come back and search later for new jobs!'),
                ),
                builder: (ctx, jobs, ch) => jobs.items.length <= 0
                    ? ch
                    : ListView.builder(
                        itemBuilder: (ctx, i) => GestureDetector(
                          onTap: () {
                            _goToPostedJobScreen(context, jobs.items[i].id, _jobUsers[jobs.items[i].userId].id);
                          },
                          child: Card(
                            margin: const EdgeInsets.only(
                              left: 25,
                              right: 25,
                              top: 10,
                            ),
                            elevation: 5,
                            shape: RoundedRectangleBorder(
                              //side: BorderSide(color: Colors.red, width: 2.0),
                              borderRadius: BorderRadius.circular(
                                20.0,
                              ),
                            ),
                            child: Container(
                              width: double.infinity,
                              padding: EdgeInsets.all(20),
                              child: Column(
                                children: <Widget>[
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text(
                                        jobs.items[i].title,
                                        style: TextStyle(
                                            color:
                                                Theme.of(context).primaryColor,
                                            fontSize: 23,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        '${jobs.items[i].pricePerWorkerPerHour}lei/h',
                                        style: TextStyle(
                                          fontSize: 19,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 16,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      SizedBox(
                                        width: 4,
                                      ),
                                      Icon(Icons.date_range),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        jobs.items[i].dateTimeStart.day ==
                                                    DateTime.now().day &&
                                                jobs.items[i].dateTimeStart.month ==
                                                    DateTime.now().month &&
                                                jobs.items[i].dateTimeStart.year ==
                                                    DateTime.now().year
                                            ? 'Azi,'
                                            : '${jobs.items[i].dateTimeStart.day.toString().padLeft(2, '0')}-'
                                                '${jobs.items[i].dateTimeStart.month.toString().padLeft(2, '0')}-'
                                                '${jobs.items[i].dateTimeStart.year.toString().padLeft(2, '0')},',
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                            fontSize: 19,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        '${jobs.items[i].dateTimeStart.hour.toString().padLeft(2, '0')}:'
                                        '${jobs.items[i].dateTimeStart.minute.toString().padLeft(2, '0')}',
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                            fontSize: 19,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ],
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(
                                      top: 14,
                                      bottom: 14,
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      SizedBox(
                                        width: 4,
                                      ),
                                      Icon(
                                        Icons.location_on,
                                        size: 28,
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Container(
                                        width: 250,
                                        child: Text(
                                          '${jobs.items[i].location.toString()}',
                                          style: TextStyle(
                                              fontSize: 17,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: <Widget>[
                                      Text(
                                        '${_jobUsers[jobs.items[i].userId].firstName}',
                                        style: TextStyle(
                                          fontSize: 19,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 12,
                                      ),
                                      CircleAvatar(
                                        backgroundImage: AssetImage(
                                            'assets/images/profil.jpeg'),
                                        radius: 26,
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        itemCount: jobs.items.length,
                      ),
              ),
      ),
    );
  }
}
