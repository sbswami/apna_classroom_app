import 'package:apna_classroom_app/analytics/analytics_constants.dart';
import 'package:apna_classroom_app/analytics/analytics_manager.dart';
import 'package:apna_classroom_app/api/storage/storage_api_constants.dart';
import 'package:apna_classroom_app/components/images/UrlImage.dart';
import 'package:apna_classroom_app/internationalization/strings.dart';
import 'package:apna_classroom_app/screens/classroom/classroom_details.dart';
import 'package:apna_classroom_app/util/c.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ClassroomMessageCard extends StatelessWidget {
  final classroomMessage;

  const ClassroomMessageCard({Key key, this.classroomMessage})
      : super(key: key);

  _onTap() async {
    await Get.to(ClassroomDetails(classroom: classroomMessage));
    // Set Chat screen back
    trackScreen(ScreenNames.Chat);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Stack(
          children: [
            Column(
              children: [
                Container(
                  height: MediaQuery.of(context).size.width * 0.5,
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: UrlImage(
                    url: (classroomMessage[C.MEDIA] ?? {})[C.URL],
                    fileName: FileName.THUMBNAIL,
                    fit: BoxFit.cover,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    classroomMessage[C.TITLE],
                    style: Theme.of(context).textTheme.headline5,
                    textAlign: TextAlign.center,
                  ),
                )
              ],
            ),
            Positioned(
              right: 10,
              top: 10,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(color: Theme.of(context).cardColor),
                  child: Icon(
                    getPrivacy(classroomMessage[C.PRIVACY]),
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
