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

  Future<List<UserDto>> searchByName(String name) async {
    await repository.searchByName(name).then((value) {
      return value;
    });
  }
}