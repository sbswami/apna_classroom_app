import 'package:apna_classroom_app/components/menu_item.dart';
import 'package:flutter/material.dart';

showApnaMenu(BuildContext context, List<MenuItem> list) {
  RenderBox box = context.findRenderObject();
  Offset position = box.localToGlobal(Offset.zero);
  List<PopupMenuItem> items = list.map((e) => PopupMenuItem(child: e)).toList();
  showMenu(
      context: context,
      position: RelativeRect.fromLTRB(
        position.dx,
        position.dy,
        box.size.width - position.dx,
        box.size.height - position.dy,
      ),
      items: items);
}
