import 'package:experience_exchange_app/common/domain/dtos/chat/chatdto.dart';
import 'package:experience_exchange_app/common/domain/dtos/message/messagedto.dart';
import 'package:experience_exchange_app/common/domain/repository/chat-repository.dart';
import 'package:flutter/cupertino.dart';

class ChatService extends ChangeNotifier {
  ChatRepository _chatRepository = ChatRepository();

  Future<String> createChat(String uid1, String uid2) async {
    ChatDto chat = ChatDto([uid1, uid2]);
    await _chatRepository.createChat(chat).then((value) {
      return value;
    });
  }

  Future getChat(String uid1, String uid2) async {
    return await _chatRepository.getChat(uid1, uid2);
  }

  addMessage(String chatId, MessageDto message) async {
    return await _chatRepository.addMessage(chatId, message);
  }

  Stream getMessages(String chatId) => _chatRepository.getMessages(chatId);

  Stream getChats(String uid) => _chatRepository.getByUid(uid);
}