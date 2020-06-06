import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './your_post_screen.dart';
import './job_delete_screen.dart';

import './posted_job_screen.dart';
import '../../models/job.dart';
import '../../widgets/accept_reject_button.dart';
import '../../providers/jobs.dart';
import '../../screens/profile/public_profile_screen.dart';
import '../../screens/feedback/offer_feedback_screen.dart';

class JobPlanScreen extends StatefulWidget {
  static const routeName = '/job-plan';

  @override
  _JobPlanScreenState createState() => _JobPlanScreenState();
}

class _JobPlanScreenState extends State<JobPlanScreen> {
  Job recivedJob;
  var _isLoading = false;
  var _isInit = true;
  bool gasit = false;
  var history = '';
  Job job;
  Map<String, dynamic> _jobCandidates;

  Future<void> _goToYourPost(BuildContext context, String jobId) async {
    var navigationResult = await Navigator.of(context).pushNamed(
      YourPostScreen.routeName,
      arguments: jobId,
    );

    if (navigationResult != null) {
      recivedJob = navigationResult;
      //print(recivedJob.title);
    }
  }

  Future<void> _goToProfileScreen(BuildContext context, String userId) async {
    await Navigator.of(context).pushNamed(
      PublicProfileScreen.routeName,
      arguments: userId,
    );
  }

  Future<void> _goToFeedbackScreen(BuildContext context, String giverId,
      String reciverId, String reciverName) async {
    await Navigator.of(context).pushNamed(
      OfferFeedbackScreen.routeName,
      arguments: [giverId, reciverId, reciverName],
    );
  }

  Future<void> _goToDeleteScreen(BuildContext context, String jobId) async {
    var navigationResult = await Navigator.of(context).pushNamed(
      JobDeleteScreen.routeName,
      arguments: jobId,
    );
  }

  Future<void> _goToPostedJobScreen(
      BuildContext context, String jobId, String userId) async {
    var navigationResult = await Navigator.of(context).pushNamed(
      PostedJobScreen.routeName,
      arguments: [jobId, userId],
    );
  }

  Future<void> _accept(
    int idRow,
    String idJob,
    String idUser,
  ) async {
    setState(() {
      _isInit = true;
      _isLoading = true;
    });

    await Provider.of<Jobs>(context, listen: false)
        .acceptCandidature(idJob, idUser, idRow);
    await didChangeDependencies();
  }

  Future<void> _reject(int idRow) async {
    setState(() {
      _isInit = true;
      _isLoading = true;
    });

    await Provider.of<Jobs>(context, listen: false).rejectCandidature(idRow);
    await didChangeDependencies();
  }

