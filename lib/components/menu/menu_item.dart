import 'package:flutter/material.dart';

class MenuItem extends StatelessWidget {
  final IconData iconData;
  final String text;
  final Function onTap;
  final bool isSelected;

  const MenuItem({
    Key key,
    this.iconData,
    this.text,
    this.onTap,
    this.isSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color color;
    if (isSelected ?? false) {
      color = Theme.of(context).primaryColor;
    }
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Row(
        children: <Widget>[
          if (iconData != null) Icon(iconData, color: color),
          SizedBox(width: 20.0),
          Container(
            constraints: BoxConstraints(maxWidth: 130),
            child: Text(
              text,
              style: TextStyle(color: color),
            ),
          )
        ],
      ),
    );
  }
}
