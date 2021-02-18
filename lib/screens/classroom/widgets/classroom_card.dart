import 'package:apna_classroom_app/components/images/person_image.dart';
import 'package:apna_classroom_app/internationalization/strings.dart';
import 'package:apna_classroom_app/screens/classroom/classroom_details.dart';
import 'package:apna_classroom_app/util/c.dart';
import 'package:apna_classroom_app/util/constants.dart';
import 'package:apna_classroom_app/util/date_time.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ClassroomCard extends StatelessWidget {
  final Map classroom;
  final Function(bool _public) onTitleTap;

  final bool isPublic;

  final bool isSelected;
  final Function(bool selected) onChanged;
  final Function({BuildContext context}) onLongPress;

  const ClassroomCard(
      {Key key,
      this.classroom,
      this.onTitleTap,
      this.isSelected,
      this.onChanged,
      this.onLongPress,
      this.isPublic})
      : super(key: key);

  onIconTap() {
    if (isPublic ?? false) {
      return onTitleTap(isPublic);
    }
    Get.to(ClassroomDetails(classroom: classroom));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        border: Border.symmetric(
          horizontal:
              BorderSide(width: 0.5, color: Theme.of(context).dividerColor),
        ),
      ),
      child: Row(
        children: [
          if (isSelected != null)
            Checkbox(value: isSelected, onChanged: onChanged),
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: onIconTap,
            onLongPress: onLongPress,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
              child: PersonImage(
                thumbnailUrl: classroom[C.THUMBNAIL_URL],
                size: 50,
              ),
            ),
          ),
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => onTitleTap(isPublic),
            onLongPress: onLongPress,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  classroom[C.TITLE],
                  style: Theme.of(context).textTheme.subtitle2,
                ),
                SizedBox(height: 4.0),
                if (isPublic ?? false)
                  Text(
                    S.JOIN.tr,
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                if (!(isPublic ?? false))
                  Text(
                    getSubtitleText(classroom[C.MESSAGE]),
                    style: Theme.of(context).textTheme.caption,
                    maxLines: 1,
                  )
              ],
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  getUpdateTime(dateString: classroom[C.UPDATED_AT]),
                  style: Theme.of(context).textTheme.caption,
                ),
                SizedBox(height: 10),
                Icon(
                  getPrivacy(classroom[C.PRIVACY]),
                  color: Theme.of(context).primaryColor,
                  size: 18,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

String getSubtitleText(Map message) {
  if (message == null) return '--';
  switch (message[C.TYPE]) {
    case E.MESSAGE:
      String messageText = message[C.MESSAGE].toString();
      int msgLength = messageText.length;
      if (msgLength > 25) return messageText.substring(0, 25) + '...';
      return messageText;
    case E.NOTE:
      return '';
  }
  return '--';
}
