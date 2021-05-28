import 'package:experience_exchange_app/common/domain/dtos/user/userdto.dart';
import 'package:experience_exchange_app/common/domain/repository/user-repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class UserService extends ChangeNotifier {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  final UserRepository repository = UserRepository(); //TODO: dependency injection

  Stream<User> get authStateChanges => _firebaseAuth.authStateChanges();
  User get currentUser => _firebaseAuth.currentUser;

  Future updateUserProfile(UserDto user) async {
    final uid = _firebaseAuth.currentUser.uid;

    await _firebaseAuth.currentUser.updateProfile(
        displayName: user.firstName + " " + user.lastName,
        photoURL: user.photoUrl
    );

    await repository.save(uid, user);
  }

  Future<UserDto> getById(String uid) async {
    return await repository.getById(uid);
  }

  Future<String> getUid(UserDto user) async {
    return await repository.getUid(user);
  }

  Future<Map<String, UserDto>> searchByName(String name) async {
    return await repository.search(['lastName', 'firstName'], name);
  }

  Future<Map<String, UserDto>> searchByLocation(String location) async {
    return await repository.search(['location'], location);
  }

  Stream getUsers() => repository.getUsers();
}