import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BottomNavButton extends StatelessWidget {
  final IconData iconData;
  final String text;
  final bool selected;
  final Function onTap;

  const BottomNavButton(
      {Key key, this.iconData, this.text, this.selected, this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color color = (selected ?? false)
        ? Theme.of(context).primaryColor
        : Get.isDarkMode
            ? Colors.grey
            : null;
    return SizedBox(
      // width: 70,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                iconData,
                size: 28,
                color: color,
              ),
              Text(
                text ?? '',
                style: TextStyle(color: color),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
