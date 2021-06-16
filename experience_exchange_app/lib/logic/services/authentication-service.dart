import 'package:experience_exchange_app/common/domain/dtos/user/userdto.dart';
import 'package:experience_exchange_app/common/domain/repository/user-repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthenticationService extends ChangeNotifier {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final googleSignIn = GoogleSignIn();
  final UserRepository repository = UserRepository();

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

      var userDto = await repository.getById(currentUser.uid);
      if (userDto == null) {
        await _addUserProfile();
      }

      isSigningIn = false;
      return user;
    }
   }

  void signOut() async {
    if ( _firebaseAuth.currentUser.providerData.length == 2) {
      print(_firebaseAuth.currentUser.providerData[1].providerId);
      if (_firebaseAuth.currentUser.providerData[1].providerId == 'google.com' )
        await googleSignIn.disconnect();
    }
    print(_firebaseAuth.currentUser.providerData[0].providerId);

    await FirebaseAuth.instance.signOut();
  }

  Future _addUserProfile() async {
    final uid = _firebaseAuth.currentUser.uid;
    final name = _firebaseAuth.currentUser.displayName.split(' ');

    await repository.save(uid, UserDto(name[0], name[1], '', DateTime(2000, 1, 1), _firebaseAuth.currentUser.photoURL));
  }
}