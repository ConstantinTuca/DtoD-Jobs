import 'package:flutter/material.dart';

class AuthButton extends StatelessWidget {
  final Function _fun;
  final String _buttonText;

  AuthButton(this._fun, this._buttonText);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: RaisedButton(
        onPressed: () {
          _fun();
        },
        color: Theme.of(context).primaryColor,
        textColor: Color(0xff075E54),
        padding:
        EdgeInsets.symmetric(vertical: 16, horizontal: 30),
        child: Text(
          _buttonText,
          style: TextStyle(
            fontSize: 14,
            color: Colors.white,
          ),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: new BorderRadius.circular(30.0),
          side: BorderSide(
            color: Color(0xff075E54),
          ),
        ),
      ),
    );
  }
}
