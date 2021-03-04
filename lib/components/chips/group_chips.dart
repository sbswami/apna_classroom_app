import 'package:flutter/material.dart';

class GroupChips extends StatelessWidget {
  final List<String> list;
  final double width;

  const GroupChips({Key key, this.list, this.width}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      width: width ?? MediaQuery.of(context).size.width * 0.7,
      margin: const EdgeInsets.only(top: 8.0),
      child: Wrap(
        children: list
            .map((e) => Padding(
                  padding:
                      const EdgeInsets.only(right: 8.0, top: 4.0, bottom: 4.0),
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                            width: 1,
                            color: Theme.of(context)
                                .primaryColor
                                .withOpacity(0.5))),
                    padding: const EdgeInsets.all(4.0),
                    child: Text(
                      e,
                      style: TextStyle(fontSize: 11),
                    ),
                  ),
                ))
            .toList(),
      ),
    );
  }
}
