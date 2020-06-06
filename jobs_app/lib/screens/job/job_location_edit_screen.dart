import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:geocoder/geocoder.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:place_picker/place_picker.dart';
import 'package:provider/provider.dart';

import '../../models/job.dart';
import '../../providers/jobs.dart';
import '../../widgets/pick_location_button.dart';

const kGoogleApiKey = "AIzaSyAvrYl4DUu8wmzERYaBKTd5ZP9MnV5ixQw";

GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: kGoogleApiKey);

class JobLocationEditScreen extends StatefulWidget {
  static const routeName = '/job-location-edit';

  @override
  _JobLocationEditScreenState createState() => _JobLocationEditScreenState();
}

class _JobLocationEditScreenState extends State<JobLocationEditScreen> {
  final _form = GlobalKey<FormState>();
  var _locationName = '';
  var _isVisible = false;
  var _isLoading = false;
  var _isInit = true;

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
  void didChangeDependencies() {
    if (_locationName != '') {
      setState(() {
        _isVisible = true;
      });
    }
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      final job =
      ModalRoute.of(context).settings.arguments as Job;
      setState(() {
        _locationName = job.location;
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  void showPlacePicker() async {
    //ModalRoute.of(context).settings.arguments as Job;
    LocationResult result = await Navigator.of(context).push(MaterialPageRoute(
        builder: (context) =>
            PlacePicker("AIzaSyAvrYl4DUu8wmzERYaBKTd5ZP9MnV5ixQw",)));

    // Handle the result in your way
    //_locationName = result.formattedAddress;
    setState(() {
      _locationName = result.formattedAddress;
      _isVisible = true;
    });
//    print(result.formattedAddress);
//    print(result.name);
  }

  Future<void> _saveForm(Job job) async{

      _editedJob = Job(
        id: job.id,
        title: job.title,
        description: job.description,
        nrWorkers: job.nrWorkers,
        genderWorkers: job.genderWorkers,
        location: _locationName,
        detailsLocation: job.detailsLocation,
        pricePerWorkerPerHour: job.pricePerWorkerPerHour,
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
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final job = ModalRoute.of(context).settings.arguments as Job;

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
                      'Unde se va desfășura jobul?',
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
                      'Oferă locația unde va fi jobul împreună cu o descriere a locului. ',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ),
                  if (_locationName != '')
                    Column(children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(
                          top: 30,
                        ),
                        width: double.infinity,
                        child: Center(
                          child: Text(
                            _locationName,
                            textAlign: TextAlign.center,
                            style:
                                TextStyle(color: Colors.black87, fontSize: 20),
                          ),
                        ),
                      ),
                      new Padding(
                          padding: EdgeInsets.all(8.0),
                          child: new Divider(
                            height: 5,
                            color: Theme.of(context).primaryColor,
                            thickness: 0.7,
                          )),
                    ]),
                  if (_locationName == '')
                    PickLocationButton(showPlacePicker, 'ALEGE LOCAȚIA'),
                  if (_locationName != '')
                    PickLocationButton(showPlacePicker, 'SCHIMBĂ LOCAȚIA'),
                ],
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: Visibility(
        visible: _isVisible,
        child: FloatingActionButton.extended(
          onPressed: () {
            //FocusScope.of(context).requestFocus(FocusNode());
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
      ),
    );
  }
}
