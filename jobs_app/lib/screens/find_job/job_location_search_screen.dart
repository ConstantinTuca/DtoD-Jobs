import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:geocoder/geocoder.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:jobs_app/screens/find_job/job_speech_recognition_screen.dart';
import 'package:place_picker/place_picker.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

import '../../models/job.dart';
import '../../widgets/pick_location_button.dart';
import '../../widgets/quick_search_button.dart';
import 'job_date_search_screen.dart';
import '../../widgets/divider.dart';

const kGoogleApiKey = "AIzaSyAvrYl4DUu8wmzERYaBKTd5ZP9MnV5ixQw";

GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: kGoogleApiKey);

class JobLocationSearchScreen extends StatefulWidget {
  static const routeName = '/job-location-search';

  @override
  _JobLocationSearchScreenState createState() =>
      _JobLocationSearchScreenState();
}

class _JobLocationSearchScreenState extends State<JobLocationSearchScreen> {
  final _descriptionFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();
  var _locationName = '';
  var _isVisible = false;

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

    setState(() {
      _locationName = result.formattedAddress;
      _isVisible = true;
    });
  }

  void quickSearch() {
    Navigator.of(context).pushNamed(JobSpeechRecognitionScreen.routeName);
  }

  void _saveForm() {
    Navigator.of(context)
        .pushNamed(JobDateSearchScreen.routeName, arguments: _locationName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Theme.of(context).primaryColor),
          onPressed: () => Navigator.of(context).pop(),
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
                      'În ce oraș vrei să lucrezi?',
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
                      'Caută joburi cu locația cea mai apropiata de tine. ',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ),
                  if (_locationName == '')
                    QuickSearchButton(quickSearch, 'CĂUTARE RAPIDĂ'),
                  if (_locationName == '') DividerWidget('sau', 1),
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
      ),
    );
  }
}
