import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../navigation_screen.dart';

import '../../models/job.dart';

class JobPostSuccessScreen extends StatelessWidget {
  static const routeName = '/job-success';
  //Job _editedJob;

  @override
  Widget build(BuildContext context) {
    final _editedJob = ModalRoute.of(context).settings.arguments as Job;

    print(_editedJob.title);
    print(_editedJob.description);
    print(_editedJob.nrWorkers);
    print(_editedJob.genderWorkers);
    print(_editedJob.location);
    print(_editedJob.detailsLocation);
    print(_editedJob.pricePerWorkerPerHour);
    print(_editedJob.dateTimeStart.toString());
    print(_editedJob.dateTimeFinish.toString());
    print(_editedJob.duration);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          color: Colors.green,
        ),
        child: Container(
          margin: EdgeInsets.only(left: 35, right: 35, bottom: 30),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Icon(Icons.check_circle, color: Colors.white, size: 130,),
                Container(
                  child: Text(
                    'Jobul tău este online! \n'
                        'Acum, candidații pot aplica și lucra la jobul tău! \n',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 27,
                      fontWeight: FontWeight.bold,
                      wordSpacing: 1.2,
                      letterSpacing: 1.1,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Container(
                  child: RaisedButton(
                    onPressed: () {
                      Navigator.popUntil(context, ModalRoute.withName('/'));
                    },
                    color: Colors.white,
                    textColor: Color(0xff075E54),
                    padding: EdgeInsets.symmetric(vertical: 13, horizontal: 50),
                    child: Text(
                      'OK',
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(24.0),
                      side: BorderSide(
                        color: Color(0xff075E54),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
