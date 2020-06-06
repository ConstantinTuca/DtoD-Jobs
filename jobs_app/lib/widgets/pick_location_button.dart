import 'package:flutter/material.dart';

class PickLocationButton extends StatelessWidget {
  final Function _fun;
  final String _buttonText;

  PickLocationButton(this._fun, this._buttonText);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 40, bottom: 30),
      width: double.infinity,
      child: RaisedButton(
        onPressed: () {
          _fun();
        },
        color: Colors.white,
        textColor: Color(0xff075E54),
        padding:
        EdgeInsets.only(top: 13, bottom: 13),
        child: Text(
          _buttonText,
          style: TextStyle(
            fontSize: 16,
          ),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: new BorderRadius.circular(5.0),
          side: BorderSide(
            color: Color(0xff075E54),
          ),
        ),
      ),
    );
  }
}
