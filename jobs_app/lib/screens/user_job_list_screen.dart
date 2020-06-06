import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './job/job_plan_screen.dart';

import 'user_job_list_history_screen.dart';
import './job/posted_job_screen.dart';
import '../providers/jobs.dart';

class UserJobListScreen extends StatefulWidget {
  static const routeName = '/user-job-list';
  final _hasJobs;
  final _hasJobsAsCandidate;

  UserJobListScreen(this._hasJobs, this._hasJobsAsCandidate);

  @override
  _UserJobListScreenState createState() => _UserJobListScreenState();
}

class _UserJobListScreenState extends State<UserJobListScreen> {
  List<Map<String, dynamic>> _jobCandidates = [];
  Map<String, dynamic> _jobAsCandidates = {};
  var _isInit = false;
  var _isLoading = true;

  Future<void> getJobCandidates(BuildContext context) async {
    await Provider.of<Jobs>(context, listen: false)
        .getJobCandidates()
        .then((value) {
      setState(() {
        _jobCandidates = value;
        _isLoading = false;
      });
    });
  }

  Future<void> getJobAsCandidates(BuildContext context) async {
    setState(() {
      _isLoading = true;
    });
    await Provider.of<Jobs>(context, listen: false)
        .getJobsAsCandidate()
        .then((value) {
      setState(() {
        _isLoading = false;
      });
    });
  }

  Future<void> fetchJobs(BuildContext context) async {
    Provider.of<Jobs>(context, listen: false).fetchAndSetJobsByUserId();
  }

  bool hasCandidateHolding(String idJob) {
    if (_jobCandidates.length > 0) {
      for (var jobCandidate in _jobCandidates) {
        if (int.tryParse(idJob) == jobCandidate['job_id'] &&
            jobCandidate['accepted'] == false) {
          return true;
        }
      }
    }
    return false;
  }

  Future<void> _goToPostedJobScreen(
      BuildContext context, String jobId, String userId) async {
    var navigationResult = await Navigator.of(context).pushNamed(
      PostedJobScreen.routeName,
      arguments: [jobId, userId],
    );
  }

