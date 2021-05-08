import 'package:apna_classroom_app/analytics/analytics_constants.dart';
import 'package:apna_classroom_app/analytics/analytics_manager.dart';
import 'package:apna_classroom_app/api/message.dart';
import 'package:apna_classroom_app/components/skeletons/details_skeleton.dart';
import 'package:apna_classroom_app/internationalization/strings.dart';
import 'package:apna_classroom_app/screens/classroom_notes/widgets/note_message_card.dart';
import 'package:apna_classroom_app/screens/empty/empty_list.dart';
import 'package:apna_classroom_app/util/c.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';

class ClassroomNotes extends StatefulWidget {
  final classroom;

  const ClassroomNotes({Key key, this.classroom}) : super(key: key);
  @override
  _ClassroomNotesState createState() => _ClassroomNotesState();
}

class _ClassroomNotesState extends State<ClassroomNotes> {
  ScrollController _scrollController = ScrollController();
  // Variables
  bool isLoading = false;
  List notes = [];

  // Init
  @override
  void initState() {
    super.initState();

    // Track Screen
    trackScreen(ScreenNames.ClassroomNotes);

    // Track Event
    track(EventName.VIEWED_CLASSROOM_NOTE, {});

    loadNotes();
  }

  // Load Notes
  loadNotes() async {
    if (isLoading == true) return;
    setState(() {
      isLoading = true;
    });
    int present = notes.length;
    Map<String, String> payload = {
      C.CLASSROOM: widget.classroom[C.ID],
      C.PRESENT: present.toString(),
      C.PER_PAGE: '10',
    };
    var noteList = await getNoteMessage(payload);
    setState(() {
      isLoading = false;
      notes.addAll(noteList);
    });
  }

  // On refresh
  Future<void> onRefresh() async {
    setState(() {
      notes.clear();
    });
    await loadNotes();
  }

  @override
  Widget build(BuildContext context) {
    int resultLength = notes.length;
    return Scaffold(
      appBar: AppBar(
        title: Text(S.CLASSROOM_NOTES.tr),
      ),
      body: Column(
        children: [
          if (resultLength == 0 && (isLoading ?? true))
            DetailsSkeleton(
              type: DetailsType.Info,
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
                  loadNotes();
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
                    return NoteMessageCard(
                      message: notes[position],
                      screen: ScreenNames.ClassroomNotes,
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
