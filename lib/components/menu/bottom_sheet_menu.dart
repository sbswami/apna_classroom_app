import 'package:apna_classroom_app/components/menu/menu_item.dart';
import 'package:flutter/material.dart';

class ApnaBottomSheetMenu extends StatelessWidget {
  final List<MenuItem> list;

  const ApnaBottomSheetMenu({Key key, this.list}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24.0),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: list
              .map(
                (e) => e,
              )
              .toList(),
        ),
      ),
    );
  }
}
