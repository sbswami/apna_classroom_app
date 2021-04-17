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
  final Function() onTitleTap;
  final Function onIconClick;

  final bool isPublic;

  final bool isSelected;
  final Function(bool selected) onChanged;
  final Function({BuildContext context}) onLongPress;

  final Function onRefresh;

  const ClassroomCard(
      {Key key,
      this.classroom,
      this.onTitleTap,
      this.isSelected,
      this.onChanged,
      this.onLongPress,
      this.isPublic,
      this.onIconClick,
      this.onRefresh})
      : super(key: key);

  onIconTap() async {
    if (onIconClick != null) return onIconClick();
    if (isPublic ?? false) {
      return onTitleTap();
    }
    var result = await Get.to(ClassroomDetails(classroom: classroom));
    if ((result ?? false) && onRefresh != null) onRefresh();
  }

  @override
  Widget build(BuildContext context) {
    bool unseen = (classroom[C.UNSEEN] ?? 0) > 0;

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
            Checkbox(
              value: isSelected,
              onChanged: onChanged,
              checkColor: Theme.of(context).cardColor,
            ),
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: onIconTap,
            onLongPress: onLongPress,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
              child: PersonImage(
                thumbnailUrl: (classroom[C.MEDIA] ?? {})[C.THUMBNAIL_URL],
                size: 50,
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => onTitleTap(),
              onLongPress: onLongPress,
              child: Row(
                children: [
                  Column(
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
                        Row(
                          children: [
                            if (unseen)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 1.0,
                                  horizontal: 4.0,
                                ),
                                margin: const EdgeInsets.only(right: 8.0),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).primaryColor,
                                  borderRadius: BorderRadius.circular(4.0),
                                ),
                                child: Text(
                                  '${classroom[C.UNSEEN]}',
                                  style: Theme.of(context)
                                      .textTheme
                                      .button
                                      .copyWith(fontSize: 11),
                                ),
                              ),
                            Text(
                              getSubtitleText(classroom[C.MESSAGE]),
                              style: getMessageTextStyle(unseen, context),
                              maxLines: 1,
                            ),
                          ],
                        )
                    ],
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
            ),
          ),
        ],
      ),
    );
  }
}

String getSubtitleText(Map message) {
  if (message == null) return '—';
  switch (message[C.TYPE]) {
    case E.MESSAGE:
      String messageText = (message[C.MESSAGE] ?? '—').toString();
      int msgLength = messageText.length;
      if (msgLength > 25) return messageText.substring(0, 25) + '...';
      return messageText;
    case E.NOTE:
      return '📚 Notes';
    case E.MEDIA:
      return '🏞 Media';
    case E.EXAM_CONDUCTED:
      return '🔔 Exam scheduled';
    case E.CLASSROOM:
      return '👩‍🏫 Classroom';
  }
  return '—';
}

getMessageTextStyle(bool unseen, BuildContext context) {
  if (unseen) {
    return TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w600,
      color: Theme.of(context).accentColor,
    );
  }
  return Theme.of(context).textTheme.caption;
}
