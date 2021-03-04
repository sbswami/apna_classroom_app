import 'package:flutter/material.dart';

class BottomNavButton extends StatelessWidget {
  final IconData iconData;
  final String text;
  final bool selected;
  final Function onTap;

  const BottomNavButton(
      {Key key, this.iconData, this.text, this.selected, this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      // width: 70,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                iconData,
                size: 28,
                color:
                    (selected ?? false) ? Theme.of(context).primaryColor : null,
              ),
              Text(
                text ?? '',
                style: (selected ?? false)
                    ? TextStyle(color: Theme.of(context).primaryColor)
                    : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
