import 'package:apna_classroom_app/components/editor/smart_text.dart';
import 'package:apna_classroom_app/util/c.dart';
import 'package:flutter/material.dart';

class TextViewer extends StatelessWidget {
  final text;

  const TextViewer({Key key, this.text}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(text[C.TITLE]),
      ),
      body: ListView.builder(
        itemCount: text[C.TEXT].length,
        itemBuilder: (BuildContext context, int position) {
          var _text = text[C.TEXT][position];
          return SmartText(
            text: _text[C.DATA],
            textType: _text[C.DATA_TYPE],
          );
        },
      ),
    );
  }
}
