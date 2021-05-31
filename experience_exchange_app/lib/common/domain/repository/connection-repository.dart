import 'package:async/async.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:experience_exchange_app/common/connection-status.dart';
import 'package:experience_exchange_app/common/domain/dtos/connection/connectiondto.dart';
import 'package:flutter/cupertino.dart';

class ConnectionRepository {
  var _connectionsReference = FirebaseFirestore.instance.collection('connections');
  var _usersReference = FirebaseFirestore.instance.collection('users');

  addConnection(ConnectionDto connectionDto) async {
    await _connectionsReference.doc().set(connectionDto.toJson());
    await _usersReference.doc(connectionDto.uid2).collection('requests').doc(connectionDto.uid1).set({});
  }

  deleteConnection(ConnectionDto connectionDto) async {
    if (connectionDto.status == ConnectionStatus.Pending) {
      deleteRequest(connectionDto.uid1, connectionDto.uid2);
      deleteRequest(connectionDto.uid2, connectionDto.uid1);
    }

    await _deleteOneWay(connectionDto.uid1, connectionDto.uid2);
    await _deleteOneWay(connectionDto.uid2, connectionDto.uid1);
  }

  deleteRequest(String uid1, String uid2) async {
    await _usersReference.doc(uid1).collection('requests').doc(uid2).delete();
  }

  Future<ConnectionStatus> getStatus(String connectionId) async {
    await _connectionsReference.doc(connectionId).get().then((result) {
      return result['status']; //todo: check
    });
  }

  Future<ConnectionDto> getConnection(String requesterId, String receiverId) async {
    var snapshot = await _getConnectionOneWay(requesterId, receiverId);
    if (snapshot.docs.isEmpty) {
      snapshot = await _getConnectionOneWay(receiverId, requesterId);
    }

    if (snapshot.docs.isNotEmpty) {
      var connectionResult = snapshot.docs.first;
      return ConnectionDto(connectionResult['uid1'],
          connectionResult['uid2'],
          DateTime.tryParse(connectionResult['date']),
          statusFromString(connectionResult['status'])
      );
    }

    return ConnectionDto(null, null, null, null);
  }

  Future<QuerySnapshot> _getConnectionOneWay(String requesterId, String receiverId)  {
    return _connectionsReference
        .where('uid1', isEqualTo: requesterId)
        .where('uid2', isEqualTo: receiverId)
        .get();
  }

  _deleteOneWay(String uid1, String uid2) async {
    var snapshot = await _getConnectionOneWay(uid1, uid2);
    if (snapshot.docs.isNotEmpty) {
      await _connectionsReference.doc(snapshot.docs.first.id).delete();
    }
  }

  acceptConnection(ConnectionDto connectionDto) async {
    await deleteRequest(connectionDto.uid2, connectionDto.uid1); // here uid1 sent the request to uid2 => uid1 appears in the requests list of uid2

    var snapshot = await _getConnectionOneWay(connectionDto.uid1, connectionDto.uid2);
    if (snapshot.docs.isNotEmpty) {
      _connectionsReference.doc(snapshot.docs.first.id).set(connectionDto.toJson());
    }
  }

  getConnectionsForUid(String uid) {
    Stream stream1 = _connectionsReference
        .where('uid1', isEqualTo: uid).snapshots();
    Stream stream2 = _connectionsReference
        .where('uid2', isEqualTo: uid).snapshots();

    return StreamGroup.merge([stream1, stream2]);
  }
}