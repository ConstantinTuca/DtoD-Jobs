import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class JobCandidateSuccessScreen extends StatelessWidget {
  static const routeName = '/job-success-candidate';

  @override
  Widget build(BuildContext context) {

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
                Icon(Icons.send, color: Colors.white, size: 130,),
                Container(
                  child: Text(
                    'Candidatura a fost trimisă! \n'
                        'Acum, anagajatorul va trebui să-ți accepte cererea! \n',
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
                      Navigator.of(context).popUntil((route) => route.isFirst);
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
