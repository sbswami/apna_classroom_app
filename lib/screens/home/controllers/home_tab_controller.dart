import 'package:get/get.dart';

class HomeTabController extends GetxController {
  var activeTab = 0.obs;

  static HomeTabController get to => Get.find<HomeTabController>();

  changeTab(int tab) {
    activeTab.value = tab;
  }
}
