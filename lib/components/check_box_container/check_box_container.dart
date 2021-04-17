import 'package:flutter/material.dart';

class CheckBoxContainer extends StatelessWidget {
  final bool isSelected;
  final Function(bool selected) onChanged;
  final Widget child;

  const CheckBoxContainer(
      {Key key, this.isSelected, this.onChanged, @required this.child})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (isSelected != null)
          Checkbox(
            value: isSelected,
            onChanged: onChanged,
            checkColor: Theme.of(context).cardColor,
          ),
        Expanded(child: child),
      ],
    );
  }
}
