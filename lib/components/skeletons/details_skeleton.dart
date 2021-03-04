import 'package:apna_classroom_app/util/assets.dart';
import 'package:flutter/material.dart';
import 'package:skeleton_loader/skeleton_loader.dart';

class DetailsSkeleton extends StatelessWidget {
  final DetailsType type;

  const DetailsSkeleton({Key key, this.type}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SkeletonLoader(
        builder: Center(
          child: Column(
            children: getList(),
          ),
        ),
        items: 1,
        period: Duration(seconds: 2),
        highlightColor: Colors.black12,
        direction: SkeletonDirection.ltr,
      ),
    );
  }

  List<Widget> getList() {
    switch (type) {
      case DetailsType.ImageButtonCard:
        return [_Image(), _Button(), _Button(), _Card(), _Card(), _Card()];

      case DetailsType.ImageInfo:
        return [
          _Image(),
          _Info(),
          _Info(),
          _Info(),
        ];
        break;
      case DetailsType.CardInfo:
        return [
          _Card(),
          _Info(),
          _Info(),
          _Info(),
          _Info(),
        ];
        break;

      case DetailsType.Chat:
        return [_Chat()];

      case DetailsType.Image:
        return [_Image()];

      case DetailsType.Info:
        return [
          _Info(),
          _Info(),
          _Info(),
          _Info(),
          _Info(),
          _Info(),
        ];
      case DetailsType.Card:
        return [
          _Card(),
          _Card(),
          _Card(),
        ];

      case DetailsType.List:
        return [
          _ListItem(),
          _ListItem(),
          _ListItem(),
          _ListItem(),
          _ListItem(),
        ];
      case DetailsType.PersonList:
        return [
          _PersonItem(),
          _PersonItem(),
          _PersonItem(),
          _PersonItem(),
          _PersonItem(),
        ];

      default:
        return [_Image(), _Button(), _Button(), _Card(), _Card(), _Card()];
    }
  }
}

class _Image extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(height: 250, child: Image.asset(A.APP_ICON));
  }
}

class _Button extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Container(
          width: MediaQuery.of(context).size.width * 0.85,
          height: 40,
          color: Colors.white,
        ),
      ),
    );
  }
}

class _Card extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(width: 1),
        borderRadius: BorderRadius.circular(8),
      ),
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
      width: MediaQuery.of(context).size.width * 0.85,
      child: Column(
        children: [
          _Button(),
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  width: 80,
                  height: 25,
                  color: Colors.white,
                ),
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  width: 80,
                  height: 25,
                  color: Colors.white,
                ),
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  width: 80,
                  height: 25,
                  color: Colors.white,
                ),
              )
            ],
          ),
          SizedBox(height: 16),
        ],
      ),
    );
  }
}

class _Info extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(width: 1),
        borderRadius: BorderRadius.circular(8),
      ),
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
      width: MediaQuery.of(context).size.width * 0.85,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Container(
              width: 80,
              height: 20,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  width: 80,
                  height: 25,
                  color: Colors.white,
                ),
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  width: 80,
                  height: 25,
                  color: Colors.white,
                ),
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  width: 80,
                  height: 25,
                  color: Colors.white,
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}

class _Chat extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: [
          Row(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.8,
                child: _Button(),
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.8,
                child: _Button(),
              )
            ],
          ),
          Row(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.8,
                child: _Card(),
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.8,
                child: _Card(),
              )
            ],
          ),
          Row(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.8,
                child: _Button(),
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.8,
                child: _Button(),
              )
            ],
          ),
          Row(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.8,
                child: _Card(),
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.8,
                child: _Card(),
              )
            ],
          ),
        ],
      ),
    );
  }
}

class _ListItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16),
      width: MediaQuery.of(context).size.width * 0.9,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Container(
              height: 24,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  width: 80,
                  height: 25,
                  color: Colors.white,
                ),
              ),
              SizedBox(width: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  width: 80,
                  height: 25,
                  color: Colors.white,
                ),
              ),
              SizedBox(width: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  width: 80,
                  height: 25,
                  color: Colors.white,
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}

class _PersonItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16),
      width: MediaQuery.of(context).size.width * 0.93,
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: Colors.white,
            radius: 25,
          ),
          SizedBox(width: 16.0),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.7,
                  height: 24,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      width: 80,
                      height: 25,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(width: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      width: 80,
                      height: 25,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(width: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      width: 80,
                      height: 25,
                      color: Colors.white,
                    ),
                  )
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

enum DetailsType {
  ImageButtonCard,
  ImageInfo,
  CardInfo,
  Chat,
  Image,
  Info,
  Card,
  List,
  PersonList,
}
