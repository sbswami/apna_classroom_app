import 'package:flutter/material.dart';

class MenuItem extends StatelessWidget {
  final String asset;
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
    this.asset,
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
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Row(
          children: <Widget>[
            if (iconData != null) Icon(iconData, color: color),
            if (asset != null)
              Container(
                child: Image.asset(asset),
                width: 24,
                height: 24,
              ),
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
      ),
    );
  }
}
