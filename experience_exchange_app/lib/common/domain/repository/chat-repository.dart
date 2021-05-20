import 'package:experience_exchange_app/common/domain/dtos/chat/chatdto.dart';
import 'package:experience_exchange_app/common/domain/dtos/message/messagedto.dart';
import 'package:firebase_database/firebase_database.dart';

class ChatRepository{
  var _dbReference = FirebaseDatabase.instance.reference();

  Future<String> createChat(ChatDto chat) async {
    var chatId = _dbReference.child('/chats').push().key;
    await _dbReference.child('/chats/$chatId').set(chat.toJson()).then((value) {
      return chatId;
    });
  }

  // Future<String> getChat(String uid1, String uid2) async {
  //     var key = await _getChatOneWay(uid1, uid2);
  //     return key;
  //
  //     return await _getChatOneWay(uid2, uid1).then((value) { return value; });
  // }

  Future<String> getChat(String uid1, String uid2) async {
    var snapshot = await _dbReference.child('chats').once().then((element) {
            var model = element.value;
            String chatId;
            if (model != null) {
              model.forEach((key, value) {
                if (value['uid1'] == uid1 && value['uid2'] == uid2) {
                  chatId = key; //??
                  return chatId;
                } else if (value['uid1'] == uid2 && value['uid2'] == uid1) {
                  chatId = key; //??
                  return chatId;
                }
              });
            }
            return chatId;
      });
  }

  
  // addUsers(String chatId, String uid1, String uid2) {
  //   _dbReference.child('/chats/$chatId/uids/$uid1-$uid2').push(); //??
  //   // return await _dbReference.child('/chats/$chatId/uids/$key').set(uid);
  // }

  addMessage(String chatId, MessageDto message) async {
    String key = _dbReference.child('/chats/$chatId/messages').push().key;
    return await  _dbReference.child('/chats/$chatId/messages/$key').set(message);
  }
}