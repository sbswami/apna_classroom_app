import 'package:apna_classroom_app/api/user.dart';
import 'package:apna_classroom_app/components/cards/info_card.dart';
import 'package:apna_classroom_app/components/images/UrlImage.dart';
import 'package:apna_classroom_app/components/skeletons/details_skeleton.dart';
import 'package:apna_classroom_app/internationalization/strings.dart';
import 'package:apna_classroom_app/util/c.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PersonDetails extends StatefulWidget {
  final person;

  const PersonDetails({Key key, this.person}) : super(key: key);

  @override
  _PersonDetailsState createState() => _PersonDetailsState();
}

class _PersonDetailsState extends State<PersonDetails> {
  var person;
  bool isLoading = true;

  // Load Person
  loadPerson() async {
    var _person = await getPerson({C.ID: widget.person[C.ID]});
    setState(() {
      person = _person;
      isLoading = false;
    });
  }

  // Init State
  @override
  void initState() {
    super.initState();
    loadPerson();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(S.PROFILE.tr)),
      body: Column(
        children: [
          if (isLoading)
            DetailsSkeleton(
              type: DetailsType.ImageInfo,
            )
          else
            Expanded(
              child: ListView(
                physics: ClampingScrollPhysics(),
                children: [
                  Container(
                    height: MediaQuery.of(context).size.width * 0.75,
                    child: UrlImage(
                      url: (person[C.MEDIA] ?? {})[C.URL],
                      fit: BoxFit.cover,
                      borderRadius: 0.0,
                    ),
                  ),
                  SizedBox(height: 24),
                  Container(
                    alignment: Alignment.center,
                    child: Text(
                      person[C.NAME],
                      style: Theme.of(context).textTheme.headline6,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      children: [
                        InfoCard(
                          title: S.PHONE_NUMBER.tr,
                          data: person[C.PHONE],
                        ),
                        InfoCard(
                          title: S.USERNAME.tr,
                          data: person[C.USERNAME],
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
        ],
      ),
    );
  }
}
