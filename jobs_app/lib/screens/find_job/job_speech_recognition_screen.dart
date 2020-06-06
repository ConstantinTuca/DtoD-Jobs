import 'dart:async';

import 'package:flutter/material.dart';
import 'package:jobs_app/widgets/pick_location_button.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

import 'job_list_screen.dart';

class JobSpeechRecognitionScreen extends StatefulWidget {
  static const routeName = '/job-speech-recognition';

  @override
  JobSpeechRecognitionScreenState createState() =>
      JobSpeechRecognitionScreenState();
}

class JobSpeechRecognitionScreenState
    extends State<JobSpeechRecognitionScreen> {
  bool _hasSpeech = false;
  bool _stressTest = false;
  double level = 0.0;
  int _stressLoops = 0;
  String lastWords = "";
  String lastError = "";
  String lastStatus = "";
  String _currentLocaleId = "";
  List<LocaleName> _localeNames = [];
  final SpeechToText speech = SpeechToText();

  @override
  void initState() {
    initSpeechState();
    super.initState();
  }

  Future<void> initSpeechState() async {
    bool hasSpeech = await speech.initialize(
        onError: errorListener, onStatus: statusListener);
    if (hasSpeech) {
      _localeNames = await speech.locales();

      var systemLocale = await speech.systemLocale();
      _currentLocaleId = systemLocale.localeId;
    }

    if (!mounted) return;

    setState(() {
      _hasSpeech = hasSpeech;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
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
                  top: 5,
                ),
                child: Column(children: [
                  Container(
                    padding: EdgeInsets.only(
                      bottom: 15,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Căutare rapidă',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                      bottom: 20,
                    ),
                    child: Text(
                      //'Caută joburile din perioada cu locația cea mai apropiata de tine. \n'
                      'Apasa pe butonul cu microfon pentru a putea rosti numele orasului în care vei vrea sa lucrezi. ',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 4,
                    child: Column(
                      children: <Widget>[
                        Expanded(
                          child: Stack(
                            children: <Widget>[
                              Container(
                                  padding: EdgeInsets.only(bottom:40.0),
                                  alignment: Alignment.center,
                                  child: lastWords == "" ? null : Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Container(
                                        color: Colors.white,
                                        child: Center(
                                          child: Text(
                                            //"Cluj-Napoca",
                                            lastWords,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(fontSize: 27),
                                          ),
                                        ),
                                      ),
                                      Divider(
                                        height: 5,
                                        color: Theme.of(context).primaryColor,
                                        thickness: 0.7,
                                      ),
                                      PickLocationButton(_saveForm, 'ÎNCEPE CĂUTAREA'),
                                    ],
                                  )),
                              Positioned.fill(
                                bottom: 20,
                                child: Align(
                                  alignment: Alignment.bottomCenter,
                                  child: Container(
                                    width: 70,
                                    height: 70,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      boxShadow: [
                                        BoxShadow(
                                            blurRadius: .26,
                                            spreadRadius: level * 1.5,
                                            color:
                                                Colors.black.withOpacity(.05))
                                      ],
                                      color: Theme.of(context).primaryColor,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(50)),
                                    ),
                                    child: IconButton(
                                      icon: Icon(
                                        Icons.mic,
                                        color: speech.isListening
                                            ? Colors.white60
                                            : Colors.white,
                                      ),
                                      iconSize: 35,
                                      onPressed:
                                          !_hasSpeech || speech.isListening
                                              ? stopListening
                                              : startListening,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ]),
              ),
            )));
  }

  void _saveForm() {
    final now = DateTime.now();
    Navigator.of(context)
        .pushNamed(JobListScreen.routeName, arguments: {
      'locationName': lastWords,
      'chosenDate': DateTime.now(),
      'chosenStartHour': DateTime.now(),
      'chosenFinishHour': now.add(new Duration(days: 7)),
    });
  }

  void stressTest() {
    if (_stressTest) {
      return;
    }
    _stressLoops = 0;
    _stressTest = true;
    print("Starting stress test...");
    startListening();
  }

  void changeStatusForStress(String status) {
    if (!_stressTest) {
      return;
    }
    if (speech.isListening) {
      stopListening();
    } else {
      if (_stressLoops >= 100) {
        _stressTest = false;
        print("Stress test complete.");
        return;
      }
      print("Stress loop: $_stressLoops");
      ++_stressLoops;
      startListening();
    }
  }

  void startListening() {
    lastWords = "";
    lastError = "";
    speech.listen(
        onResult: resultListener,
        listenFor: Duration(seconds: 10),
        localeId: _currentLocaleId,
        onSoundLevelChange: soundLevelListener,
        cancelOnError: true,
        partialResults: true);
    setState(() {});
  }

  void stopListening() {
    speech.stop();
    setState(() {
      level = 0.0;
    });
  }

  void cancelListening() {
    speech.cancel();
    setState(() {
      level = 0.0;
    });
  }

  void resultListener(SpeechRecognitionResult result) {
    setState(() {
      lastWords = "${result.recognizedWords}";
    });
  }

  void soundLevelListener(double level) {
    setState(() {
      this.level = level;
    });
  }

  void errorListener(SpeechRecognitionError error) {
    setState(() {
      lastError = "${error.errorMsg} - ${error.permanent}";
    });
  }

  void statusListener(String status) {
    changeStatusForStress(status);
    setState(() {
      lastStatus = "$status";
    });
  }

  _switchLang(selectedVal) {
    setState(() {
      _currentLocaleId = selectedVal;
    });
    print(selectedVal);
  }
}