  @override
  Future<void> didChangeDependencies() async {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      final resRoute =
          ModalRoute.of(context).settings.arguments as List<String>;
      if (resRoute.length == 2) {
        history = 'history';
      }
      await Provider.of<Jobs>(context, listen: false)
          .getJobByJobId(resRoute[0])
          .then((value) {
        setState(() {
          job = value;
        });
      });

      if(history != 'history') {
        await Provider.of<Jobs>(context, listen: false)
            .getJobUsers(resRoute[0])
            .then((value) {
          setState(() {
            _jobCandidates = value;
            _isLoading = false;
            gasit = false;
          });
        });
      } else {
        await Provider.of<Jobs>(context, listen: false)
            .getJobUsers(resRoute[0], true)
            .then((value) {
          setState(() {
            _jobCandidates = value;
            _isLoading = false;
            gasit = false;
          });
        });
      }

      print(_jobCandidates);
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  bool hasNoCandidates() {
    if (history == 'history') {
      for (var _currentValue in _jobCandidates.values) {
        if (_currentValue['accepted'] == true) {
          return false;
        }
      }
    } else {
      for (var _currentValue in _jobCandidates.values) {
        if (_currentValue['accepted'] == true ||
            _currentValue['accepted'] == false) {
          return false;
        }
      }
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    if (recivedJob != null) {
      job = recivedJob;
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(
          color: Theme.of(context).primaryColor,
        ),
      ),
      body: _isLoading == true
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
                      'Planul jobului',
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
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.only(top: 20, bottom: 20),
                    child: Column(
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              job.title,
                              style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontSize: 23,
                                  fontWeight: FontWeight.w600),
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
                              job.dateTimeStart.day == DateTime.now().day &&
                                      job.dateTimeStart.month ==
                                          DateTime.now().month &&
                                      job.dateTimeStart.year ==
                                          DateTime.now().year
                                  ? 'Azi,'
                                  : '${job.dateTimeStart.day.toString().padLeft(2, '0')}-'
                                      '${job.dateTimeStart.month.toString().padLeft(2, '0')}-'
                                      '${job.dateTimeStart.year.toString().padLeft(2, '0')},',
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  fontSize: 19, fontWeight: FontWeight.w500),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              '${job.dateTimeStart.hour.toString().padLeft(2, '0')}:'
                              '${job.dateTimeStart.minute.toString().padLeft(2, '0')} - '
                              '${job.dateTimeFinish.hour.toString().padLeft(2, '0')}:'
                              '${job.dateTimeFinish.minute.toString().padLeft(2, '0')}',
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  fontSize: 19, fontWeight: FontWeight.w500),
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
                                '${job.location.toString()}',
                                style: TextStyle(
                                    fontSize: 17, fontWeight: FontWeight.w500),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Divider(
                    thickness: 1,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  for (var _currentValue in _jobCandidates.values)
                    if (_currentValue['accepted'] == false && history == '')
                      GestureDetector(
                        onTap: () {
                          _goToProfileScreen(context, _currentValue['user'].id);
                        },
                        child: Container(
                          margin: EdgeInsets.only(
                            bottom: 15,
                          ),
                          child: Column(
                            children: <Widget>[
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        '${_currentValue['user'].firstName}',
                                        style: TextStyle(
                                            color: Colors.black87,
                                            fontSize: 19.0,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      SizedBox(
                                        height: 3,
                                      ),
                                      Row(
                                        children: <Widget>[
                                          Text(
                                            '${_currentValue['starlete']['media']}/5 - ${_currentValue['starlete']['length']} evaluări',
                                            style: TextStyle(
                                              color: Colors.black54,
                                              fontSize: 17.0,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: <Widget>[
                                      CircleAvatar(
                                        backgroundImage: AssetImage(
                                            'assets/images/profil.jpeg'),
                                        radius: 26,
                                      ),
                                      SizedBox(
                                        width: 6,
                                      ),
                                      Icon(
                                        Icons.navigate_next,
                                        color: Theme.of(context).primaryColor,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  AcceptRejectButton(
                                    () => _reject(_currentValue['idRow']),
                                    'Respinge',
                                    Colors.white,
                                    Theme.of(context).primaryColor,
                                  ),
                                  AcceptRejectButton(
                                    () => _accept(
                                      _currentValue['idRow'],
                                      job.id,
                                      _currentValue['user'].id,
                                    ),
                                    'Acceptă',
                                    Theme.of(context).primaryColor,
                                    Colors.white,
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      )
                    else if (_currentValue['accepted'] == true && history == '')
                      GestureDetector(
                        onTap: () {
                          _goToProfileScreen(context, _currentValue['user'].id);
                        },
                        child: Container(
                          margin: EdgeInsets.only(
                            bottom: 20,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    '${_currentValue['user'].firstName}',
                                    style: TextStyle(
                                        color: Colors.black87,
                                        fontSize: 19.0,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  SizedBox(
                                    height: 3,
                                  ),
                                  Row(
                                    children: <Widget>[
                                      Text(
                                        '${_currentValue['starlete']['media']}/5 - ${_currentValue['starlete']['length']} evaluări',
                                        style: TextStyle(
                                          color: Colors.black54,
                                          fontSize: 17.0,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Row(
                                children: <Widget>[
                                  CircleAvatar(
                                    backgroundImage:
                                        AssetImage('assets/images/profil.jpeg'),
                                    radius: 26,
                                  ),
                                  SizedBox(
                                    width: 6,
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.block),
                                    color: Colors.red,
                                    onPressed: () =>
                                        _reject(_currentValue['idRow']),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      )
                    else if (history == 'history' &&
                        _currentValue['accepted'] == true)
                      GestureDetector(
                        onTap: () {
                          _goToProfileScreen(context, _currentValue['user'].id);
                        },
                        child: Container(
                          margin: EdgeInsets.only(
                            bottom: 15,
                          ),
                          child: Column(
                            children: <Widget>[
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        '${_currentValue['user'].firstName}',
                                        style: TextStyle(
                                            color: Colors.black87,
                                            fontSize: 19.0,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      SizedBox(
                                        height: 3,
                                      ),
                                      Row(
                                        children: <Widget>[
                                          Text(
                                            '${_currentValue['starlete']['media']}/5 - ${_currentValue['starlete']['length']} evaluări',
                                            style: TextStyle(
                                              color: Colors.black54,
                                              fontSize: 17.0,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: <Widget>[
                                      CircleAvatar(
                                        backgroundImage: AssetImage(
                                            'assets/images/profil.jpeg'),
                                        radius: 26,
                                      ),
                                      SizedBox(
                                        width: 6,
                                      ),
                                      Icon(
                                        Icons.navigate_next,
                                        color: Theme.of(context).primaryColor,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              _currentValue['hasFeedback'] == false
                                  ? SizedBox(
                                      height: 20,
                                    )
                                  : SizedBox(
                                      height: 0,
                                    ),
                              _currentValue['hasFeedback'] == false
                                  ? AcceptRejectButton(
                                      () => _goToFeedbackScreen(
                                          context,
                                          job.userId,
                                          _currentValue['user'].id,
                                          _currentValue['user'].firstName),
                                      'Oferă feedback',
                                      Theme.of(context).primaryColor,
                                      Colors.white,
                                    )
                                  : SizedBox(
                                      height: 0,
                                    ),
                            ],
                          ),
                        ),
                      ),
                  hasNoCandidates() == true
                      ? Text(
                          'Nicio persoană care a candidat la acest job.',
                          style: TextStyle(
                              color: Colors.black38,
                              fontWeight: FontWeight.w500,
                              fontSize: 17),
                        )
                      : Container(
                          height: 0,
                          width: 0,
                        ),
                  SizedBox(
                    height: 20,
                  ),
                  Divider(
                    thickness: 1,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  GestureDetector(
                    onTap: () {
                      _goToPostedJobScreen(context, job.id, job.userId);
                    },
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.only(
                        top: 15,
                        bottom: 15,
                      ),
                      color: Colors.white,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Consultă-ți jobul online',
                            style: TextStyle(
                                fontSize: 19,
                                color: Theme.of(context).primaryColor,
                                fontWeight: FontWeight.w500),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            '19 vizualizări',
                            style: TextStyle(
                                fontSize: 15,
                                color: Colors.black54,
                                fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  history == 'history'
                      ? Container()
                      : GestureDetector(
                          onTap: () {
                            _goToYourPost(context, job.id);
                          },
                          child: Container(
                            width: double.infinity,
                            padding: EdgeInsets.only(
                              top: 15,
                              bottom: 15,
                            ),
                            color: Colors.white,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  'Postarea ta',
                                  style: TextStyle(
                                      fontSize: 19,
                                      color: Theme.of(context).primaryColor,
                                      fontWeight: FontWeight.w500),
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
                  history == 'history'
                      ? Container()
                      : SizedBox(
                          height: 10,
                        ),
                  history == 'history'
                      ? Container()
                      : GestureDetector(
                          onTap: () {
                            _goToDeleteScreen(context, job.id);
                          },
                          child: Container(
                            width: double.infinity,
                            padding: EdgeInsets.only(
                              top: 15,
                              bottom: 15,
                            ),
                            color: Colors.white,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  'Anulează jobul',
                                  style: TextStyle(
                                      fontSize: 19,
                                      color: Colors.red,
                                      fontWeight: FontWeight.w500),
                                ),
                                Icon(
                                  Icons.delete,
                                  size: 25,
                                  color: Colors.red,
                                ),
                              ],
                            ),
                          ),
                        )
                ],
              ),
            ),
    );
  }
}
