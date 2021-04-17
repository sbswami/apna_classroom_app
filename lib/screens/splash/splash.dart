import 'package:apna_classroom_app/components/skeletons/details_skeleton.dart';
import 'package:flutter/material.dart';

class Splash extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: DetailsSkeleton(type: DetailsType.Image, imageHeight: MediaQuery.of(context).size.height),
        decoration:
            BoxDecoration(color: Theme.of(context).scaffoldBackgroundColor),
      ),
    );
  }
}
