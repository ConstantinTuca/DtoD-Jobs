import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:jobs_app/screens/user_job_list_screen.dart';
import 'package:provider/provider.dart';
import 'package:bordered_text/bordered_text.dart';

import 'user_job_list_history_screen.dart';
import 'offer_job/job_details_input_screen.dart';
import 'find_job/job_location_search_screen.dart';
import '../providers/jobs.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = '/jobs';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var _isInit = true;
  var _isLoading = false;
  var _hasJobs = false;
  var _hasJobsAsCandidate = false;

  Future<void> _goToHistoryJobsScreen(BuildContext context) async {
    var navigationResult = await Navigator.of(context).pushNamed(
      UserJobListHistoryScreen.routeName,
    ).then((value) {
      setState(() {
        _isInit = true;
        _isLoading = false;
      });
    });
  }

  void offerJob(BuildContext context) {
    Navigator.of(context).pushNamed(JobDetailsInputScreen.routeName).then((value) {
      setState(() {
        _isInit = true;
        _isLoading = false;
      });
    });
  }

  void findJob(BuildContext context) {
    Navigator.of(context).pushNamed(JobLocationSearchScreen.routeName).then((value) {
      setState(() {
        _isInit = true;
        _isLoading = false;
      });
    });
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<Jobs>(context, listen: false).hasJobs().then((_) {
        //print(value);
        if (mounted) {
          setState(() {
            _hasJobs = Provider.of<Jobs>(context, listen: false).userHasJob;
            _hasJobsAsCandidate =
                Provider.of<Jobs>(context, listen: false).userHasJobAsCandidate;
            _isLoading = false;
          });
        }
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? Center(
            child: CircularProgressIndicator(),
          )
        : Scaffold(
            appBar: _hasJobs || _hasJobsAsCandidate
                ? null
                : AppBar(
                    //centerTitle: true,
                    title: InkWell(
                      onTap: () {
                        _goToHistoryJobsScreen(context);
                      },
                      child: Text(
                        'Istoricul joburilor',
                        style: TextStyle(
                          fontSize: 19,
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    backgroundColor: Colors.white,
                    elevation: 1,
                    actions: <Widget>[
                      IconButton(
                        icon: Icon(
                          Icons.navigate_next,
                          color: Theme.of(context).primaryColor,
                          size: 30,
                        ),
                        //onPressed: _saveForm,
                      ),
                    ],
                  ),
            body: _hasJobs || _hasJobsAsCandidate
                ? UserJobListScreen(this._hasJobs, this._hasJobsAsCandidate)
                : Stack(
                    children: <Widget>[
                      Container(
                        height: double.infinity,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('assets/images/main_image_2.jpg'),
                            fit: BoxFit.cover,
                          ),
                        ),
                        child: ClipRRect(
                          // make sure we apply clip it properly
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
                            child: Container(
                              alignment: Alignment.center,
                              color: Colors.grey.withOpacity(0.1),
                            ),
                          ),
                        ),
                      ),
                      SafeArea(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
//                Container(
//                  width: double.infinity,
//                  padding: EdgeInsets.only(
//                    right: 40,
//                    left: 40,
//                    bottom: 80,
//                  ),
//                  child: BorderedText(
//                    strokeWidth: 8.0,
//                    strokeColor: Theme.of(context).primaryColor,
//                    child: Text(
//                      "TucAnu",
//                      style: TextStyle(
//                        fontSize: 60,
//                        fontWeight: FontWeight.bold,
//                        color: Colors.white,
//                        letterSpacing: 5.0,
//                      ),
//                      textAlign: TextAlign.center,
//                    ),
//                  ),
//                ),
                            Container(
                              width: double.infinity,
                              padding: EdgeInsets.only(
                                right: 40,
                                left: 40,
                                bottom: 40,
                              ),
                              child: BorderedText(
                                strokeWidth: 2.0,
                                strokeColor: Theme.of(context).primaryColor,
                                child: Text(
                                  "Începe să cauți și să oferi joburi!",
                                  style: TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                            Container(
                              width: double.infinity,
                              margin: EdgeInsets.all(15),
                              child: RaisedButton(
                                onPressed: () => offerJob(context),
                                textColor: Colors.white,
                                color: Theme.of(context).primaryColor,
                                padding: EdgeInsets.symmetric(
                                    vertical: 13, horizontal: 30),
                                child: Text(
                                  'OFERĂ UN JOB',
                                  style: TextStyle(
                                    fontSize: 17,
                                  ),
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: new BorderRadius.circular(18.0),
                                  side: BorderSide(
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              width: double.infinity,
                              margin: EdgeInsets.only(
                                  left: 15, right: 15, bottom: 30),
                              child: RaisedButton(
                                onPressed: () => findJob(context),
                                color: Colors.white,
                                textColor: Color(0xff075E54),
                                padding: EdgeInsets.symmetric(
                                    vertical: 13, horizontal: 30),
                                child: Text(
                                  'GĂSEȘTE UN JOB',
                                  style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: new BorderRadius.circular(18.0),
                                  side: BorderSide(
                                    color: Color(0xff075E54),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
          );
  }
}
