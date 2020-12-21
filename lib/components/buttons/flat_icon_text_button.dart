import 'package:flutter/material.dart';

class FlatIconTextButton extends StatelessWidget {
  final Function onPressed;
  final IconData iconData;
  final String text;
  final String note;

  const FlatIconTextButton(
      {Key key, this.onPressed, this.iconData, this.text, this.note})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        RaisedButton(
          padding: const EdgeInsets.all(12.0),
          shape: RoundedRectangleBorder(
              // side: BorderSide(width: 1, color: Theme.of(context).primaryColor),
              borderRadius: BorderRadius.circular(10)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                iconData,
                color: Theme.of(context).primaryColor,
              ),
              SizedBox(height: 8),
              Text(
                text,
                style: Theme.of(context)
                    .textTheme
                    .button
                    .copyWith(color: Theme.of(context).primaryColor),
              )
            ],
          ),
          color: Theme.of(context).cardColor,
          onPressed: onPressed,
        ),
        SizedBox(height: 4),
        if (note != null)
          Text(
            note,
            style: Theme.of(context).textTheme.caption,
          )
      ],
    );
  }
}
