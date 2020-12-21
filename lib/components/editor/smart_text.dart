import 'package:apna_classroom_app/components/editor/text_field.dart';
import 'package:flutter/material.dart';

class SmartText extends StatelessWidget {
  final String textType;
  final String text;

  const SmartText({Key key, this.textType, this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SmartTextType smartTextType = getSmartTextTypeFromString(textType);
    return TextFormField(
      initialValue: text,
      style: smartTextType.textStyle,
      textAlign: smartTextType.align,
      keyboardType: TextInputType.multiline,
      maxLines: null,
      decoration: InputDecoration(
        border: InputBorder.none,
        prefixText: smartTextType.prefix,
        prefixStyle: smartTextType.textStyle,
        isDense: true,
        contentPadding: smartTextType.padding,
      ),
      readOnly: true,
    );
  }
}
