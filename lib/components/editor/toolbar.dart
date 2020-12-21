import 'package:flutter/material.dart';

import 'text_field.dart';

class Toolbar extends StatelessWidget {
  const Toolbar({Key key, this.onSelected, this.selectedType})
      : super(key: key);

  final SmartTextType selectedType;
  final ValueChanged<SmartTextType> onSelected;

  @override
  Widget build(BuildContext context) {
    var selectedColor = Theme.of(context).accentColor;

    return PreferredSize(
      preferredSize: Size.fromHeight(56),
      child: Material(
          elevation: 4.0,
          color: Theme.of(context).cardColor,
          child: Row(children: <Widget>[
            if (true)
              IconButton(
                  icon: Icon(Icons.format_size,
                      color: selectedType == SmartTextType.H1
                          ? selectedColor
                          : null),
                  onPressed: () => onSelected(SmartTextType.H1)),
            IconButton(
                icon: Icon(Icons.format_quote_outlined,
                    color: selectedType == SmartTextType.QUOTE
                        ? selectedColor
                        : null),
                onPressed: () => onSelected(SmartTextType.QUOTE)),
            IconButton(
                icon: Icon(Icons.format_list_bulleted,
                    color: selectedType == SmartTextType.BULLET
                        ? selectedColor
                        : null),
                onPressed: () => onSelected(SmartTextType.BULLET))
          ])),
    );
  }
}
