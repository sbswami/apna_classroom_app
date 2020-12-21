import 'package:flutter/material.dart';

class WrapChips extends StatelessWidget {
  final Set<String> list;
  final Function(String value) onDeleted;

  const WrapChips({Key key, this.list, this.onDeleted}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Wrap(
      direction: Axis.horizontal,
      children: list
          .map<Widget>(
            (e) => Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Chip(
                label: Text(e),
                deleteIcon: Icon(
                  Icons.close,
                  size: 16,
                ),
                onDeleted: () => onDeleted(e),
              ),
            ),
          )
          .toList(),
    );
  }
}
