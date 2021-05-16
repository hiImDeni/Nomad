import 'package:cloud_firestore/cloud_firestore.dart';
import 'file:///E:/faculta/Licenta/bachelor-thesis/experience_exchange_app/lib/common/domain/dtos/user/userdto.dart';
import 'package:experience_exchange_app/common/domain/repository/user-repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthenticationService extends ChangeNotifier {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final googleSignIn = GoogleSignIn();
  final UserRepository repository = UserRepository(); //TODO: dependency injection

  Stream<User> get authStateChanges => _firebaseAuth.authStateChanges();
  User get currentUser => _firebaseAuth.currentUser;

  bool _isSigningIn;
  bool get isSigningIn => _isSigningIn;
  set isSigningIn(bool isSigningIn) {
    _isSigningIn = isSigningIn;
    notifyListeners();
  }

  AuthenticationService() { _isSigningIn = false; }

  Future<UserCredential> signIn({String email, String password}) async{
      UserCredential user = await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
      return user;
  }

  Future<UserCredential> signUp({String email, String password}) async{
      UserCredential user = await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
      return user;
  }

  Future<UserCredential> signInWithGoogle() async {
    final googleAccount = await googleSignIn.signIn();
    if (googleAccount == null) {
      isSigningIn = false;
      return null;
    }
    else {
      final googleAuth = await googleAccount.authentication;
      final credentials = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken
      );
      UserCredential user = await FirebaseAuth.instance.signInWithCredential(credentials);

      isSigningIn = false;
      return user;
    }
   }

  Future<UserCredential> signUpWithGoogle() async {
    final googleAccount = await googleSignIn.signIn();
    if (googleAccount == null) {
      isSigningIn = false;
      return null;
    }
    else {
      final googleAuth = await googleAccount.authentication;
      final credentials = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken
      );
      UserCredential user = await FirebaseAuth.instance.signInWithCredential(credentials);
      _addUserProfile();

      isSigningIn = false;
      return user;
    }
  }

  void signOut() async {
    // await googleSignIn.disconnect();
    await FirebaseAuth.instance.signOut();
  }

  Future _addUserProfile() async {
    final uid = _firebaseAuth.currentUser.uid;

    await repository.save(uid, UserDto('', '', '', null, null));
  }
}