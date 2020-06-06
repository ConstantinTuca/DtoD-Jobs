import 'package:flutter/material.dart';

import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import '../../models/job.dart';
import 'job_workers_input_screen.dart';

class JobDetailsInputScreen extends StatefulWidget {
  static const routeName = '/job-details';

  @override
  _JobDetailsInputScreenState createState() => _JobDetailsInputScreenState();
}

class _JobDetailsInputScreenState extends State<JobDetailsInputScreen> {
  final _descriptionFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();

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
  );

  @override
  void dispose() {
    _descriptionFocusNode.dispose();
    super.dispose();
  }

  void _saveForm() {
    final isValid = _form.currentState.validate();
    if(!isValid) {
      return;
    }
    _form.currentState.save();

    Navigator.of(context).pushNamed(JobWorkersInputScreen.routeName, arguments: _editedJob);
  }

  @override
  Widget build(BuildContext context) {
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
                      bottom: 15,
                    ),
                    child: Text(
                      'Care este descrierea jobului pe care il oferi?',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                      bottom: 20,
                    ),
                    child: Text(
                      'Oferă o descriere cât mai detaliată a jobul pe care îl oferi. '
                      'Astfel îți vei crește șansele de a găsi un candidat potrivit.',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ),
                  Row(children: <Widget>[
                    Expanded(
                      child: new Container(
                          margin: const EdgeInsets.only(right: 20.0),
                          child: Divider(
                            color: Colors.black54,
                            height: 50,
                          )),
                    ),
                    Text("ofera descrierea"),
                    Expanded(
                      child: new Container(
                          margin: const EdgeInsets.only(left: 20.0),
                          child: Divider(
                            color: Colors.black54,
                            height: 50,
                          )),
                    ),
                  ]),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Profil',
                      labelStyle: TextStyle(
                        //fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontSize: 16,
                      ),
                      hintText: 'ex.: Hostess, Model, Promoter, Lacatus...',
                      alignLabelWithHint: true,
                    ),
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (_) {
                      FocusScope.of(context)
                          .requestFocus(_descriptionFocusNode);
                    },
                    validator: (value) {
                      FocusScope.of(context).requestFocus(FocusNode());
                      if(value.isEmpty) {
                        return 'Te rog completeaza cu profilul candidatului.';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _editedJob = Job(
                        id: null,
                        title: value,
                        description: _editedJob.description,
                        nrWorkers: _editedJob.nrWorkers,
                        genderWorkers: _editedJob.genderWorkers,
                        location: _editedJob.location,
                        detailsLocation: _editedJob.detailsLocation,
                        pricePerWorkerPerHour: _editedJob.pricePerWorkerPerHour,
                        dateTimeStart: _editedJob.dateTimeStart,
                        dateTimeFinish: _editedJob.dateTimeFinish,
                        duration: _editedJob.duration,
                      );
                    },
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      fillColor: Colors.black12,
                      labelText: 'Descriere',
                      labelStyle: TextStyle(
                        //fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontSize: 16,
                      ),
                      hintText:
                          'Lucrurile pe care trebuie sa le indeplineasca in cadrul jobului?\n\n'
                          'Ce fel de persoana trebuie sa fie? \n\n'
                          'Trebuie sa se descurce in relatii cu publicul? \n',
                      hintStyle: TextStyle(fontSize: 16),
                      alignLabelWithHint: true,
                    ),
                    maxLines: 8,
                    keyboardType: TextInputType.multiline,
                    focusNode: _descriptionFocusNode,
                    validator: (value) {
                      FocusScope.of(context).requestFocus(FocusNode());
                      if(value.isEmpty) {
                        return 'Te rog completeaza cu descrierea jobului.';
                      } else if(value.length < 20) {
                        return 'Descrierea trebuie sa contina cel putin 20 de caractere.';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _editedJob = Job(
                        id: null,
                        title: _editedJob.title,
                        description: value,
                        nrWorkers: _editedJob.nrWorkers,
                        genderWorkers: _editedJob.genderWorkers,
                        location: _editedJob.location,
                        detailsLocation: _editedJob.detailsLocation,
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
          //FocusScope.of(context).requestFocus(FocusNode());
          _saveForm();
        },
        label: Row(
          children: <Widget>[
            Text(
              'Înainte',
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
