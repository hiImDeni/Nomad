import 'package:async/async.dart';
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

  Future<String> getChat(String uid1, String uid2) async {
    var key = await _chatRepository.getChat(uid1, uid2);
    return key;
  }

  addMessage(String chatId, MessageDto message) async {
    return await _chatRepository.addMessage(chatId, message);
  }

  Stream getMessages(String chatId) => _chatRepository.getMessages(chatId);

  Stream getChats(String uid) => _chatRepository.getByUid(uid);
}