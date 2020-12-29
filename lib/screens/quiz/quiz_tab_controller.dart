import 'package:get/get.dart';

class QuizTabController extends GetxController {
  var activeTab = 0;

  static QuizTabController get to => Get.find<QuizTabController>();

  changeTab(int tab) {
    activeTab = tab;
  }
}
