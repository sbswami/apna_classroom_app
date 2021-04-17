import 'dart:math' as math;

import 'package:flutter/material.dart';

class ApnaSpeedDial extends StatefulWidget {
  final List<ActionButtonType> list;
  final IconData activeIcon;
  final IconData inactiveIcon;
  ApnaSpeedDial({Key key, this.list, this.activeIcon, this.inactiveIcon})
      : super(key: key);

  @override
  _ApnaSpeedDialState createState() => _ApnaSpeedDialState();
}

class _ApnaSpeedDialState extends State<ApnaSpeedDial>
    with TickerProviderStateMixin {
  AnimationController _controller;
  IconData activeIcon;
  IconData inactiveIcon;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    activeIcon = widget.activeIcon ?? Icons.list;
    inactiveIcon = widget.inactiveIcon ?? Icons.close;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Color bg = Theme.of(context).primaryColor;
    Color color = Theme.of(context).cardColor;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: List.generate(widget.list.length, (int index) {
        ActionButtonType buttonType = widget.list[index];
        Widget child = Container(
          height: 70.0,
          alignment: FractionalOffset.topLeft,
          child: ScaleTransition(
            scale: CurvedAnimation(
              parent: _controller,
              curve: Interval(
                0.0,
                1.0 - index / widget.list.length / 2,
                curve: Curves.easeOut,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                FloatingActionButton(
                  heroTag: null,
                  backgroundColor: bg,
                  mini: true,
                  child: Icon(buttonType.iconData, color: color),
                  onPressed: buttonType.onPressed,
                ),
                Container(
                    padding: const EdgeInsets.all(4),
                    margin: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: color,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 5,
                        )
                      ],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(buttonType.title)),
              ],
            ),
          ),
        );
        return child;
      }).toList()
        ..add(
          Row(
            children: [
              FloatingActionButton(
                backgroundColor: bg,
                heroTag: null,
                child: AnimatedBuilder(
                  animation: _controller,
                  builder: (BuildContext context, Widget child) {
                    return Transform(
                      transform: Matrix4.rotationZ(
                        _controller.value * 0.5 * math.pi,
                      ),
                      alignment: FractionalOffset.center,
                      child: Icon(
                        _controller.isDismissed ? activeIcon : inactiveIcon,
                        // Icons.add,
                        color: color,
                      ),
                    );
                  },
                ),
                onPressed: () {
                  if (_controller.isDismissed) {
                    _controller.forward();
                  } else {
                    _controller.reverse();
                  }
                },
              ),
            ],
          ),
        ),
    );
  }
}

class ActionButtonType {
  String title = '';
  IconData iconData;
  Function onPressed;

  ActionButtonType({this.title, this.iconData, this.onPressed});
}
