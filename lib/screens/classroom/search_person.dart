import 'package:apna_classroom_app/api/user.dart';
import 'package:apna_classroom_app/components/skeletons/details_skeleton.dart';
import 'package:apna_classroom_app/internationalization/strings.dart';
import 'package:apna_classroom_app/screens/classroom/widgets/person_card.dart';
import 'package:apna_classroom_app/screens/empty/empty_list.dart';
import 'package:apna_classroom_app/util/c.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';

class SearchPerson extends StatefulWidget {
  @override
  _SearchPersonState createState() => _SearchPersonState();
}

class _SearchPersonState extends State<SearchPerson> {
  ScrollController _scrollController = ScrollController();
  final TextEditingController searchController = TextEditingController();

  // Variables
  List users = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    loadPerson();
  }

  // Load Person
  loadPerson() async {
    if (isLoading) return;
    setState(() {
      isLoading = true;
    });
    int length = users.length;
    var list = await searchPerson({
      C.PRESENT: length.toString(),
      C.PER_PAGE: '10',
      C.SEARCH: searchController.text,
    });
    setState(() {
      users.addAll(list);
      isLoading = false;
    });
  }

  // on Search
  onSearch() {
    setState(() {
      users.clear();
    });
    loadPerson();
  }

  // On Person Click
  onPersonTap(_person) {
    Get.back(result: [_person]);
  }

  // On person long
  List selectedPersons = [];
  bool isSelectable = false;
  onLongPressPerson(String id) {
    setState(() {
      isSelectable = true;
      selectedPersons.add(id);
    });
  }

  onSelected(String id, bool selected) {
    setState(() {
      if (selected)
        selectedPersons.add(id);
      else {
        selectedPersons.remove(id);
        if (selectedPersons.length == 0) {
          isSelectable = false;
        }
      }
    });
  }

  onSelect() {
    Get.back(
      result: users
          .where((element) => selectedPersons.contains(element[C.ID]))
          .toList(),
    );
  }

  // On refresh
  Future<void> onRefresh() async {
    setState(() {
      users.clear();
    });
    await loadPerson();
  }

  // Clear Filter
  clearFilter() {
    searchController.clear();
    loadPerson();
  }

  @override
  Widget build(BuildContext context) {
    int resultLength = users.length;
    return Scaffold(
      appBar: AppBar(
        title: Text(S.SEARCH_PERSON.tr),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Flexible(
                  child: TextField(
                    controller: searchController,
                    decoration: InputDecoration(labelText: S.SEARCH.tr),
                  ),
                ),
                IconButton(icon: Icon(Icons.search), onPressed: onSearch)
              ],
            ),
          ),
          SizedBox(height: 8.0),
          if (resultLength == 0 && (isLoading ?? true))
            DetailsSkeleton(
              type: DetailsType.PersonList,
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
                  loadPerson();
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
                    var _person = users[position];
                    bool isSelected;
                    if (isSelectable) {
                      isSelected = selectedPersons
                          .any((element) => element == _person[C.ID]);
                    }
                    return PersonCard(
                      person: _person,
                      onTap: () => onPersonTap(_person),
                      isSelected: isSelected,
                      onLongPress: ({BuildContext context}) =>
                          onLongPressPerson(_person[C.ID]),
                      onSelected: (selected) =>
                          onSelected(_person[C.ID], selected),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: isSelectable
          ? FloatingActionButton(
              child: Icon(Icons.check),
              onPressed: onSelect,
            )
          : null,
    );
  }
}
