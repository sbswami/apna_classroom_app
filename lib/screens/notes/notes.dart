import 'package:apna_classroom_app/api/notes.dart';
import 'package:apna_classroom_app/components/skeletons/list_skeleton.dart';
import 'package:apna_classroom_app/controllers/subjects_controller.dart';
import 'package:apna_classroom_app/screens/home/widgets/home_app_bar.dart';
import 'package:apna_classroom_app/screens/notes/widgets/notes_card.dart';
import 'package:apna_classroom_app/screens/notes/widgets/subject_filter.dart';
import 'package:apna_classroom_app/util/c.dart';
import 'package:flutter/material.dart';

const String PER_PAGE_NOTE = '10';

class Notes extends StatefulWidget {
  @override
  _NotesState createState() => _NotesState();
}

class _NotesState extends State<Notes>
    with AutomaticKeepAliveClientMixin<Notes> {
  // Variables
  bool isLoading = false;
  List<String> selectedSubjects = [];
  List notes = [];
  String searchTitle;

  // Init
  @override
  void initState() {
    super.initState();
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
      C.PRESENT: present.toString(),
      C.PER_PAGE: PER_PAGE_NOTE,
    };
    if (searchTitle != null) payload[C.TITLE] = searchTitle;
    var noteList = await listNote(payload, selectedSubjects);
    setState(() {
      isLoading = false;
      notes.addAll(noteList);
    });
  }

  onSelectedSubject(subject, selected) async {
    setState(() {
      if (selected) {
        selectedSubjects.add(subject);
      } else {
        selectedSubjects.remove(subject);
      }
      notes.clear();
    });
    loadNotes();
  }

  // On Search
  onSearch(String value) {
    setState(() {
      notes.clear();
      if (value.isEmpty)
        searchTitle = null;
      else
        searchTitle = value;
    });
    loadNotes();
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
    super.build(context);
    int resultLength = notes.length;
    return Scaffold(
      appBar: HomeAppBar(onSearch: onSearch),
      body: Column(
        children: [
          SubjectFilter(
            subjects: RecentlyUsedController.to.subjects,
            selectedSubjects: selectedSubjects,
            onSelected: onSelectedSubject,
          ),
          if (resultLength == 0 && (isLoading ?? true)) ListSkeleton(size: 4),
          Expanded(
            child: NotificationListener<ScrollNotification>(
              onNotification: (ScrollNotification scrollInfo) {
                if ((scrollInfo.metrics.pixels ==
                        scrollInfo.metrics.maxScrollExtent) &&
                    !isLoading) {
                  loadNotes();
                }
                return true;
              },
              child: RefreshIndicator(
                onRefresh: onRefresh,
                child: ListView.builder(
                  itemCount: resultLength,
                  itemBuilder: (context, position) {
                    return NotesCard(note: notes[position]);
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
