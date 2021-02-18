import 'package:apna_classroom_app/util/c.dart';
import 'package:get/get.dart';

class ChatMessagesController extends GetxController {
  var messages = [].obs;
  var classroomId = "".obs;

  static ChatMessagesController get to => Get.find<ChatMessagesController>();

  newChat(String classroomId) {
    this.classroomId = classroomId.obs;
    this.messages = [].obs;
  }

  insertMessages(List _messages) {
    this.messages.insertAll(0, _messages);
  }

  addMessages(List _messages) {
    this.messages.addAll(_messages);
  }

  updateMessageObj(String id, newMessage) {
    int index = messages.indexWhere((element) => element[C.ID] == id);
    messages[index] = newMessage;
  }
}
