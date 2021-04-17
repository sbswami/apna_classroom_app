import 'package:flutter/material.dart';

class InfoCard extends StatelessWidget {
  final data;
  final String title;
  final Widget child;

  const InfoCard({Key key, this.data, @required this.title, this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if ((data == null || data.toString().isEmpty) && child == null)
      return SizedBox.shrink();
    return Card(
      elevation: 4.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16.0, top: 8.0),
            child: Row(
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.caption,
                ),
              ],
            ),
          ),
          if (data != null)
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: SelectableText('$data'),
            ),
          if (child != null)
            Padding(
              padding: const EdgeInsets.only(left: 16.0, bottom: 8.0),
              child: child,
            ),
        ],
      ),
    );
  }
}
