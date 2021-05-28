import 'package:experience_exchange_app/common/connection-status.dart';
import 'package:experience_exchange_app/common/domain/dtos/connection/connectiondto.dart';
import 'package:experience_exchange_app/common/domain/repository/connection-repository.dart';
import 'package:flutter/cupertino.dart';

class ConnectionService extends ChangeNotifier {
  ConnectionRepository _connectionRepository = ConnectionRepository();

  addConnection(String uid1, String uid2) async {
    ConnectionDto connection = ConnectionDto(uid1, uid2, DateTime.now(), ConnectionStatus.Pending);
    await _connectionRepository.addConnection(connection);
  }

  Future<ConnectionDto> getConnection(String uid1, String uid2) async {
    return await _connectionRepository.getConnection(uid1, uid2);
  }

  deleteConnection(ConnectionDto connectionDto) async {
    await _connectionRepository.deleteConnection(connectionDto);
  }
}