import 'package:apna_classroom_app/api/user_details.dart';
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
    int classroomIndex =
        classrooms.indexWhere((element) => element[C.ID] == id);
    var classroom = classrooms[classroomIndex];
    classrooms.removeAt(classroomIndex);
    classroom[C.MESSAGE] = message;
    classroom[C.UPDATED_AT] = DateTime.now().toString();
    if (setUnseen) ++classroom[C.UNSEEN];
    classrooms.insert(0, classroom);
  }

  // unseen set to zero
  setUnseen(String id, {int unseen}) async {
    // update UNSEEN on API
    await unseenUserDetails({C.CLASSROOM: id});

    int index = classrooms.indexWhere((element) => element[C.ID] == id);
    var classroom = classrooms[index];
    classroom[C.UNSEEN] = unseen ?? 0;
    classrooms[index] = classroom;
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
