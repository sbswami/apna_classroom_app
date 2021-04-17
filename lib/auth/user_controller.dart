import 'package:apna_classroom_app/util/c.dart';
import 'package:get/get.dart';

class UserController extends GetxController {
  final currentUser = <String, dynamic>{}.obs;

  static UserController get to => Get.find<UserController>();

  void updateUser(Map<String, dynamic> user) {
    currentUser.assignAll(user);
  }
}

String getUserId() {
  return UserController.to.currentUser[C.ID];
}

// bool isCreator(String id) {
//   return getUserId() == id;
// }
