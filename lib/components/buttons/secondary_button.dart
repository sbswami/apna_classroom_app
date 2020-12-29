import 'package:flutter/material.dart';

class SecondaryButton extends StatelessWidget {
  final Function onPress;
  final String text;
  final IconData iconData;

  const SecondaryButton({Key key, this.onPress, this.text, this.iconData})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      color: Theme.of(context).cardColor,
      onPressed: onPress,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (iconData != null)
            Icon(
              iconData,
              color: Theme.of(context).primaryColor,
            ),
          Text(
            text ?? '',
            style: Theme.of(context)
                .textTheme
                .button
                .copyWith(color: Theme.of(context).primaryColor),
          ),
        ],
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 4.0,
    );
  }
}
