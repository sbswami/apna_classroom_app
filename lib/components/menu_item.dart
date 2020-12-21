import 'package:flutter/material.dart';

class MenuItem extends StatelessWidget {
  final IconData iconData;
  final String text;
  final Function onTap;

  const MenuItem({
    Key key,
    this.iconData,
    this.text,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Row(
        children: <Widget>[
          if (iconData != null) Icon(iconData),
          SizedBox(width: 20.0),
          Container(
            constraints: BoxConstraints(maxWidth: 130),
            child: Text(text),
          )
        ],
      ),
    );
  }
}
