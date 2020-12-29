import 'package:flutter/material.dart';

class LabeledCheckBox extends StatelessWidget {
  final bool checked;
  final Function(bool isChecked) onChanged;
  final String text;

  const LabeledCheckBox({Key key, this.checked, this.onChanged, this.text})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(value: checked, onChanged: onChanged),
        GestureDetector(child: Text(text), onTap: () => onChanged(!checked)),
      ],
    );
  }
}
