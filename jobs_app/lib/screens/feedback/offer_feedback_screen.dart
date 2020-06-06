import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/jobs.dart';
import 'feedback_post_success_screen.dart';

class OfferFeedbackScreen extends StatefulWidget {
  static const routeName = '/offer-feedback';

  @override
  _OfferFeedbackScreenState createState() => _OfferFeedbackScreenState();
}

class _OfferFeedbackScreenState extends State<OfferFeedbackScreen> {
  final _descriptionFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();
  var feedback = '';
  int feedbackStars;

  String dropdownValue = 'Excelentă';

  List<String> _items = [
    'Excelentă',
    'Foarte bună',
    'Bună',
    'Rea',
    'Dezamăgitoare',
  ];

  void getFeedback() {
    if (dropdownValue == 'Excelentă') {
      feedbackStars = 5;
    }
    if (dropdownValue == 'Foarte bună') {
      feedbackStars = 4;
    }
    if (dropdownValue == 'Bună') {
      feedbackStars = 3;
    }
    if (dropdownValue == 'Rea') {
      feedbackStars = 2;
    }
    if (dropdownValue == 'Dezamăgitoare') {
      feedbackStars = 1;
    }
  }

  @override
  void dispose() {
    _descriptionFocusNode.dispose();
    super.dispose();
  }

  void _saveForm(String provideTo) {
    final isValid = _form.currentState.validate();
    if (!isValid) {
      return;
    }
    _form.currentState.save();
    getFeedback();

    Provider.of<Jobs>(context, listen: false)
        .addFeedback(provideTo, feedbackStars, feedback);

    Navigator.of(context).pushNamed(FeedbackPostSuccessScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    final resRoute = ModalRoute.of(context).settings.arguments as List<String>;
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
                      'Ofera o recenzie utilizatorului ${resRoute[2]}',
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
                      'Alege calitatea experienței și '
                      'oferă o recenzie detaliată utilizatorului ${resRoute[2]}. ',
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
                    Text(
                      "alege calitatea experienței",
                      style: TextStyle(color: Theme.of(context).primaryColor),
                    ),
                    Expanded(
                      child: new Container(
                          margin: const EdgeInsets.only(left: 20.0),
                          child: Divider(
                            color: Colors.black54,
                            height: 50,
                          )),
                    ),
                  ]),
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
                  Row(children: <Widget>[
                    Expanded(
                      child: new Container(
                          margin: const EdgeInsets.only(right: 20.0),
                          child: Divider(
                            color: Colors.black54,
                            height: 50,
                          )),
                    ),
                    Text("oferă recenzia",
                        style:
                            TextStyle(color: Theme.of(context).primaryColor)),
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
                      fillColor: Colors.black12,
                      labelText: 'Recenzie',
                      labelStyle: TextStyle(
                        //fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontSize: 16,
                      ),
                      hintText:
                          'Cum a fost experienta ta cu ${resRoute[2]}?\n\n',
                      hintStyle: TextStyle(fontSize: 16),
                      alignLabelWithHint: true,
                    ),
                    maxLines: 8,
                    keyboardType: TextInputType.multiline,
                    focusNode: _descriptionFocusNode,
                    validator: (value) {
                      FocusScope.of(context).requestFocus(FocusNode());
                      if (value.isEmpty) {
                        return 'Te rog completeaza cu recenzia utilizatorului.';
                      } else if (value.length < 10) {
                        return 'Recenzia trebuie sa contina cel putin 10 caractere.';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      feedback = value;
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
          _saveForm(resRoute[1]);
        },
        label: Row(
          children: <Widget>[
            Text(
              'Trimite ',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
            Icon(
              Icons.check,
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
