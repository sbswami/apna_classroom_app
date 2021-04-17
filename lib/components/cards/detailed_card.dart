import 'package:apna_classroom_app/components/buttons/primary_button.dart';
import 'package:apna_classroom_app/internationalization/strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DetailedCard extends StatelessWidget {
  final String text;
  final Function onOkay;
  final List<Widget> buttons;

  const DetailedCard({Key key, this.text, this.onOkay, this.buttons})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: const EdgeInsets.all(16.0),
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          // border: Border.all(width: 1),
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 5,
            )
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              text,
              style: Theme.of(context).textTheme.headline5,
            ),
            SizedBox(height: 8.0),
            if (onOkay != null)
              PrimaryButton(
                text: S.OKAY.tr,
                onPress: onOkay,
              ),
            if (buttons != null)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: buttons,
              )
          ],
        ),
      ),
    );
  }
}
