import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthenticationService extends ChangeNotifier {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestoreDb = FirebaseFirestore.instance;
  final googleSignIn = GoogleSignIn();

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

  void signOut() async {
    // await googleSignIn.disconnect();
    await FirebaseAuth.instance.signOut();
  }

  Future updateUserProfile(String firstName, String lastName, String photoUrl) async {
    _firebaseAuth.currentUser.updateProfile(
      displayName: firstName + " " + lastName,
      photoURL: photoUrl
    );
  }
}