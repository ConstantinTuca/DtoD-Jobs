import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/jobs.dart';

class JobDeleteScreen extends StatelessWidget {
  static const routeName = '/job-delete';

  Future<void> _submit(BuildContext context, String jobId) async{

    try {
      await Provider.of<Jobs>(context, listen: false)
          .deleteJob(jobId);
    } catch (error) {
      print(error);
    }

    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    var jobId = ModalRoute.of(context).settings.arguments as String;
    Size screenSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0,
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
      ),
      body: Container(
        height: screenSize.height,
        padding: EdgeInsets.only(
          top: 20,
          left: 25,
          right: 25,
          bottom: 20,
        ),
        color: Theme.of(context).primaryColor,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/atention.png'),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Ești pe punctul de a-ți anula jobul. Acesta va fi șters și candidații nu vor mai putea lucra cu tine.',
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontSize: 31,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            Container(
              width: double.infinity,
              child: RaisedButton(
                onPressed: () {
                  _submit(context, jobId);
                },
                color: Colors.red[900],
                textColor: Color(0xff075E54),
                padding: EdgeInsets.symmetric(vertical: 16, horizontal: 30),
                child: Text(
                  'Anulează jobul',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(30.0),
                  side: BorderSide(
                    color: Colors.red[900],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
