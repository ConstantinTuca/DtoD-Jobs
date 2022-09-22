import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/jobs.dart';
import '../../widgets/divider.dart';
import '../../models/job.dart';


class JobWorkersEditScreen extends StatefulWidget {
  static const routeName = '/job-workers-edit';

  @override
  _JobWorkersEditScreenState createState() => _JobWorkersEditScreenState();
}

class _JobWorkersEditScreenState extends State<JobWorkersEditScreen> {
  Job _editedJob;
  int _nrWorkers = 1;
  int _cash = 12;
  int _genderWorker;
  String dropdownValue = 'Fete si băieți';
  var _isLoading = false;
  var _isInit = true;

  List<String> _items = [
    'Fete si băieți',
    'Doar fete',
    'Doar băieți',
  ];

  void getGenderWorker() {
    if(dropdownValue == 'Fete si băieți') {
      _genderWorker = 0;
    }
    if(dropdownValue == 'Doar fete') {
      _genderWorker = 1;
    }
    if(dropdownValue == 'Doar băieți') {
      _genderWorker = 2;
    }
  }

  String returnTypeOfWorker(int genderWorker) {
    switch (genderWorker) {
      case 0:
        return 'Fete si băieți';
      case 1:
        return 'Doar fete';
      case 2:
        return 'Doar băieți';
      default:
        return 'Fete si băieți';
    }
  }

  void add() {
    setState(() {
      _nrWorkers++;
    });
  }

  void minus() {
    setState(() {
      if (_nrWorkers != 1) _nrWorkers--;
    });
  }

  void addPayment() {
    setState(() {
      _cash++;
    });
  }

  void minusPayment() {
    setState(() {
      if (_cash != 1) _cash--;
    });
  }

  @override
  Future<void> didChangeDependencies() async {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      final job =
      ModalRoute.of(context).settings.arguments as Job;
      setState(() {
        _nrWorkers = job.nrWorkers;
        _cash = job.pricePerWorkerPerHour;
        _genderWorker = job.genderWorkers;
        dropdownValue = returnTypeOfWorker(_genderWorker);
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  Future<void> _saveForm(Job job) async{
    getGenderWorker();

      _editedJob = Job(
        id: job.id,
        title: job.title,
        description: job.description,
        nrWorkers: _nrWorkers,
        genderWorkers: _genderWorker,
        location: job.location,
        locationLatitude: job.locationLatitude,
        locationLongitude: job.locationLongitude,
        detailsLocation: job.detailsLocation,
        pricePerWorkerPerHour: _cash,
        dateTimeStart: job.dateTimeStart,
        dateTimeFinish: job.dateTimeFinish,
        duration: job.duration,
        userId: job.userId,
      );

    try {
      await Provider.of<Jobs>(context, listen: false)
          .updateJob(_editedJob.id, _editedJob);
    } catch (error) {
      print(error);
    }

    Navigator.of(context).pop('updated');
  }

  @override
  Widget build(BuildContext context) {
    final job =
    ModalRoute.of(context).settings.arguments as Job;

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
            //key: _form,
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(
                      bottom: 15,
                    ),
                    child: Text(
                      'Care este numarul de oameni de care ai nevoie?',
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
                      'Verifică de câți oameni ai nevoie pentru acest job '
                      'pentru a duce taskurile la bun sfârșit în timp util. ',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ),
                  DividerWidget('alege numarul'),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        'Număr de persoane',
                        style: TextStyle(fontSize: 20),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                            height: 33.0,
                            width: 33.0,
                            margin: EdgeInsets.only(right: 18),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Theme.of(context).primaryColor,
                                width: 1.5,
                              ),
                              shape: BoxShape.circle,
                            ),
                            child: FittedBox(
                              child: FloatingActionButton(
                                heroTag: 'btn1',
                                onPressed: minus,
                                elevation: 0,
                                child: Icon(
                                  const IconData(0xe15b,
                                      fontFamily: 'MaterialIcons'),
                                  color: Theme.of(context).primaryColor,
                                  size: 30,
                                ),
                                backgroundColor: Colors.white,
                                splashColor: Colors.black38,
                              ),
                            ),
                          ),
                          Text('$_nrWorkers', style: new TextStyle(fontSize: 20.0)),
                          Container(
                            height: 33.0,
                            width: 33.0,
                            margin: EdgeInsets.only(left: 18),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Theme.of(context).primaryColor,
                                width: 1.5,
                              ),
                              shape: BoxShape.circle,
                            ),
                            child: FittedBox(
                              child: FloatingActionButton(
                                heroTag: 'btn2',
                                onPressed: add,
                                elevation: 0,
                                child: Icon(
                                  Icons.add,
                                  color: Theme.of(context).primaryColor,
                                  size: 30,
                                ),
                                backgroundColor: Colors.white,
                                splashColor: Colors.black38,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  DividerWidget('alege tipul'),
                  Container(
                    width: double.infinity,
                    child: DropdownButton<String>(
                      value: dropdownValue,
                      icon: Icon(
                        Icons.arrow_drop_down,
                        color: Theme.of(context).primaryColor,
                      ),
                      iconSize: 24,
                      elevation: 16,
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: 20,
                      ),
                      isExpanded: true,
                      underline: Container(
                        height: 0,
                      ),
                      onChanged: (String newValue) {
                        setState(() {
                          dropdownValue = newValue;
                        });
                      },
                      items:
                          _items.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ),
                  DividerWidget('alege plata'),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        'Plata pe oră',
                        style: TextStyle(fontSize: 20),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                            height: 33.0,
                            width: 33.0,
                            margin: EdgeInsets.only(right: 18),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Theme.of(context).primaryColor,
                                width: 1.5,
                              ),
                              shape: BoxShape.circle,
                            ),
                            child: FittedBox(
                              child: FloatingActionButton(
                                heroTag: 'btn3',
                                onPressed: minusPayment,
                                elevation: 0,
                                child: Icon(
                                  const IconData(0xe15b,
                                      fontFamily: 'MaterialIcons'),
                                  color: Theme.of(context).primaryColor,
                                  size: 30,
                                ),
                                backgroundColor: Colors.white,
                                splashColor: Colors.black38,
                              ),
                            ),
                          ),
                          if (_cash > 1)  Text('$_cash lei/h', style: new TextStyle(fontSize: 20.0)),
                          if (_cash == 1 ) Text('$_cash leu/h', style: new TextStyle(fontSize: 20.0)),
                          Container(
                            height: 33.0,
                            width: 33.0,
                            margin: EdgeInsets.only(left: 18),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Theme.of(context).primaryColor,
                                width: 1.5,
                              ),
                              shape: BoxShape.circle,
                            ),
                            child: FittedBox(
                              child: FloatingActionButton(
                                heroTag: 'btn4',
                                onPressed: addPayment,
                                elevation: 0,
                                child: Icon(
                                  Icons.add,
                                  color: Theme.of(context).primaryColor,
                                  size: 30,
                                ),
                                backgroundColor: Colors.white,
                                splashColor: Colors.black38,
                              ),
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
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          _saveForm(job);
        },
        label: Row(
          children: <Widget>[
            Text(
              'Salvează',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
            SizedBox(width: 10,),
            Icon(
              Icons.check,
              color: Colors.white,
              size: 25,
            ),
          ],
        ),
        backgroundColor: Theme.of(context).primaryColor,
        shape: RoundedRectangleBorder(),
      ),
    );
  }
}
