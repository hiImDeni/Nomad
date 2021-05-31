import 'package:experience_exchange_app/common/domain/dtos/user/userdto.dart';
import 'package:experience_exchange_app/common/domain/repository/user-repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class UserService extends ChangeNotifier {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  final UserRepository _userRepository = UserRepository();

  Stream<User> get authStateChanges => _firebaseAuth.authStateChanges();
  User get currentUser => _firebaseAuth.currentUser;

  Future updateUserProfile(UserDto user) async {
    final uid = _firebaseAuth.currentUser.uid;

    await _firebaseAuth.currentUser.updateProfile(
        displayName: user.firstName + " " + user.lastName,
        photoURL: user.photoUrl
    );

    await _userRepository.save(uid, user);
  }

  Future<UserDto> getById(String uid) async {
    return await _userRepository.getById(uid);
  }

  Future<String> getUid(UserDto user) async {
    return await _userRepository.getUid(user);
  }

  Future<Map<String, UserDto>> searchByName(String name) async {
    return await _userRepository.search(['lastName', 'firstName'], name);
  }

  Future<Map<String, UserDto>> searchByLocation(String location) async {
    return await _userRepository.search(['location'], location);
  }

  Future<int> getNumberOfRequests(String uid) async {
    return await _userRepository.getNumberOfRequests(uid);
  }

  Stream getRequests(String uid) => _userRepository.getRequests(uid);

  Stream getUsers() => _userRepository.getUsers();
}