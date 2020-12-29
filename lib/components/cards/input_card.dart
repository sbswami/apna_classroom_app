import 'package:flutter/material.dart';

class InputCard extends StatelessWidget {
  final Widget child;
  final String title;

  const InputCard({Key key, this.child, this.title}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16.0, top: 8.0),
            child: Row(
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.subtitle2,
                ),
              ],
            ),
          ),
          Divider(),
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0, left: 8.0, right: 8.0),
            child: child,
          ),
        ],
      ),
    );
  }
}
