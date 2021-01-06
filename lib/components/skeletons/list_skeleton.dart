import 'package:flutter/material.dart';
import 'package:skeleton_loader/skeleton_loader.dart';

class ListSkeleton extends StatelessWidget {
  final int size;
  final bool person;

  const ListSkeleton({Key key, this.size, this.person}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SkeletonLoader(
      builder: Container(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            if (person ?? false)
              CircleAvatar(
                backgroundColor: Colors.white,
                radius: 25,
              ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.7,
                    height: 25,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        width: 60,
                        height: 25,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(width: 10),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        width: 60,
                        height: 25,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(width: 10),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        width: 60,
                        height: 25,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(width: 10),
            if (!(person ?? false))
              CircleAvatar(
                backgroundColor: Colors.white,
                radius: 14,
              ),
          ],
        ),
      ),
      items: size ?? 1,
      period: Duration(seconds: 2),
      highlightColor: Colors.black12,
      direction: SkeletonDirection.ltr,
    );
  }
}
