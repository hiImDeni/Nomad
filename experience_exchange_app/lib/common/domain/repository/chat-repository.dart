import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:experience_exchange_app/common/domain/dtos/chat/chatdto.dart';
import 'package:experience_exchange_app/common/domain/dtos/message/messagedto.dart';

class ChatRepository{
  var _dbReference = FirebaseFirestore.instance.collection('chats');

  Future createChat(ChatDto chat) async {
    return await _dbReference.add(chat.toJson());
  }

  Future<String> getChat(String uid1, String uid2) async {
    var snapshot = await _dbReference
        .where('uids', isEqualTo: [uid1, uid2]).get();
    if (snapshot.docs.isNotEmpty)
      return snapshot.docs.first.id;
    snapshot = await _dbReference
        .where('uids', isEqualTo: [uid2, uid1]).get();
    if (snapshot.docs.isNotEmpty)
      return snapshot.docs.first.id;

    return null;
  }

  addMessage(String chatId, MessageDto message) async {
    await _dbReference.doc(chatId).collection('messages').doc().set(message.toJson()).then((value) { return chatId; });
  }

  getMessages(String chatId) => _dbReference.doc(chatId).collection('messages').orderBy('date', descending: true).snapshots();
  
  Stream getByUid1(String uid) => _dbReference.where('uid1', isEqualTo: uid).snapshots();
  Stream getByUid2(String uid) => _dbReference.where('uid2', isEqualTo: uid).snapshots();

  Stream getByUid(String uid) => _dbReference.where('uids', arrayContains: uid).snapshots();
}