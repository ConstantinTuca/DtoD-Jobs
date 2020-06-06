import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './job/job_plan_screen.dart';
import './job/posted_job_screen.dart';
import '../providers/jobs.dart';

class UserJobListHistoryScreen extends StatefulWidget {
  static const routeName = '/user-job-history-list';

  UserJobListHistoryScreen();

  @override
  _UserJobListHistoryScreenState createState() =>
      _UserJobListHistoryScreenState();
}

class _UserJobListHistoryScreenState extends State<UserJobListHistoryScreen> {
  List<Map<String, dynamic>> _jobCandidates = [];
  var _isInit = true;
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
        .getJobsAsCandidate(true)
        .then((value) {
      setState(() {
        _isLoading = false;
      });
    });
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
      arguments: [jobId, userId, 'history'],
    );
  }

  @override
  Future<void> didChangeDependencies() async {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });

      await Provider.of<Jobs>(context, listen: false)
          .fetchAndSetJobsByUserId(true);

      await Provider.of<Jobs>(context, listen: false)
          .getJobsAsCandidate(true)
          .then((value) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    var jobs = Provider.of<Jobs>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Theme.of(context).primaryColor),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: _isLoading == true
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(top: 20.0, bottom: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        margin: const EdgeInsets.only(
                          left: 25,
                          right: 25,
                          top: 10,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 20.0),
                          child: index == 0
                              ? _buildTitleText('Joburile tale')
                              : _buildTitleText('Rezervarile tale'),
                        ),
                      ),
                      jobs.userJobs.isEmpty && index == 0
                          ? _buildNoInfo('Niciun job găsit!', context)
                          : (jobs.jobsAsCandidate.isEmpty && index == 1
                              ? _buildNoInfo('Nicio rezervare găsită!', context)
                              : ListView.builder(
                                  itemBuilder: (ctx, i) => GestureDetector(
                                    onTap: () {
                                      index == 0
                                          ? Navigator.of(context).pushNamed(
                                              JobPlanScreen.routeName,
                                              arguments: [
                                                jobs.userJobs[i].id,
                                                'history'
                                              ],
                                            )
                                          : _goToPostedJobScreen(
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
                                                  index == 0
                                                      ? jobs.userJobs[i].title
                                                      : jobs.jobsAsCandidate[i]
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
                                                index == 0
                                                    ? Text(
                                                        jobs
                                                                        .userJobs[
                                                                            i]
                                                                        .dateTimeStart
                                                                        .day ==
                                                                    DateTime.now()
                                                                        .day &&
                                                                jobs
                                                                        .userJobs[
                                                                            i]
                                                                        .dateTimeStart
                                                                        .month ==
                                                                    DateTime.now()
                                                                        .month &&
                                                                jobs
                                                                        .userJobs[
                                                                            i]
                                                                        .dateTimeStart
                                                                        .year ==
                                                                    DateTime.now()
                                                                        .year
                                                            ? 'Azi,'
                                                            : '${jobs.userJobs[i].dateTimeStart.day.toString().padLeft(2, '0')}-'
                                                                '${jobs.userJobs[i].dateTimeStart.month.toString().padLeft(2, '0')}-'
                                                                '${jobs.userJobs[i].dateTimeStart.year.toString().padLeft(2, '0')},',
                                                        textAlign:
                                                            TextAlign.start,
                                                        style: TextStyle(
                                                            fontSize: 19,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w600),
                                                      )
                                                    : Text(
                                                        DateTime.tryParse(jobs.jobsAsCandidate[i]['start_date'])
                                                                        .day ==
                                                                    DateTime.now()
                                                                        .day &&
                                                                DateTime.tryParse(jobs.jobsAsCandidate[i]
                                                                            [
                                                                            'start_date'])
                                                                        .month ==
                                                                    DateTime.now()
                                                                        .month &&
                                                                DateTime.tryParse(jobs.jobsAsCandidate[i]
                                                                            [
                                                                            'start_date'])
                                                                        .year ==
                                                                    DateTime.now()
                                                                        .year
                                                            ? 'Azi,'
                                                            : '${DateTime.tryParse(jobs.jobsAsCandidate[i]['start_date']).day.toString().padLeft(2, '0')}-'
                                                                '${DateTime.tryParse(jobs.jobsAsCandidate[i]['start_date']).month.toString().padLeft(2, '0')}-'
                                                                '${DateTime.tryParse(jobs.jobsAsCandidate[i]['start_date']).year.toString().padLeft(2, '0')},',
                                                        textAlign:
                                                            TextAlign.start,
                                                        style: TextStyle(
                                                            fontSize: 19,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w600),
                                                      ),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                index == 0
                                                    ? Text(
                                                        '${jobs.userJobs[i].dateTimeStart.hour.toString().padLeft(2, '0')}:'
                                                        '${jobs.userJobs[i].dateTimeStart.minute.toString().padLeft(2, '0')}',
                                                        textAlign:
                                                            TextAlign.start,
                                                        style: TextStyle(
                                                            fontSize: 19,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w600),
                                                      )
                                                    : Text(
                                                        '${DateTime.tryParse(jobs.jobsAsCandidate[i]['start_date']).hour.toString().padLeft(2, '0')}:'
                                                        '${DateTime.tryParse(jobs.jobsAsCandidate[i]['start_date']).minute.toString().padLeft(2, '0')}',
                                                        textAlign:
                                                            TextAlign.start,
                                                        style: TextStyle(
                                                            fontSize: 19,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w600),
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
                                                  child: index == 0
                                                      ? Text(
                                                          '${jobs.userJobs[i].location.toString()}',
                                                          style: TextStyle(
                                                              fontSize: 17,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600),
                                                        )
                                                      : Text(
                                                          '${jobs.jobsAsCandidate[i]['location'].toString()}',
                                                          style: TextStyle(
                                                              fontSize: 17,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600),
                                                        ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  itemCount: index == 0
                                      ? jobs.userJobs.length
                                      : jobs.jobsAsCandidate.length,
                                  shrinkWrap: true,
                                  physics: ClampingScrollPhysics(),
                                )),
                    ],
                  ),
                );
              },
              itemCount: 2,
            ),
    );
  }
}

Widget _buildTitleText(String title) {
  return Text(
    title,
    textAlign: TextAlign.start,
    style: const TextStyle(
      fontSize: 30,
      fontWeight: FontWeight.bold,
    ),
  );
}

Widget _buildNoInfo(String title, BuildContext context) {
  final deviceSize = MediaQuery.of(context).size;
  return Container(
    margin: const EdgeInsets.only(
      left: 35,
      right: 25,
      top: 20,
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 20,
          ),
        ),
      ],
    ),
  );
}
