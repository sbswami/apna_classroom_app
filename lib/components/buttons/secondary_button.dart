import 'package:flutter/material.dart';

class SecondaryButton extends StatelessWidget {
  final Function onPress;
  final String text;
  final IconData iconData;
  final bool destructive;

  const SecondaryButton(
      {Key key, this.onPress, this.text, this.iconData, this.destructive})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color color = (destructive ?? false)
        ? Theme.of(context).errorColor
        : Theme.of(context).primaryColor;
    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(Theme.of(context).cardColor),
        shape: MaterialStateProperty.all<OutlinedBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
      ),
      onPressed: onPress,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (iconData != null) Icon(iconData, color: color),
          if (text != null)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                text,
                style:
                    Theme.of(context).textTheme.button.copyWith(color: color),
              ),
            ),
        ],
      ),
    );
  }
}
