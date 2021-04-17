import 'package:apna_classroom_app/util/date_time.dart';
import 'package:flutter/material.dart';

class MessageSentTime extends StatelessWidget {
  final String createdAt;
  final AlignmentGeometry alignmentGeometry;

  const MessageSentTime({Key key, this.createdAt, this.alignmentGeometry})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: alignmentGeometry ?? Alignment.bottomLeft,
      padding: const EdgeInsets.only(
        bottom: 4,
        top: 16,
        left: 8,
        right: 8,
      ),
      // margin: const EdgeInsets.only(top: 16),
      decoration: BoxDecoration(
          color: Theme.of(context).dividerColor,
          borderRadius: BorderRadius.circular(8)),
      child: Text(
        getFormattedDateTime(dateString: createdAt),
        style: Theme.of(context).textTheme.caption,
      ),
    );
  }
}
