import 'package:apna_classroom_app/api/question.dart';
import 'package:apna_classroom_app/components/cards/info_card.dart';
import 'package:apna_classroom_app/components/chips/group_chips.dart';
import 'package:apna_classroom_app/components/images/labeled_image.dart';
import 'package:apna_classroom_app/components/skeletons/list_skeleton.dart';
import 'package:apna_classroom_app/internationalization/strings.dart';
import 'package:apna_classroom_app/screens/notes/widgets/single_note.dart';
import 'package:apna_classroom_app/screens/quiz/widgets/option_check_box.dart';
import 'package:apna_classroom_app/util/c.dart';
import 'package:apna_classroom_app/util/constants.dart';
import 'package:apna_classroom_app/util/helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DetailedQuestion extends StatefulWidget {
  final Map<String, dynamic> question;

  const DetailedQuestion({Key key, this.question}) : super(key: key);

  @override
  _DetailedQuestionState createState() => _DetailedQuestionState();
}

class _DetailedQuestionState extends State<DetailedQuestion> {
  bool isLoading = true;
  Map<String, dynamic> question = {};

  loadQuestion() async {
    Map<String, dynamic> _question =
        await getQuestion({C.ID: widget.question[C.ID]});
    setState(() {
      question = _question;
      isLoading = false;
    });
  }

  onShare() {}

  @override
  void initState() {
    super.initState();
    loadQuestion();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.QUESTION.tr),
        actions: [IconButton(icon: Icon(Icons.share), onPressed: onShare)],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: [
              SizedBox(height: 16.0),
              SelectableText(
                widget.question[C.TITLE],
                style: Theme.of(context).textTheme.subtitle2,
              ),
              SizedBox(height: 8.0),
              if (isLoading) ListSkeleton(size: 4),
              if (!isLoading)
                Column(
                  children: [
                    Wrap(
                      children: question[C.MEDIA]
                          .map<Widget>(
                            (e) => LabeledImage(
                              thumbnailUrl: e[C.THUMBNAIL_URL],
                              url: e[C.URL],
                              label: e[C.TITLE],
                            ),
                          )
                          .toList(),
                    ),
                    if (question[C.ANSWER_TYPE] == E.MULTI_CHOICE ||
                        question[C.ANSWER_TYPE] == E.SINGLE_CHOICE)
                      getOptionList(),
                    InfoCard(
                      title: S.ANSWER.tr,
                      data: question[C.ANSWER],
                    ),
                    InfoCard(
                      title: S.ANSWER_FORMAT.tr,
                      data: question[C.ANSWER_FORMAT],
                    ),
                    InfoCard(
                      title: S.ANSWER_HINT.tr,
                      data: question[C.ANSWER_HINT],
                    ),
                    if (question[C.SOLVING_TIME] != null)
                      InfoCard(
                        title: S.SOLVING_TIME.tr,
                        data: getMinuteSt(question[C.SOLVING_TIME]),
                      ),
                    InfoCard(
                      title: S.MARKS.tr,
                      data: question[C.MARKS],
                    ),
                    InfoCard(
                      title: S.EXAM.tr,
                      child: GroupChips(list: question[C.EXAM].cast<String>()),
                    ),
                    InfoCard(
                      title: S.SUBJECT.tr,
                      child:
                          GroupChips(list: question[C.SUBJECT].cast<String>()),
                    ),
                    if (question[C.SOLUTION] != null)
                      SingleNote(note: question[C.SOLUTION])
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }

  // Designs
  Widget getOptionList() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      decoration: BoxDecoration(
        border: Border.all(width: 1, color: Theme.of(context).dividerColor),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Column(
        children: question[C.OPTION]
            .asMap()
            .map(
              (index, option) {
                return MapEntry(
                  index,
                  OptionCheckBox(
                    checked: option[C.CORRECT],
                    text: option[C.TEXT],
                    thumbnailUrl: (option[C.MEDIA] ?? {})[C.THUMBNAIL_URL],
                    url: (option[C.MEDIA] ?? {})[C.URL],
                    isCheckBox: question[C.ANSWER_TYPE] == E.MULTI_CHOICE,
                    valueRadio: index,
                    groupValue: question[C.OPTION]
                        .indexWhere((element) => element[C.CORRECT] == true),
                    isEditable: false,
                  ),
                );
              },
            )
            .values
            .toList()
            .cast<Widget>(),
      ),
    );
  }
}
