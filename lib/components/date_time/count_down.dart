import 'dart:async';

import 'package:apna_classroom_app/util/helper.dart';
import 'package:flutter/material.dart';

class CountDown extends StatefulWidget {
  final int seconds;
  final Function onCountDownEnd;

  const CountDown({Key key, this.seconds, this.onCountDownEnd})
      : super(key: key);
  @override
  _CountDownState createState() => _CountDownState();
}

class _CountDownState extends State<CountDown> {
  int _seconds = 0;
  Timer _timer;

  _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_seconds == 0) {
        setState(() {
          timer.cancel();
        });
        widget.onCountDownEnd();
      } else {
        setState(() {
          _seconds--;
        });
      }
    });
  }

  @override
  void initState() {
    _seconds = widget.seconds ?? 0;
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Text(getMinuteSt(_seconds));
  }
}
