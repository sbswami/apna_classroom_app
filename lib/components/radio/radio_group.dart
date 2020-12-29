import 'package:flutter/material.dart';

class RadioGroup extends StatefulWidget {
  final Map<String, String> list;
  final Function(String value) onChange;
  final String defaultValue;
  final bool fixed;
  final String errorMessage;
  final bool isVertical;

  const RadioGroup(
      {Key key,
      this.list,
      this.onChange,
      this.defaultValue,
      this.fixed,
      this.errorMessage,
      this.isVertical})
      : super(key: key);

  @override
  _RadioGroupState createState() => _RadioGroupState();
}

class _RadioGroupState extends State<RadioGroup> {
  var groupValue;

  _onChange(value) {
    if (widget.fixed != null && widget.fixed) {
      return;
    }
    widget.onChange(value);
    setState(() {
      groupValue = value;
    });
  }

  @override
  void initState() {
    groupValue = widget.defaultValue;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        if (!(widget.isVertical ?? false))
          Row(
            children: getRadioList(),
          ),
        if (widget.isVertical ?? false)
          Column(
            children: getRadioList(),
          ),
        widget.errorMessage != null
            ? Text(
                widget.errorMessage ?? '',
                style: TextStyle(
                  color: Theme.of(context).errorColor,
                ),
              )
            : SizedBox(),
      ],
    );
  }

  List<Widget> getRadioList() {
    return widget.list.entries
        .map((e) => Row(
              children: <Widget>[
                Radio(
                  onChanged: _onChange,
                  value: e.key,
                  groupValue: groupValue,
                ),
                GestureDetector(
                  child: Text(e.value),
                  onTap: () => _onChange(e.key),
                ),
              ],
            ))
        .toList();
  }
}
