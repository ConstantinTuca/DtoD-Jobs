import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../../models/job.dart';
import 'job_post_success_screen.dart';
import '../../providers/jobs.dart';
import '../../providers/auth.dart';

class JobObservationsInputScreen extends StatefulWidget {
  static const routeName = '/job-observations';

  @override
  _JobObservationsInputScreenState createState() =>
      _JobObservationsInputScreenState();
}

class _JobObservationsInputScreenState
    extends State<JobObservationsInputScreen> {
  final _form = GlobalKey<FormState>();
  String _userId;

  var _editedJob = Job(
    id: null,
    title: '',
    description: '',
    nrWorkers: 0,
    genderWorkers: 0,
    location: '',
    detailsLocation: '',
    pricePerWorkerPerHour: 0,
    dateTimeStart: null,
    dateTimeFinish: null,
    duration: 0.0,
    userId: '',
  );

  @override
  void dispose() {
    super.dispose();
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
          'Nu poți să oferi un job cât timp ai o candidatură în derulare!',
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

  void _saveForm(Job job) {
    //print(job.detailsLocation);

    Provider.of<Jobs>(context, listen: false).hasJobs().then((_) {
      if (mounted) {
        setState(() {
          var _hasJobs = Provider.of<Jobs>(context, listen: false).userHasJobAsCandidate;
          if (_hasJobs) {
            _showErrorDialog();
          } else {
            _userId = Provider.of<Auth>(context, listen: false).userId;

            _editedJob = job;

            Provider.of<Jobs>(context, listen: false).addJob(
                job.title,
                job.description,
                job.nrWorkers,
                job.genderWorkers,
                job.location,
                job.detailsLocation,
                job.pricePerWorkerPerHour,
                job.dateTimeStart,
                job.dateTimeFinish
            );

            Navigator.of(context)
                .pushNamed(JobPostSuccessScreen.routeName, arguments: _editedJob);
          }
        });
      }
    });

  }

  @override
  Widget build(BuildContext context) {
    _editedJob = ModalRoute.of(context).settings.arguments as Job;

    //FlutterStatusbarcolor.setStatusBarColor(Colors.white);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(
          color: Theme.of(context).primaryColor,
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        height: MediaQuery.of(context).size.height * 0.9,
        child: Container(
          margin: const EdgeInsets.only(
            left: 20,
            right: 20,
            top: 10,
          ),
          child: Form(
            key: _form,
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(
                      bottom: 45,
                    ),
                    child: Text(
                      'Ai ceva de adăugat privind acest job?',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
//                  Container(
//                    margin: EdgeInsets.only(
//                      bottom: 45,
//                    ),
//                    child: Text(
//                      'Dacă mai ai de adăugat observații, aici le poți oferi. ',
//                      style: TextStyle(
//                        fontSize: 16,
//                      ),
//                    ),
//                  ),

                  TextFormField(
                    decoration: InputDecoration(
                      fillColor: Colors.black12,
                      labelText: 'Observații',
                      labelStyle: TextStyle(
                        //fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontSize: 16,
                      ),
                      hintText: '\nAlte observații în privința jobului?\n\n'
                          'Persoanele trebuie sa ajungă cu 10 minute mai repede de inceperea jobului? \n\n'
                          'Ce fel de ținută va trebui sa poarte candidatul la job? \n',
                      hintStyle: TextStyle(fontSize: 16),
                      alignLabelWithHint: true,
                    ),
                    maxLines: 8,
                    keyboardType: TextInputType.multiline,
                    onSaved: (value) {
                      _editedJob = Job(
                        id: null,
                        title: _editedJob.title,
                        description: _editedJob.description,
                        nrWorkers: _editedJob.nrWorkers,
                        genderWorkers: _editedJob.genderWorkers,
                        location: _editedJob.location,
                        detailsLocation: value,
                        pricePerWorkerPerHour: _editedJob.pricePerWorkerPerHour,
                        dateTimeStart: _editedJob.dateTimeStart,
                        dateTimeFinish: _editedJob.dateTimeFinish,
                        duration: _editedJob.duration,
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          FocusScope.of(context).requestFocus(FocusNode());
          _saveForm(_editedJob);
        },
        label: Row(
          children: <Widget>[
            Text(
              'Postează',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
            Icon(
              Icons.navigate_next,
              color: Colors.white,
            ),
          ],
        ),
        backgroundColor: Theme.of(context).primaryColor,
        shape: RoundedRectangleBorder(),
      ),
    );
  }
}
