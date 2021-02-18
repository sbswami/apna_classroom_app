import 'package:apna_classroom_app/util/c.dart';
import 'package:get/get.dart';

class ClassroomListController extends GetxController {
  var classrooms = [].obs;

  static ClassroomListController get to => Get.find<ClassroomListController>();

  // reset classrooms
  resetClassrooms() {
    classrooms.clear();
  }

  // Add Message
  addMessage(String id, message, {bool setUnseen = false}) {
    int index = classrooms.indexWhere((element) => element[C.ID] == id);
    classrooms[index][C.MESSAGE] = message;
    if (setUnseen) ++classrooms[index][C.UNSEEN];
  }

  // unseen set to zero
  setUnseen(String id, int unseen) {
    int index = classrooms.indexWhere((element) => element[C.ID] == id);
    classrooms[index][C.UNSEEN] = unseen ?? 0;
  }

  // add Classrooms
  addClassrooms(List _classrooms) {
    this.classrooms.addAll(_classrooms);
  }

  // update Classroom
  updateClassroom(String id, newClassroom) {
    int index = classrooms.indexWhere((element) => element[C.ID] == id);
    classrooms[index] = newClassroom;
  }

  // Insert Classroom
  insertClassrooms(List _classrooms) {
    this.classrooms.insertAll(0, _classrooms);
  }
}