  Future<void> _goToHistoryJobsScreen(BuildContext context) async {
    var navigationResult = await Navigator.of(context)
        .pushNamed(
      UserJobListHistoryScreen.routeName,
    )
        .then((value) {
      setState(() {_isLoading = true;});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: Provider.of<Jobs>(context, listen: false)
            .fetchAndSetJobsByUserId()
            .then((_) {
          if (_isLoading == true) {
            if (widget._hasJobs) {
              getJobCandidates(context);
            }
            if (widget._hasJobsAsCandidate) {
              getJobAsCandidates(context);
            }
          }
        }),
        builder: (ctx, snapShot) => _isLoading == true
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Column(
                children: <Widget>[
                  widget._hasJobs
                      ? Container(
                          margin: const EdgeInsets.only(
                            top: 60,
                          ),
                          padding: EdgeInsets.only(
                            left: 25,
                            right: 25,
                          ),
                          alignment: Alignment.centerLeft,
                          child: const Text(
                            'Joburile tale',
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              fontSize: 31,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        )
                      : Container(
                          height: 0,
                          width: 0,
                        ),
                  widget._hasJobs
                      ? Expanded(
                          child: Consumer<Jobs>(
                            child: Center(
                              child: Text(
                                  'Got no jobs yet, come back and search later for new jobs!'),
                            ),
                            builder: (ctx, jobs, ch) => jobs.userJobs.length <=
                                    0
                                ? ch
                                : ListView.builder(
                                    itemBuilder: (ctx, i) => GestureDetector(
                                      onTap: () {
                                        Navigator.of(context).pushNamed(
                                          JobPlanScreen.routeName,
                                          arguments: [jobs.userJobs[i].id],
                                        );
                                      },
                                      child: Card(
                                        margin: const EdgeInsets.only(
                                          left: 25,
                                          right: 25,
                                          top: 10,
                                        ),
                                        elevation: 5,
                                        shape: RoundedRectangleBorder(
                                          side: hasCandidateHolding(
                                                  jobs.userJobs[i].id)
                                              ? BorderSide(
                                                  color: Colors.red, width: 2.0)
                                              : BorderSide(
                                                  color: Colors.white,
                                                ),
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
                                                    MainAxisAlignment.start,
                                                children: <Widget>[
                                                  Text(
                                                    jobs.userJobs[i].title,
                                                    style: TextStyle(
                                                        color: Theme.of(context)
                                                            .primaryColor,
                                                        fontSize: 23,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                height: 16,
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: <Widget>[
                                                  SizedBox(
                                                    width: 4,
                                                  ),
                                                  Icon(Icons.date_range),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  Text(
                                                    jobs
                                                                    .userJobs[i]
                                                                    .dateTimeStart
                                                                    .day ==
                                                                DateTime.now()
                                                                    .day &&
                                                            jobs
                                                                    .userJobs[i]
                                                                    .dateTimeStart
                                                                    .month ==
                                                                DateTime.now()
                                                                    .month &&
                                                            jobs
                                                                    .userJobs[i]
                                                                    .dateTimeStart
                                                                    .year ==
                                                                DateTime.now()
                                                                    .year
                                                        ? 'Azi,'
                                                        : '${jobs.userJobs[i].dateTimeStart.day.toString().padLeft(2, '0')}-'
                                                            '${jobs.userJobs[i].dateTimeStart.month.toString().padLeft(2, '0')}-'
                                                            '${jobs.userJobs[i].dateTimeStart.year.toString().padLeft(2, '0')},',
                                                    textAlign: TextAlign.start,
                                                    style: TextStyle(
                                                        fontSize: 19,
                                                        fontWeight:
                                                            FontWeight.w600),
                                                  ),
                                                  SizedBox(
                                                    width: 5,
                                                  ),
                                                  Text(
                                                    '${jobs.userJobs[i].dateTimeStart.hour.toString().padLeft(2, '0')}:'
                                                    '${jobs.userJobs[i].dateTimeStart.minute.toString().padLeft(2, '0')}',
                                                    textAlign: TextAlign.start,
                                                    style: TextStyle(
                                                        fontSize: 19,
                                                        fontWeight:
                                                            FontWeight.w600),
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
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
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
                                                      '${jobs.userJobs[i].location.toString()}',
                                                      style: TextStyle(
                                                          fontSize: 17,
                                                          fontWeight:
                                                              FontWeight.w600),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              hasCandidateHolding(
                                                      jobs.userJobs[i].id)
                                                  ? Column(
                                                      children: <Widget>[
                                                        SizedBox(
                                                          height: 10,
                                                        ),
                                                        Divider(
                                                          thickness: 1,
                                                        ),
                                                        SizedBox(
                                                          height: 5,
                                                        ),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: <Widget>[
                                                            Icon(
                                                              Icons
                                                                  .filter_frames,
                                                              color: Colors.red,
                                                            ),
                                                            Text(
                                                              'Candidatură în așteptarea aprobării',
                                                              style: TextStyle(
                                                                fontSize: 15,
                                                                color:
                                                                    Colors.red,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    )
                                                  : Container(),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    itemCount: jobs.userJobs.length,
                                  ),
                          ),
                        )
                      : Container(
                          height: 0,
                          width: 0,
                        ),
                  widget._hasJobsAsCandidate
                      ? Container(
                          margin: !widget._hasJobs
                              ? const EdgeInsets.only(
                                  top: 60,
                                )
                              : const EdgeInsets.only(
                                  top: 10,
                                ),
                          padding: EdgeInsets.only(
                            left: 25,
                            right: 25,
                          ),
                          alignment: Alignment.centerLeft,
                          child: const Text(
                            'Rezervările tale',
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        )
                      : Container(
                          height: 0,
                          width: 0,
                        ),
                  widget._hasJobsAsCandidate
                      ? Expanded(
                          child: Consumer<Jobs>(
                            child: Center(
                              child: Text(
                                  'Got no jobs yet, come back and search later for new jobs!'),
                            ),
                            builder: (ctx, jobs, ch) => jobs
                                        .jobsAsCandidate.length <=
                                    0
                                ? ch
                                : ListView.builder(
                                    itemBuilder: (ctx, i) => GestureDetector(
                                      onTap: () {
                                        _goToPostedJobScreen(
                                          context,
                                          jobs.jobsAsCandidate[i]['id']
                                              .toString(),
                                          jobs.jobsAsCandidate[i]['user_id']
                                              .toString(),
                                        );
                                      },
                                      child: Card(
                                        margin: const EdgeInsets.only(
                                          left: 25,
                                          right: 25,
                                          top: 10,
                                        ),
                                        elevation: 5,
                                        shape: RoundedRectangleBorder(
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
                                                    MainAxisAlignment.start,
                                                children: <Widget>[
                                                  Text(
                                                    jobs.jobsAsCandidate[i]
                                                        ['title'],
                                                    style: TextStyle(
                                                        color: Theme.of(context)
                                                            .primaryColor,
                                                        fontSize: 23,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                height: 16,
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: <Widget>[
                                                  SizedBox(
                                                    width: 4,
                                                  ),
                                                  Icon(Icons.date_range),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  Text(
                                                    DateTime.tryParse(jobs.jobsAsCandidate[i]['start_date'])
                                                                    .day ==
                                                                DateTime.now()
                                                                    .day &&
                                                            DateTime.tryParse(jobs
                                                                            .jobsAsCandidate[i][
                                                                        'start_date'])
                                                                    .month ==
                                                                DateTime.now()
                                                                    .month &&
                                                            DateTime.tryParse(jobs
                                                                            .jobsAsCandidate[i][
                                                                        'start_date'])
                                                                    .year ==
                                                                DateTime.now()
                                                                    .year
                                                        ? 'Azi,'
                                                        : '${DateTime.tryParse(jobs.jobsAsCandidate[i]['start_date']).day.toString().padLeft(2, '0')}-'
                                                            '${DateTime.tryParse(jobs.jobsAsCandidate[i]['start_date']).month.toString().padLeft(2, '0')}-'
                                                            '${DateTime.tryParse(jobs.jobsAsCandidate[i]['start_date']).year.toString().padLeft(2, '0')},',
                                                    textAlign: TextAlign.start,
                                                    style: TextStyle(
                                                        fontSize: 19,
                                                        fontWeight:
                                                            FontWeight.w600),
                                                  ),
                                                  SizedBox(
                                                    width: 5,
                                                  ),
                                                  Text(
                                                    '${DateTime.tryParse(jobs.jobsAsCandidate[i]['start_date']).hour.toString().padLeft(2, '0')}:'
                                                    '${DateTime.tryParse(jobs.jobsAsCandidate[i]['start_date']).minute.toString().padLeft(2, '0')}',
                                                    textAlign: TextAlign.start,
                                                    style: TextStyle(
                                                        fontSize: 19,
                                                        fontWeight:
                                                            FontWeight.w600),
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
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
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
                                                      '${jobs.jobsAsCandidate[i]['location'].toString()}',
                                                      style: TextStyle(
                                                          fontSize: 17,
                                                          fontWeight:
                                                              FontWeight.w600),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              jobs.jobsAsCandidate[i]
                                                          ['accepted'] ==
                                                      false
                                                  ? Column(
                                                      children: <Widget>[
                                                        SizedBox(
                                                          height: 10,
                                                        ),
                                                        Divider(
                                                          thickness: 1,
                                                        ),
                                                        SizedBox(
                                                          height: 5,
                                                        ),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: <Widget>[
                                                            Icon(
                                                              Icons
                                                                  .filter_frames,
                                                              color: Colors.red,
                                                            ),
                                                            Text(
                                                              'Candidatură în așteptarea aprobării',
                                                              style: TextStyle(
                                                                fontSize: 15,
                                                                color:
                                                                    Colors.red,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    )
                                                  : Column(
                                                      children: <Widget>[
                                                        SizedBox(
                                                          height: 10,
                                                        ),
                                                        Divider(
                                                          thickness: 1,
                                                        ),
                                                        SizedBox(
                                                          height: 5,
                                                        ),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: <Widget>[
                                                            Icon(
                                                              Icons
                                                                  .check_circle,
                                                              color:
                                                                  Colors.green,
                                                              size: 25,
                                                            ),
                                                            Text(
                                                              'Candidatură acceptată',
                                                              style: TextStyle(
                                                                fontSize: 16,
                                                                color: Colors
                                                                    .green,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    itemCount: jobs.jobsAsCandidate.length,
                                  ),
                          ),
                        )
                      : Container(
                          height: 0,
                          width: 0,
                        ),
                  SizedBox(
                    height: 67,
                  ),
                ],
              ),
      ),
      bottomSheet: Container(
        width: double.infinity,
        padding: EdgeInsets.only(
          left: 25,
          right: 25,
          top: 15,
          bottom: 15,
        ),
        color: Colors.white,
        child: InkWell(
          onTap: () {
            _goToHistoryJobsScreen(context);
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                'Istoricul joburilor',
                style: TextStyle(
                  fontSize: 19,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              Icon(
                Icons.navigate_next,
                size: 30,
                color: Theme.of(context).primaryColor,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
