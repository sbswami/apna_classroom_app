import 'package:apna_classroom_app/api/notes.dart';
import 'package:apna_classroom_app/components/skeletons/details_skeleton.dart';
import 'package:apna_classroom_app/controllers/subjects_controller.dart';
import 'package:apna_classroom_app/screens/empty/empty_list.dart';
import 'package:apna_classroom_app/screens/home/widgets/apna_bottom_navigation_bar.dart';
import 'package:apna_classroom_app/screens/home/widgets/home_app_bar.dart';
import 'package:apna_classroom_app/screens/home/widgets/home_drawer.dart';
import 'package:apna_classroom_app/screens/notes/add_notes.dart';
import 'package:apna_classroom_app/screens/notes/widgets/notes_card.dart';
import 'package:apna_classroom_app/screens/notes/widgets/subject_filter.dart';
import 'package:apna_classroom_app/util/c.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';

const String PER_PAGE_NOTE = '10';

class Notes extends StatefulWidget {
  final PageController pageController;

  const Notes({Key key, this.pageController}) : super(key: key);
  @override
  _NotesState createState() => _NotesState();
}

class _NotesState extends State<Notes>
    with AutomaticKeepAliveClientMixin<Notes> {
  ScrollController _scrollController = ScrollController();
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

  // Clear Filter
  clearFilter() {
    setState(() {
      selectedSubjects.clear();
      searchTitle = null;
      notes.clear();
      loadNotes();
    });
  }

  // Add
  _add() async {
    var result = await Get.to(AddNotes());
    if (result ?? false) onRefresh();
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
          if (resultLength == 0 && (isLoading ?? true))
            DetailsSkeleton(
              type: DetailsType.List,
            )
          else if (resultLength == 0)
            EmptyList(
              onClearFilter: clearFilter,
            ),
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
                    return NotesCard(
                      note: notes[position],
                      onRefresh: onRefresh,
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
      drawer: HomeDrawer(),
      floatingActionButton: FloatingActionButton(
        heroTag: null,
        onPressed: _add,
        child: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      bottomNavigationBar: ApnaBottomNavigationBar(
        pageController: widget.pageController,
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
