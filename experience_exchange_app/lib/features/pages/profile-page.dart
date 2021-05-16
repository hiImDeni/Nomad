import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:experience_exchange_app/common/domain/dtos/post/postdto.dart';
import 'package:experience_exchange_app/features/pages/sign-in-page.dart';
import 'package:experience_exchange_app/features/widgets/main-button.dart';
import 'package:experience_exchange_app/features/widgets/post.dart';
import 'package:experience_exchange_app/logic/services/post-service.dart';
import 'package:experience_exchange_app/logic/services/user-service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
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
  List<PostDto> posts;

  UserService _userService;
  PostService _postService;

  ProfilePageState({this.user});



  @override
  Widget build(BuildContext context) {
    _userService  = Provider.of<UserService>(context);
    _postService = Provider.of<PostService>(context);

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

    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Padding(padding: EdgeInsets.only(top: 70)),

          CircularProfileAvatar(
            "",
            child: ClipOval(child: Image.network(user.photoURL)),
          ),
          Padding(padding: EdgeInsets.only(top: 10, bottom: 15), child:
            Title(color: Colors.black, child: Text(user.displayName, style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),)),
          ),

          StreamBuilder (
            stream: FirebaseDatabase.instance.reference().child('/posts/').orderByChild('uid').equalTo(_userService.currentUser.uid).onValue,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Text(snapshot.error.toString());
              }

              if (snapshot.hasData)
              {
                Map data = snapshot.data.snapshot.value;
                List posts = [];

                data.forEach(
                (index, data) => posts.add({"key": index, ...data}));

                return Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: posts.length,
                    itemBuilder: (context, index) {
                      // return ListTile(
                      PostDto post = PostDto(
                          // posts[index]['postId'],
                          posts[index]['uid'],
                          posts[index]['mediaUrl'],
                          posts[index]['text'],
                          posts[index]['upvotes'],
                          // posts[index]['upvoteDtos']
                      );
                      return Post(post: post);
                  },),
                );
              }
              else {
                return CircularProgressIndicator();
              }
            },
          ),
        ],
    );
  }
}