import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:experience_exchange_app/common/domain/dtos/chat/chatdto.dart';
import 'package:experience_exchange_app/common/domain/dtos/message/messagedto.dart';

class ChatRepository{
  var _dbReference = FirebaseFirestore.instance.collection('chats');

  Future<String> createChat(ChatDto chat) async {
    var chatId = _dbReference.doc().id;
    await _dbReference.doc(chatId).set(chat.toJson()).then((value) {
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
    var snapshot = await _dbReference.where('uid1', isEqualTo: uid1)
        .where('uid2', isEqualTo: uid2).get();
    if (snapshot.docs.isNotEmpty)
      return snapshot.docs.first.id;

    snapshot = await _dbReference.where('uid1', isEqualTo: uid2)
        .where('uid2', isEqualTo: uid1).get();
    if (snapshot.docs.isNotEmpty)
      return snapshot.docs.first.id;

    return null;
  }

  
  // addUsers(String chatId, String uid1, String uid2) {
  //   _dbReference.child('/chats/$chatId/uids/$uid1-$uid2').push(); //??
  //   // return await _dbReference.child('/chats/$chatId/uids/$key').set(uid);
  // }

  addMessage(String chatId, MessageDto message) async {
    return await _dbReference.doc(chatId).collection('messages').doc().set(message.toJson());
  }

  getMessages(String chatId) => _dbReference.doc(chatId).collection('messages').orderBy('date').snapshots();
  
  Stream getByUid1(String uid) => _dbReference.where('uid1', isEqualTo: uid).snapshots();
  Stream getByUid2(String uid) => _dbReference.where('uid2', isEqualTo: uid).snapshots();

  // Stream getByUid(String uid) => StreamGroup.merge()
}