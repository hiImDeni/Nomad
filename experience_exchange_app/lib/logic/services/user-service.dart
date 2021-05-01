import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:experience_exchange_app/common/domain/dtos/userdto.dart';
import 'package:experience_exchange_app/common/domain/repository/database_layer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class UserService extends ChangeNotifier {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  final UserRepository repository = new UserRepository(); //TODO: dependency injection

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
}