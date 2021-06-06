import 'package:experience_exchange_app/common/connection-status.dart';
import 'package:experience_exchange_app/common/domain/dtos/connection/connectiondto.dart';
import 'package:experience_exchange_app/common/domain/repository/connection-repository.dart';
import 'package:flutter/cupertino.dart';

class ConnectionService extends ChangeNotifier {
  ConnectionRepository _connectionRepository = ConnectionRepository();

  addConnection(String requesterId, String receiverId) async {
    ConnectionDto connection = ConnectionDto(requesterId, receiverId, DateTime.now(), ConnectionStatus.Pending);
    await _connectionRepository.addConnection(connection);
  }

  Future<ConnectionDto> getConnection(String requesterId, String receiverId) async {
    return await _connectionRepository.getConnection(requesterId, receiverId);
  }

  deleteConnection(ConnectionDto connectionDto) async {
    await _connectionRepository.deleteConnection(connectionDto);
  }

  acceptConnection(String requesterId, String receiverId) async {
    ConnectionDto connectionDto = ConnectionDto(requesterId, receiverId, DateTime.now(), ConnectionStatus.Accepted);
    await _connectionRepository.acceptConnection(connectionDto);
  }

  Future<List<ConnectionDto>> getConnectionsForUid(String uid) async {
    return await _connectionRepository.getConnectionsForUid(uid);
  }
}