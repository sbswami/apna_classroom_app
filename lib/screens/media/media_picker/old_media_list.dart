import 'package:apna_classroom_app/api/media.dart';
import 'package:apna_classroom_app/api/storage/storage_api_constants.dart';
import 'package:apna_classroom_app/components/images/UrlImage.dart';
import 'package:apna_classroom_app/components/skeletons/details_skeleton.dart';
import 'package:apna_classroom_app/screens/empty/empty_info.dart';
import 'package:apna_classroom_app/util/c.dart';
import 'package:apna_classroom_app/util/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class OldMediaList extends StatefulWidget {
  final Function(List<Map<String, dynamic>>) onMediaSelect;
  final MediaType type;
  final bool isSelectable;

  const OldMediaList(
      {Key key,
      @required this.onMediaSelect,
      @required this.type,
      this.isSelectable})
      : super(key: key);

  @override
  _OldMediaListState createState() => _OldMediaListState();
}

class _OldMediaListState extends State<OldMediaList> {
  ScrollController _scrollController = ScrollController();

  // State
  List mediaList = [];
  List<String> selected = [];

  bool isSelectable = false;
  bool isLoading = false;

  // Load Images
  loadImages() async {
    if (isLoading) return;
    setState(() {
      isLoading = true;
    });
    String type;

    switch (widget.type) {
      case MediaType.Image:
        type = E.IMAGE;
        break;
      case MediaType.PDF:
        type = E.PDF;
        break;
      case MediaType.Video:
        type = E.VIDEO;
        break;
    }

    var list = await listMedia({
      C.TYPE: type,
      C.PRESENT: mediaList.length.toString(),
      C.PER_PAGE: '10',
    });
    setState(() {
      isLoading = false;
      mediaList.addAll(list);
    });
  }

  // on Long press image
  _onLongPress(Map<String, dynamic> media) {
    if (widget.isSelectable)
      setState(() {
        isSelectable = true;
        selected.add(media[C.ID]);
      });
  }

  // On tap
  _onTap(Map<String, dynamic> media, bool select) {
    if (!isSelectable) return widget.onMediaSelect([media]);
    setState(() {
      if (select) {
        selected.add(media[C.ID]);
      } else {
        selected.remove(media[C.ID]);
      }
    });
  }

  // Done after select
  _done() {
    List<Map<String, dynamic>> list = mediaList
        .where(
          (element) => selected.contains(element[C.ID]),
        )
        .toList()
        .cast<Map<String, dynamic>>();
    widget.onMediaSelect(list);
  }

  // Init state
  @override
  void initState() {
    super.initState();
    loadImages();
  }

  @override
  Widget build(BuildContext context) {
    int listLength = mediaList.length;
    return Stack(children: [
      Column(
        children: [
          if (isLoading && listLength == 0)
            DetailsSkeleton(
              type: DetailsType.Image,
            )
          else if (listLength == 0)
            EmptyInfo(type: EmptyInfoType.Media),
          Expanded(
            child: NotificationListener(
              onNotification: (ScrollNotification scrollInfo) {
                if ((scrollInfo.metrics.pixels ==
                        scrollInfo.metrics.maxScrollExtent) &&
                    !isLoading &&
                    _scrollController.position.userScrollDirection ==
                        ScrollDirection.reverse) {
                  loadImages();
                }
                return true;
              },
              child: GridView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.all(8.0),
                // semanticChildCount: 3,
                itemCount: listLength,
                // crossAxisCount: 3,
                scrollDirection: Axis.horizontal,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),

                itemBuilder: (BuildContext context, int index) {
                  var media = mediaList[index];
                  bool isSelected =
                      selected.any((element) => element == media[C.ID]);
                  return GestureDetector(
                    onTap: () => _onTap(media, !isSelected),
                    onLongPress: () => _onLongPress(media),
                    child: Stack(
                      children: [
                        UrlImage(
                          fileName: FileName.THUMBNAIL,
                          url: media[C.URL],
                          fit: BoxFit.cover,
                        ),
                        Positioned(
                          child: Container(
                            child: Container(
                              decoration: BoxDecoration(
                                color: Theme.of(context).cardColor,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              padding: const EdgeInsets.all(4),
                              margin: const EdgeInsets.only(bottom: 4),
                              child: Text(
                                media[C.TITLE],
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            alignment: Alignment.center,
                          ),
                          bottom: 0,
                          right: 0,
                          left: 0,
                        ),
                        if (isSelected)
                          Positioned(
                            top: 4,
                            right: 4,
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Theme.of(context).primaryColor,
                                  borderRadius: BorderRadius.circular(24),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.5),
                                      spreadRadius: 2,
                                      blurRadius: 5,
                                    ),
                                  ]),
                              padding: const EdgeInsets.all(4),
                              child: Icon(
                                Icons.check,
                                color: Theme.of(context).cardColor,
                              ),
                            ),
                          )
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
      if (isSelectable)
        Positioned(
          bottom: 16,
          right: 16,
          child: FloatingActionButton(
            onPressed: _done,
            child: Icon(Icons.check),
          ),
        ),
    ]);
  }
}

enum MediaType { Image, PDF, Video }
