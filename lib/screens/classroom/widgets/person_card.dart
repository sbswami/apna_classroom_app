import 'package:apna_classroom_app/components/images/person_image.dart';
import 'package:apna_classroom_app/internationalization/strings.dart';
import 'package:apna_classroom_app/util/c.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PersonCard extends StatelessWidget {
  final Map person;
  final bool isSelected;
  final Function onTap;
  final Function(bool value) onSelected;
  final Function({BuildContext context}) onLongPress;
  final bool isAdmin;

  const PersonCard(
      {Key key,
      this.person,
      this.onTap,
      this.isSelected,
      this.onSelected,
      this.onLongPress,
      this.isAdmin})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      onLongPress: () =>
          onLongPress != null ? onLongPress(context: context) : {},
      child: Container(
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
                onChanged: onSelected,
                checkColor: Theme.of(context).cardColor,
              ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
              child: PersonImage(
                thumbnailUrl: (person[C.MEDIA] ?? {})[C.THUMBNAIL_URL],
                size: 50,
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      person[C.NAME],
                      style: Theme.of(context).textTheme.subtitle2,
                    ),
                    if (isAdmin ?? false)
                      Text(
                        '(${S.ADMIN.tr})',
                        style: Theme.of(context)
                            .textTheme
                            .caption
                            .copyWith(color: Theme.of(context).primaryColor),
                      ),
                  ],
                ),
                SizedBox(height: 4.0),
                Text(
                  person[C.USERNAME],
                  style: Theme.of(context).textTheme.caption,
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
