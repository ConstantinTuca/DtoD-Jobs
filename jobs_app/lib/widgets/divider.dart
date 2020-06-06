import 'package:flutter/material.dart';

class DividerWidget extends StatelessWidget {
  final String text;
  final int color;

  DividerWidget(this.text, [this.color = 0]);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: new Container(
              margin: const EdgeInsets.only(right: 20.0),
              child: Divider(
                color: Colors.black54,
                height: 50,
              )),
        ),
        if(this.color == 1)
          Text(text, style: TextStyle(color: Colors.black54),)
        else
          Text(text),
        Expanded(
          child: new Container(
              margin: const EdgeInsets.only(left: 20.0),
              child: Divider(
                color: Colors.black54,
                height: 50,
              )),
        ),
      ],
    );
  }
}
