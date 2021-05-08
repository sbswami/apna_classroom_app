import 'package:apna_classroom_app/components/menu/bottom_sheet_menu.dart';
import 'package:apna_classroom_app/components/menu/menu_item.dart';
import 'package:flutter/material.dart';

Future showApnaMenu(BuildContext context, List<MenuItem> list,
    {MenuType type = MenuType.Menu}) {
  if (type == MenuType.BottomSheet) {
    return showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return ApnaBottomSheetMenu(list: list);
      },
    );
  }

  RenderBox box = context.findRenderObject();
  Offset position = box.localToGlobal(Offset.zero);
  List<PopupMenuItem> items = list.map((e) => PopupMenuItem(child: e)).toList();
  return showMenu(
      context: context,
      position: RelativeRect.fromLTRB(
        position.dx,
        position.dy,
        box.size.width - position.dx,
        box.size.height - position.dy,
      ),
      items: items);
}

enum MenuType {
  BottomSheet,
  Menu,
}
