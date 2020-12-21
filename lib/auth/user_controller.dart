import 'package:apna_classroom_app/util/c.dart';
import 'package:get/get.dart';

class UserController extends GetxController {
  Map<String, dynamic> currentUser = {};

  static UserController get to => Get.find<UserController>();

  void updateUser(Map<String, dynamic> user) {
    currentUser = user;
  }
}

String getUserId() {
  return UserController.to.currentUser[C.ID];
}
