import 'package:apna_classroom_app/util/c.dart';
import 'package:apna_classroom_app/util/helper.dart';
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

  deleteMessage(String id) {
    int index = messages.indexWhere((element) => element[C.ID] == id);
    var message = messages[index];
    message.remove(C.MESSAGE);
    message.remove(C.CLASSROOM_ID);
    message.remove(C.EXAM_CONDUCTED);
    message.remove(C.NOTE);
    message.remove(C.MEDIA);
    messages[index] = message;
  }
}

// TODO: -- Map this correctly
mapMessages(List messages) {
  int messagesLength = messages.length;
  if (messagesLength < 2) return messages;

  List _messages = [];
  for (int i = 1; i < messagesLength; i++) {
    var thisMessage = messages[i];
    var nextMessage = messages[i - 1];

    String thisCreatorId = messageCreatedById(thisMessage[C.CREATED_BY]);
    String nextCreatorId = messageCreatedById(nextMessage[C.CREATED_BY]);

    if (thisCreatorId == nextCreatorId) {
      nextMessage[C.SAME_USER] = true;
    }
    nextMessage[C.IS_ME] = isCreator(nextCreatorId);
    _messages.add(nextMessage);
  }

  return _messages;
}

String messageCreatedById(createdBy) {
  if (createdBy == null) return null;
  String creatorId;
  if (createdBy.runtimeType == String) {
    creatorId = createdBy;
  } else {
    creatorId = createdBy[C.ID];
  }
  return creatorId;
}
