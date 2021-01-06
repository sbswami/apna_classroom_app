import 'package:apna_classroom_app/internationalization/strings.dart';
import 'package:apna_classroom_app/util/assets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeAppBar extends StatefulWidget implements PreferredSizeWidget {
  final Function(String value) onSearch;
  final TextEditingController searchController;
  final PreferredSizeWidget bottom;
  final bool searchActive;

  const HomeAppBar({
    Key key,
    this.onSearch,
    this.bottom,
    this.searchController,
    this.searchActive,
  }) : super(key: key);
  @override
  _HomeAppBarState createState() => _HomeAppBarState();

  @override
  Size get preferredSize => Size.fromHeight(54);
}

class _HomeAppBarState extends State<HomeAppBar> {
  bool searchActive = false;
  TextEditingController searchController = TextEditingController();

  switchSearch(bool _searchActive) {
    setState(() {
      searchActive = _searchActive;
    });
  }

  List<Widget> getActions(BuildContext context) {
    if (searchActive)
      return [
        IconButton(
          icon: Icon(Icons.search),
          onPressed: () => widget.onSearch(searchController.text),
          color: Theme.of(context).primaryColor,
        )
      ];
    return [
      IconButton(
        icon: Icon(
          Icons.search,
          color: Theme.of(context).primaryColor,
        ),
        onPressed: () => switchSearch(true),
      ),
      IconButton(
        icon: Icon(
          Icons.notifications,
          color: Theme.of(context).primaryColor,
        ),
        onPressed: () {},
      )
    ];
  }

  Widget getTitle() {
    if (searchActive) {
      return TextFormField(
        controller: searchController,
        autofocus: true,
        decoration: InputDecoration(
          hintText: S.SEARCH.tr,
          border: InputBorder.none,
        ),
      );
    }
    return Image.asset(
      A.MINI_ICON,
      scale: 2.5,
    );
  }

  // Search Back Press
  onBackIconClick() {
    if (widget.searchActive ?? false) {
      return Get.back();
    }
    switchSearch(false);
  }

  @override
  void initState() {
    if (widget.searchController != null) {
      searchController = widget.searchController;
    }
    if (widget.searchActive != null) {
      searchActive = widget.searchActive;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: searchActive
          ? IconButton(
              icon: Icon(
                Icons.arrow_back_ios,
                color: Theme.of(context).primaryColor,
              ),
              onPressed: onBackIconClick,
            )
          : null,
      title: getTitle(),
      brightness: Brightness.light,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      actions: getActions(context),
      bottom: widget.bottom,
    );
  }
}
