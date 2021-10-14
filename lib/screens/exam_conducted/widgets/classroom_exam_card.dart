import 'package:apna_classroom_app/components/images/person_image.dart';
import 'package:apna_classroom_app/util/c.dart';
import 'package:flutter/material.dart';

class ClassroomExamCard extends StatelessWidget {
  final Map classroom;
  final Function onClose;

  const ClassroomExamCard({Key key, this.classroom, this.onClose})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        border: Border.symmetric(
          horizontal:
              BorderSide(width: 0.5, color: Theme.of(context).dividerColor),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        children: [
          PersonImage(
            stopPreview: true,
            url: (classroom[C.MEDIA] ?? {})[C.URL],
            size: 50,
          ),
          SizedBox(width: 8.0),
          Container(
            width: MediaQuery.of(context).size.width * 0.6,
            child: Text(
              classroom[C.TITLE],
              style: Theme.of(context).textTheme.subtitle2,
              maxLines: 1,
            ),
          ),
          if (onClose != null)
            Expanded(
              child: Align(
                alignment: Alignment.centerRight,
                child: IconButton(
                  icon: Icon(Icons.close),
                  onPressed: onClose,
                  color: Theme.of(context).errorColor,
                  iconSize: 18.0,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
