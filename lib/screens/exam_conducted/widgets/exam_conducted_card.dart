import 'package:apna_classroom_app/internationalization/strings.dart';
import 'package:apna_classroom_app/screens/quiz/exam/detailed_exam.dart';
import 'package:apna_classroom_app/util/c.dart';
import 'package:apna_classroom_app/util/date_time.dart';
import 'package:apna_classroom_app/util/helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ExamConductedCard extends StatelessWidget {
  final Map examConducted;
  final List buttons;

  const ExamConductedCard({Key key, this.examConducted, this.buttons})
      : super(key: key);

  onTap() {
    if (isCreator(examConducted[C.CREATED_BY]))
      Get.to(
        () => DetailedExam(
          examConducted: examConducted,
        ),
      );
  }

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
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: onTap,
            child: Column(
              children: [
                Text(
                  examConducted[C.EXAM][C.TITLE],
                  maxLines: 1,
                  style: Theme.of(context).textTheme.subtitle2,
                ),
                SizedBox(height: 4.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      getMinuteSt(examConducted[C.EXAM][C.SOLVING_TIME]),
                      style: Theme.of(context).textTheme.caption,
                    ),
                    Text(
                      '${S.MARKS.tr} ${examConducted[C.EXAM][C.MARKS]}',
                      style: Theme.of(context).textTheme.caption,
                    ),
                    Text(
                      getDifficulty(examConducted[C.EXAM][C.DIFFICULTY]).tr,
                      style: Theme.of(context).textTheme.caption,
                    ),
                  ],
                ),
                // SizedBox(height: 6.0),
                Divider(),
                Row(
                  children: [
                    Text(
                      S.START_TIME.tr,
                      style: Theme.of(context).textTheme.caption,
                    ),
                    SizedBox(width: 8.0),
                    Text(
                      getFormattedDateTime(
                          dateString: examConducted[C.START_TIME]),
                      style: Theme.of(context).textTheme.caption.copyWith(
                            color: Theme.of(context).textTheme.bodyText2.color,
                          ),
                    ),
                  ],
                ),
                SizedBox(height: 4.0),
                Row(
                  children: [
                    Text(
                      S.EXPIRE_TIME.tr,
                      style: Theme.of(context).textTheme.caption,
                    ),
                    SizedBox(width: 8.0),
                    Text(
                      examConducted[C.EXPIRE_TIME] != null
                          ? getFormattedDateTime(
                              dateString: examConducted[C.EXPIRE_TIME])
                          : S.NO_EXPIRE_TIME.tr,
                      style: Theme.of(context).textTheme.caption.copyWith(
                            color: Theme.of(context).errorColor,
                          ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (buttons != null)
            Column(
              children: [
                Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: buttons
                      .map(
                        (e) => OutlinedButton(
                          onPressed: e[C.ON_TAP],
                          child: Text(
                            e[C.NAME],
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: (e[C.PRIMARY] ?? true)
                                  ? Theme.of(context).primaryColor
                                  : Theme.of(context).errorColor,
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ],
            )
        ],
      ),
    );
  }
}
