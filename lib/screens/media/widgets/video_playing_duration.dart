import 'dart:async';

import 'package:apna_classroom_app/util/date_time.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class PlayingDuration extends StatefulWidget {
  final VideoPlayerController controller;

  const PlayingDuration({Key key, this.controller}) : super(key: key);
  @override
  _PlayingDurationState createState() => _PlayingDurationState();
}

class _PlayingDurationState extends State<PlayingDuration> {
  Timer timer;

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Text(getReadableDuration(widget.controller.value.position));
  }
}
