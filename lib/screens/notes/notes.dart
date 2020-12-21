import 'package:apna_classroom_app/api/notes.dart';
import 'package:apna_classroom_app/components/skeletons/list_skeleton.dart';
import 'package:apna_classroom_app/controllers/subjects_controller.dart';
import 'package:apna_classroom_app/screens/notes/detailed_note.dart';
import 'package:apna_classroom_app/screens/notes/widgets/notes_card.dart';
import 'package:apna_classroom_app/screens/notes/widgets/subject_filter.dart';
import 'package:apna_classroom_app/util/c.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

const String PER_PAGE_NOTE = '10';

class Notes extends StatefulWidget {
  @override
  _NotesState createState() => _NotesState();
}

class _NotesState extends State<Notes> {
  // Variables
  bool isLoading = true;
  List<String> selectedSubjects = [];
  List notes = [];

  // Init
  @override
  void initState() {
    super.initState();
    loadNotes();
  }

  // Load Notes
  loadNotes() async {
    setState(() {
      isLoading = true;
    });
    int present = notes.length;

    var noteList = await listNote(
      {
        C.PRESENT: present.toString(),
        C.PER_PAGE: PER_PAGE_NOTE,
      },
      selectedSubjects,
    );
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

  // Note Click
  onNoteClick(Map<String, dynamic> note) {
    Get.to(DetailedNote(
      note: note,
    ));
  }

  @override
  Widget build(BuildContext context) {
    int resultLength = notes.length;
    return Column(
      children: [
        SubjectFilter(
          subjects: RecentlyUsedController.to.subjects,
          selectedSubjects: selectedSubjects,
          onSelected: onSelectedSubject,
        ),
        if (resultLength == 0 && isLoading) ListSkeleton(size: 4),
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
            child: ListView.builder(
              itemCount: resultLength,
              itemBuilder: (context, position) {
                return NotesCard(
                  note: notes[position],
                  onTap: () => onNoteClick(notes[position]),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
