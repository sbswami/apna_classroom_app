import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  final Function onPress;
  final String text;
  final IconData iconData;

  const PrimaryButton({Key key, this.onPress, this.text, this.iconData})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      onPressed: onPress,
      color: Theme.of(context).primaryColor,
      elevation: 4.0,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (iconData != null)
            Icon(
              iconData,
              color: Theme.of(context).textTheme.button.color,
            ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              text ?? '',
              style: Theme.of(context).textTheme.button,
            ),
          )
        ],
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    );
  }
}
