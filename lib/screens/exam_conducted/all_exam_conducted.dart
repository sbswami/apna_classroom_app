import 'package:apna_classroom_app/analytics/analytics_constants.dart';
import 'package:apna_classroom_app/analytics/analytics_manager.dart';
import 'package:apna_classroom_app/api/exam_conducted.dart';
import 'package:apna_classroom_app/components/skeletons/details_skeleton.dart';
import 'package:apna_classroom_app/screens/empty/empty_list.dart';
import 'package:apna_classroom_app/screens/exam_conducted/widgets/exam_conducted_card.dart';
import 'package:apna_classroom_app/screens/exam_conducted/widgets/exam_conducted_list.dart';
import 'package:apna_classroom_app/util/c.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class AllExamConducted extends StatefulWidget {
  final String classroomId;
  final ExamConductedState type;

  const AllExamConducted({Key key, this.classroomId, this.type})
      : super(key: key);

  @override
  _AllExamConductedState createState() => _AllExamConductedState();
}

class _AllExamConductedState extends State<AllExamConducted> {
  ScrollController _scrollController = ScrollController();
  // Variables
  String title = '';
  bool isLoading = false;
  List examConductedList = [];

  // Init
  @override
  void initState() {
    title = getExamConductedTitle(widget.type);
    super.initState();

    // Track Screen
    trackScreen(ScreenNames.ExamConducted);

    // Track View event
    track(EventName.VIEWED_EXAM_CONDUCTED, {
      EventProp.TYPE: widget.type.toString(),
    });

    loadExamConducted();
  }

  // Load ExamConducted
  loadExamConducted() async {
    if (isLoading == true) return;
    setState(() {
      isLoading = true;
    });
    int present = examConductedList.length;
    Map<String, String> payload = {
      C.PRESENT: present.toString(),
      C.PER_PAGE: '10',
      C.CLASSROOM: widget.classroomId,
    };
    switch (widget.type) {
      case ExamConductedState.RUNNING:
        payload[C.RUNNING_EXAM] = "true";
        break;
      case ExamConductedState.UPCOMING:
        payload[C.UPCOMING_EXAM] = "true";
        break;
      case ExamConductedState.COMPLETED:
        payload[C.COMPLETED_EXAM] = "true";
        break;
    }
    var _examConductedList = await listExamConducted(payload);
    setState(() {
      isLoading = false;
      examConductedList.addAll(_examConductedList);
    });
  }

  // On refresh
  Future<void> onRefresh() async {
    setState(() {
      examConductedList.clear();
    });
    await loadExamConducted();
  }

  @override
  Widget build(BuildContext context) {
    int resultLength = examConductedList.length;
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Column(
        children: [
          if (resultLength == 0 && (isLoading ?? true))
            DetailsSkeleton(
              type: DetailsType.Card,
            )
          else if (resultLength == 0)
            EmptyList(),
          Expanded(
            child: NotificationListener<ScrollNotification>(
              onNotification: (ScrollNotification scrollInfo) {
                if ((scrollInfo.metrics.pixels ==
                        scrollInfo.metrics.maxScrollExtent) &&
                    !isLoading &&
                    _scrollController.position.userScrollDirection ==
                        ScrollDirection.reverse) {
                  loadExamConducted();
                }
                return true;
              },
              child: RefreshIndicator(
                onRefresh: onRefresh,
                child: ListView.builder(
                  physics: const AlwaysScrollableScrollPhysics(),
                  controller: _scrollController,
                  itemCount: resultLength,
                  itemBuilder: (context, position) {
                    var examConducted = examConductedList[position];
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: ExamConductedCard(
                        examConducted: examConducted,
                        buttons: getExamConductedButtons(widget.type,
                            examConducted, ScreenNames.ExamConducted),
                        screen: ScreenNames.ExamConducted,
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
