import 'package:flutter/material.dart';

class ArrowSecondaryButton extends StatelessWidget {
  final Function onPress;
  final String text;
  final IconData preIcon;
  final IconData postIcon;

  const ArrowSecondaryButton(
      {Key key, this.onPress, this.text, this.preIcon, this.postIcon})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(Theme.of(context).cardColor),
        shape: MaterialStateProperty.all<OutlinedBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
      ),
      onPressed: onPress,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (preIcon != null)
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Icon(
                  preIcon,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            Text(
              text ?? '',
              style: Theme.of(context)
                  .textTheme
                  .button
                  .copyWith(color: Theme.of(context).primaryColor),
            ),
            Expanded(
              child: Align(
                child: Icon(
                  postIcon ?? Icons.arrow_forward_ios_rounded,
                  color: Theme.of(context).primaryColor,
                ),
                alignment: Alignment.centerRight,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
