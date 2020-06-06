import 'package:flutter/material.dart';

class JobContainerEdit extends StatelessWidget {
  final Function _fun;
  final String _title;
  final String _description;
  final TextStyle _titleTextStyle;
  final TextStyle _contentTextStyle;
  final Icon _icon;

  JobContainerEdit(this._fun, this._title, this._description,
      this._titleTextStyle, this._contentTextStyle, this._icon);

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: () {
        _fun();
      },
      child: Container(
        padding: const EdgeInsets.only(left: 10, right: 10),
        width: screenSize.width - 70,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              _title,
              style: _titleTextStyle,
            ),
            SizedBox(
              height: 5,
            ),
            Row(
              children: <Widget>[
                _icon,
                SizedBox(
                  width: 10,
                ),
                Container(
                  width: screenSize.width - 105,
                  child: Text(
                    _description,
                    style: _contentTextStyle,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
