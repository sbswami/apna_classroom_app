import 'package:flutter/material.dart';

class RadioGroup extends StatefulWidget {
  final Map<String, String> list;
  final Function(String) onChange;
  final String defaultValue;
  final EdgeInsetsGeometry margin;
  final bool fixed;
  final String errorMessage;

  const RadioGroup(
      {Key key,
      this.list,
      this.onChange,
      this.defaultValue,
      this.margin,
      this.fixed,
      this.errorMessage})
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
    return Padding(
      padding: widget.margin ?? const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              ...widget.list.entries.map((e) => Row(
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
                  )),
            ],
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
      ),
    );
  }
}
