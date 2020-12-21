import 'package:flutter/material.dart';

class WrapActionChips extends StatelessWidget {
  final Set<String> list;
  final Function(String value) onAction;
  final IconData actionIcon;

  const WrapActionChips({Key key, this.list, this.onAction, this.actionIcon})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: list
          .map<Widget>(
            (e) => Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: ActionChip(
                label: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      actionIcon,
                      size: 16,
                      color: Theme.of(context).primaryColor,
                    ),
                    SizedBox(width: 5),
                    Text(e)
                  ],
                ),
                onPressed: () => onAction(e),
              ),
            ),
          )
          .toList(),
    );
  }
}
