import 'package:flutter/widgets.dart';
import 'package:meta/meta.dart';

enum VisibilityWidgetFlag {
  visible,
  invisible,
  offscreen,
  gone,
}

class VisibilityWidget extends StatelessWidget {
  final VisibilityWidgetFlag visibility;
  final Widget child;
  final Widget removedChild;

  VisibilityWidget({
    @required this.child,
    @required this.visibility,
  }) : this.removedChild = Container();

  @override
  Widget build(BuildContext context) {
    if (visibility == VisibilityWidgetFlag.visible) {
      return child;
    } else if (visibility == VisibilityWidgetFlag.invisible) {
      return new IgnorePointer(
        ignoring: true,
        child: new Opacity(
          opacity: 0.0,
          child: child,
        ),
      );
    } else if (visibility == VisibilityWidgetFlag.offscreen) {
      return new Offstage(
        offstage: true,
        child: child,
      );
    } else {
      // If gone, we replace child with a custom widget (defaulting to a
      // [Container] with no defined size).
      return removedChild;
    }
  }
}
