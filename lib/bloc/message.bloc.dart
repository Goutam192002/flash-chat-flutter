import 'dart:async';

import 'package:flash_chat/models/message.dart';
import 'package:flash_chat/providers/database.dart';

class MessageBloc {
  String conversationId;

  MessageBloc(this.conversationId) {
    getMessages();
  }

  final _messagesController = StreamController<List<MessageModel>>.broadcast();
  Stream<List<MessageModel>> get messages => _messagesController.stream;

  _dispose() {
    _messagesController.close();
  }

  getMessages() async {
    _messagesController.sink
        .add(await DatabaseProvider.db.getConversationMessages(conversationId));
  }

  addMessage(MessageModel message) async {
    DatabaseProvider.db.createNewMessage(message);
    getMessages();
  }

  updateMessage(MessageModel message) async {
    DatabaseProvider.db.updateMessage(message);
    getMessages();
  }

  deleteMessage(String messageID) async {
    DatabaseProvider.db.deleteMessage(messageID);
    getMessages();
  }
}
