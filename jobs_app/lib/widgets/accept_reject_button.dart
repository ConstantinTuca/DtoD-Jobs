import 'package:flutter/material.dart';

class AcceptRejectButton extends StatelessWidget {
  final Function _fun;
  final String _buttonText;
  final Color _buttonColor;
  final Color _textColor;

  AcceptRejectButton(this._fun, this._buttonText, this._buttonColor, this._textColor);

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Container(
      width: _buttonText != 'Oferă feedback' ? screenSize.width / 2.7 : screenSize.width / 1.1,
      margin: EdgeInsets.only(
        left: 7, right: 7,),
      child: RaisedButton(
        onPressed: _fun,
        color: _buttonColor,
        textColor: _textColor,
        padding: EdgeInsets.symmetric(
            vertical: 7, horizontal: 30),
        child: Text(
          _buttonText,
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w600,
          ),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: new BorderRadius.circular(18.0),
          side: BorderSide(
            color: Color(0xff075E54),
          ),
        ),
      ),
    );
  }
}
