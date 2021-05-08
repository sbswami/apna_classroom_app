import 'package:apna_classroom_app/analytics/analytics_constants.dart';
import 'package:apna_classroom_app/analytics/analytics_manager.dart';
import 'package:apna_classroom_app/api/classroom.dart';
import 'package:apna_classroom_app/api/join_request.dart';
import 'package:apna_classroom_app/components/skeletons/details_skeleton.dart';
import 'package:apna_classroom_app/internationalization/strings.dart';
import 'package:apna_classroom_app/screens/empty/empty_list.dart';
import 'package:apna_classroom_app/screens/join_requests/widgets/join_request_card.dart';
import 'package:apna_classroom_app/util/c.dart';
import 'package:apna_classroom_app/util/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';

class JoinRequests extends StatefulWidget {
  final classroom;

  const JoinRequests({Key key, this.classroom}) : super(key: key);
  @override
  _JoinRequestsState createState() => _JoinRequestsState();
}

class _JoinRequestsState extends State<JoinRequests> {
  ScrollController _scrollController = ScrollController();
  // Variables
  bool isLoading = false;
  List joinRequests = [];

  // Init
  @override
  void initState() {
    super.initState();

    // Track Screen
    trackScreen(ScreenNames.JoinRequests);

    // Track Event
    track(EventName.VIEWED_JOIN_REQUESTS, {});

    loadRequests();
  }

  // Load Requests
  loadRequests() async {
    if (isLoading == true) return;
    setState(() {
      isLoading = true;
    });

    int present = joinRequests.length;
    Map<String, String> payload = {
      C.PRESENT: present.toString(),
      C.PER_PAGE: '10',
      C.CLASSROOM: widget.classroom[C.ID],
    };

    var list = await listJoinRequest(payload);

    setState(() {
      isLoading = false;
      joinRequests.addAll(list);
    });
  }

  // Delete Join Request
  _delete(Map request, int index) async {
    await deleteJoinRequest({C.ID: request[C.ID]});
    setState(() {
      joinRequests.removeAt(index);
    });

    // Track Event
    track(EventName.ACTION_ON_JOIN_REQUEST, {EventProp.ACTION: 'Delete'});
  }

  // Accept Join request
  _accept(Map request, int index) async {
    await addMembers({
      C.ID: widget.classroom[C.ID],
      C.MEMBERS: [
        {
          C.ROLE: E.MEMBER,
          C.ID: request[C.USER][C.ID],
        }
      ],
    });

    _delete(request, index);

    // Track Event
    track(EventName.ACTION_ON_JOIN_REQUEST, {EventProp.ACTION: 'Accept'});
  }

  // On refresh
  Future<void> onRefresh() async {
    setState(() {
      joinRequests.clear();
    });
    await loadRequests();
  }

  @override
  Widget build(BuildContext context) {
    int resultLength = joinRequests.length;
    return Scaffold(
      appBar: AppBar(
        title: Text(S.JOIN_REQUESTS.tr),
      ),
      body: Column(
        children: [
          if (resultLength == 0 && (isLoading ?? true))
            DetailsSkeleton(
              type: DetailsType.List,
            )
          else if (resultLength == 0)
            Expanded(
              child: SingleChildScrollView(
                child: EmptyList(),
              ),
            )
          else
            Expanded(
              child: NotificationListener<ScrollNotification>(
                onNotification: (ScrollNotification scrollInfo) {
                  if ((scrollInfo.metrics.pixels ==
                          scrollInfo.metrics.maxScrollExtent) &&
                      !isLoading &&
                      _scrollController.position.userScrollDirection ==
                          ScrollDirection.reverse) {
                    loadRequests();
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
                      final request = joinRequests[position];

                      return JoinRequestCard(
                        joinRequest: request,
                        onDelete: () => _delete(request, position),
                        onAccept: () => _accept(request, position),
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
