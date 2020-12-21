import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class OtpInput extends StatelessWidget {
  FocusNode focusNode1 = FocusNode();
  FocusNode focusNode2 = FocusNode();
  FocusNode focusNode3 = FocusNode();
  FocusNode focusNode4 = FocusNode();
  FocusNode focusNode5 = FocusNode();
  FocusNode focusNode6 = FocusNode();

  final otp;

  OtpInput({Key key, this.otp}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Row(
        children: [
          OtpTextField(
            focusNode: focusNode1,
            nextFocusNode: focusNode2,
            onValueChange: (value) => otp[0] = value,
          ),
          OtpTextField(
            focusNode: focusNode2,
            nextFocusNode: focusNode3,
            onValueChange: (value) => otp[1] = value,
          ),
          OtpTextField(
            focusNode: focusNode3,
            nextFocusNode: focusNode4,
            onValueChange: (value) => otp[2] = value,
          ),
          OtpTextField(
            focusNode: focusNode4,
            nextFocusNode: focusNode5,
            onValueChange: (value) => otp[3] = value,
          ),
          OtpTextField(
            focusNode: focusNode5,
            nextFocusNode: focusNode6,
            onValueChange: (value) => otp[4] = value,
          ),
          OtpTextField(
            focusNode: focusNode6,
            onValueChange: (value) => otp[5] = value,
          ),
        ],
      ),
    );
  }
}

class OtpTextField extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();

  final FocusNode focusNode;
  final FocusNode nextFocusNode;
  final Function onValueChange;

  OtpTextField(
      {Key key, this.focusNode, this.nextFocusNode, this.onValueChange})
      : super(key: key);

  onChangeText(String value) {
    onValueChange(value);
    if (value.length > 0) {
      if (nextFocusNode == null) {
        return focusNode.unfocus();
      }
      nextFocusNode.requestFocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextFormField(
          onChanged: onChangeText,
          controller: _controller,
          textAlign: TextAlign.center,
          focusNode: focusNode,
          style: TextStyle(
            fontSize: 24,
          ),
          inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter(new RegExp('^([0-9])'), allow: true)
          ],
          keyboardType: TextInputType.number,
        ),
      ),
    );
  }
}
