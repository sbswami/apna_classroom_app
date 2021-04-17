import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  final Function onPress;
  final String text;
  final IconData iconData;
  final bool destructive;

  const PrimaryButton(
      {Key key, this.onPress, this.text, this.iconData, this.destructive})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    Color color = (destructive ?? false)
        ? Theme.of(context).errorColor
        : Theme.of(context).primaryColor;
    Color textColor = (destructive ?? false)
        ? Colors.white
        : Theme.of(context).textTheme.button.color;
    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(color),
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
          if (iconData != null)
            Icon(
              iconData,
              color: textColor,
            ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              text ?? '',
              style:
                  Theme.of(context).textTheme.button.copyWith(color: textColor),
            ),
          )
        ],
      ),
    );
  }
}
