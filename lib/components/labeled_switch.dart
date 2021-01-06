import 'package:flutter/material.dart';

class LabeledSwitch extends StatelessWidget {
  final String title;
  final String subtitle;
  final Function(bool selectd) onChanged;
  final bool value;

  const LabeledSwitch(
      {Key key, this.onChanged, this.value, this.title, this.subtitle})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      child: SwitchListTile(
        onChanged: onChanged,
        value: value,
        subtitle: subtitle != null ? Text(subtitle) : null,
        title: title != null
            ? Text(
                title,
                style: Theme.of(context).textTheme.bodyText2,
              )
            : null,
      ),
    );
  }
}
