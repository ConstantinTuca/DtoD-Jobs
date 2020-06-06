import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:geocoder/geocoder.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:place_picker/place_picker.dart';

import '../../models/job.dart';
import '../../widgets/pick_location_button.dart';
import 'job_date_input_screen.dart';

const kGoogleApiKey = "AIzaSyAvrYl4DUu8wmzERYaBKTd5ZP9MnV5ixQw";

GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: kGoogleApiKey);

class JobLocationInputScreen extends StatefulWidget {
  static const routeName = '/job-location';

  @override
  _JobLocationInputScreenState createState() => _JobLocationInputScreenState();
}

class _JobLocationInputScreenState extends State<JobLocationInputScreen> {
  final _descriptionFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();
  var _locationName = '';
  var _isVisible = false;

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
    super.didChangeDependencies();
  }

  void showPlacePicker() async {
    LocationResult result = await Navigator.of(context).push(MaterialPageRoute(
        builder: (context) =>
            PlacePicker("AIzaSyAvrYl4DUu8wmzERYaBKTd5ZP9MnV5ixQw")));

    // Handle the result in your way
    //_locationName = result.formattedAddress;
    setState(() {
      _locationName = result.formattedAddress;
      _isVisible = true;
    });
    print(result.latLng);
    print(result.name);
  }

  void _saveForm(Job job) {

      _editedJob = Job(
        id: null,
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
      );

    Navigator.of(context).pushNamed(JobDateInputScreen.routeName, arguments: _editedJob);
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
      ),
    );
  }
}
