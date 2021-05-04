import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:experience_exchange_app/features/pages/sign-in-page.dart';
import 'package:experience_exchange_app/features/widgets/main-button.dart';
import 'package:experience_exchange_app/logic/services/user-service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'create-post-page.dart';

class ProfilePage extends StatefulWidget {
  final User user;

  const ProfilePage({this.user});

  @override
  State<StatefulWidget> createState() {
    return ProfilePageState(user: user);
  }

}

class ProfilePageState extends State<ProfilePage> {
  User user;
  UserService _userService;

  ProfilePageState({this.user});



  @override
  Widget build(BuildContext context) {
    _userService  = Provider.of<UserService>(context);

    if (_userService.currentUser == null) {
      Navigator.pushReplacement(context,
          MaterialPageRoute(
              builder: (context) {
                return SignInPage();
              }));
    }
    if (user == null) {
      user = _userService.currentUser;

    }

    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Padding(padding: EdgeInsets.only(top: 100)),

          CircularProfileAvatar(
            "",
            child: ClipOval(child: Image.network(user.photoURL)),
          ),

          Padding(padding: EdgeInsets.only(top: 10, bottom: 10)),
          Title(color: Colors.black, child: Text(user.displayName, style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),)),
        ],
      ),
    );
  }
}