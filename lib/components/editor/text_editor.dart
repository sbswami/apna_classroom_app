import 'package:apna_classroom_app/internationalization/strings.dart';
import 'package:apna_classroom_app/util/c.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import 'state_management.dart';
import 'text_field.dart';
import 'toolbar.dart';

// https://github.com/neuencer/Flutter_Medium_Text_Editor
class TextEditor extends StatelessWidget {
  final data;

  const TextEditor({Key key, this.data}) : super(key: key);
  void _onDoneWithEditor(BuildContext context) {
    var data = Provider.of<EditorProvider>(context, listen: false).getString();
    if (data.first[C.DATA].length > 1) {
      Get.back(result: data);
    } else {
      Get.back();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<EditorProvider>(
        create: (context) => EditorProvider(data: data),
        builder: (context, child) {
          return Scaffold(
              appBar: AppBar(
                title: Text(S.EDITOR.tr),
                actions: [
                  IconButton(
                    icon: Icon(Icons.check),
                    onPressed: () => _onDoneWithEditor(context),
                  )
                ],
              ),
              body: Stack(
                children: <Widget>[
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    bottom: 56,
                    child: Consumer<EditorProvider>(
                      builder: (context, state, _) {
                        state.getString();
                        return ListView.builder(
                          itemCount: state.length,
                          itemBuilder: (context, index) {
                            return Focus(
                              onFocusChange: (hasFocus) {
                                if (hasFocus)
                                  state.setFocus(state.typeAt(index));
                              },
                              child: SmartTextField(
                                type: state.typeAt(index),
                                controller: state.textAt(index),
                                focusNode: state.nodeAt(index),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Selector<EditorProvider, SmartTextType>(
                      selector: (buildContext, state) => state.selectedType,
                      builder: (context, selectedType, _) {
                        return Toolbar(
                          selectedType: selectedType,
                          onSelected: Provider.of<EditorProvider>(context,
                                  listen: false)
                              .setType,
                        );
                      },
                    ),
                  )
                ],
              ));
        });
  }
}
