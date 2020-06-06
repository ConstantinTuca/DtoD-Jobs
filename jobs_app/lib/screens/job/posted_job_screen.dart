import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../profile/public_profile_screen.dart';

import './job_candidate_success_screen.dart';
import '../../models/job.dart';
import '../../models/user.dart';
import '../../providers/jobs.dart';
import '../../providers/users.dart';
import '../../providers/auth.dart';
import '../../screens/feedback/offer_feedback_screen.dart';

class PostedJobScreen extends StatefulWidget {
  static const routeName = '/posted-job';

  @override
  _PostedJobScreenState createState() => _PostedJobScreenState();
}

class _PostedJobScreenState extends State<PostedJobScreen> {
  var _isLoading = false;
  var _isInit = true;
  Job job;
  User _jobUser;
  String _currentUserId;
  String find = '';
  String history = '';
  bool hasFeedback = true;
  Map<String, dynamic> _starlete = {};
  int k = 0;
  final globalKey = GlobalKey<ScaffoldState>();

  @override
  Future<void> didChangeDependencies() async {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      _currentUserId = Provider.of<Auth>(context, listen: false).userId;
      final resRoute =
          ModalRoute.of(context).settings.arguments as List<String>;

      if (resRoute.length == 3) {
        if(resRoute[2] == 'find') {
          find = 'find';
        }
        if(resRoute[2] == 'history') {
          history = 'history';
        }
      }

      await Provider.of<Jobs>(context, listen: false)
          .getJobByJobId(resRoute[0])
          .then((value) {
        setState(() {
          job = value;
          k++;
          if (k == 4) {
            _isLoading = false;
          }
        });
      });

      await Provider.of<Jobs>(context, listen: false)
          .hasFeedback(int.tryParse(resRoute[1]))
          .then((value) {
        setState(() {
          hasFeedback = value;
          k++;
          if (k == 4) {
            _isLoading = false;
          }
        });
      });

      await Provider.of<Users>(context, listen: false)
          .getUserByUserId(resRoute[1])
          .then((value) {
        setState(() {
          _jobUser = value;
          k++;
          if (k == 4) {
            _isLoading = false;
          }
        });
      });

      Provider.of<Jobs>(context, listen: false)
          .getFeedbackStars(int.tryParse(resRoute[1]))
          .then((value) {
        setState(() {
          k++;
          _starlete = value;
          if (k == 4) {
            _isLoading = false;
          }
        });
      });

    }
    _isInit = false;
    super.didChangeDependencies();
  }

  Future<void> _goToProfileScreen(BuildContext context) async {
    final resRoute =
    ModalRoute.of(context).settings.arguments as List<String>;

    await Navigator.of(context).pushNamed(
      PublicProfileScreen.routeName,
      arguments: resRoute[1],
    );
  }

  Future<void> _goToFeedbackScreen(BuildContext context, String giverId,
      String reciverId, String reciverName) async {
    await Navigator.of(context).pushNamed(
      OfferFeedbackScreen.routeName,
      arguments: [giverId, reciverId, reciverName],
    );
  }


  void _showErrorDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Container(
          width: 200,
          height: 200,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/atention.png'),
              fit: BoxFit.fill,
            ),
          ),
        ),
        backgroundColor: Theme.of(context).primaryColor,
        content: Text(
          'Nu poți să candidezi la un job cât timp ai un job oferit în derulare!',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        elevation: 10,
        shape: RoundedRectangleBorder(
          borderRadius: new BorderRadius.circular(10.0),
          side: BorderSide(
            color: Color(0xff075E54),
          ),
        ),
      ),
    );
  }

  void _saveForm(String jobId, String userId) async {
    setState(() {
      _isLoading = true;
    });
    Provider.of<Jobs>(context, listen: false).hasJobs().then((_) {
      if (mounted) {
        setState(() {
          var _hasJobs = Provider.of<Jobs>(context, listen: false).userHasJob;
          if (_hasJobs) {
            _showErrorDialog();
          } else {
            Provider.of<Jobs>(context, listen: false)
                .addJobCandidate(jobId);
            Navigator.of(context)
                .pushNamed(JobCandidateSuccessScreen.routeName);
          }
          _isLoading = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(
          color: Theme.of(context).primaryColor,
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
                    width: double.infinity,
                    padding: EdgeInsets.only(bottom: 20),
                    child: Column(
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              job.title,
                              style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontSize: 30,
                                  fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 40,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Icon(Icons.date_range),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              job.dateTimeStart.day == DateTime.now().day &&
                                      job.dateTimeStart.month ==
                                          DateTime.now().month &&
                                      job.dateTimeStart.year == DateTime.now().year
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
                            Icon(
                              Icons.location_on,
                              size: 28,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Container(
                              width: screenSize.width - 50 - 10 - 28,
                              child: Text(
                                '${job.location.toString()}',
                                style: TextStyle(
                                    fontSize: 17, fontWeight: FontWeight.w500),
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
                            Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: <Widget>[
                                Text(
                                  '${job.pricePerWorkerPerHour},00 LEI',
                                  style: TextStyle(
                                      color: Colors.black87,
                                      fontSize: 27,
                                      fontWeight: FontWeight.w600),
                                ),
                                Text(
                                  'pe oră',
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
                        SizedBox(
                          height: 20,
                        ),
                        Divider(
                          thickness: 1,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        GestureDetector(
                          onTap: () {
                            _goToProfileScreen(context);
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    '${_jobUser.firstName}',
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
                                        '${_starlete['media']}/5 - ${_starlete['length']} evaluări',
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
                                  Icon(
                                    Icons.navigate_next,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ],
                              ),
                            ],
                          ),
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
                        RichText(
                          textAlign: TextAlign.start,
                          text: TextSpan(
                            text: '',
                            style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                            ),
                            children: <TextSpan>[
                              TextSpan(
                                text: '  ${job.description}',
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black54,
                                  //letterSpacing: 1.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 50,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
      floatingActionButton: find != ''
          ? Container(
              width: 200,
              child: FloatingActionButton.extended(
                onPressed: () {
                  _saveForm(job.id, _currentUserId);
                },
                label: Container(
                  child: Text(
                    'Candidează',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ),
                backgroundColor: Theme.of(context).primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(10.0),
                  side: BorderSide(
                    color: Color(0xff075E54),
                  ),
                ),
              ),
            )
          : (history != '' && hasFeedback == false ? Container(
        margin: EdgeInsets.only(left: 35),
        width: double.infinity,
        child: FloatingActionButton.extended(
          onPressed: () {
            _goToFeedbackScreen(context, _currentUserId, _jobUser.id, _jobUser.firstName);
          },
          label: Container(
            child: Text(
              'Oferă feedback',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ),
          backgroundColor: Theme.of(context).primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(10.0),
            side: BorderSide(
              color: Color(0xff075E54),
            ),
          ),
        ),
      ) : Container(
        height: 0,
        width: 0,
      )),
    );
  }
}
