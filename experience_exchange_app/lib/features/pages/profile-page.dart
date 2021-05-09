import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:experience_exchange_app/common/domain/dtos/post/postdto.dart';
import 'package:experience_exchange_app/features/pages/sign-in-page.dart';
import 'package:experience_exchange_app/features/widgets/main-button.dart';
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

          StreamBuilder (
            stream: FirebaseDatabase.instance.reference().child('/posts/').orderByChild('uid').equalTo(_userService.currentUser.uid).onValue,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Text(snapshot.error.toString());
              }

              if (snapshot.hasData)
              {
              // posts.clear();
              //   posts = snapshot.data;

                Map data = snapshot.data.snapshot.value;
                List item = [];

                data.forEach(
                (index, data) => item.add({"key": index, ...data}));

                return Expanded(
                  child: ListView.builder(
                  itemCount: item.length,
                  itemBuilder: (context, index) {
                    // return ListTile(
                    return Card(
                          child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text("Text: " + item[index]['text']),
                            Text("User: "+ item[index]['uid']),
                            item[index]['mediaUrl'] != ''
                                ? Container(
                                  height: 200,
                                  child: Center (child: Image.network(item[index]['mediaUrl']))
                                )
                                : Container(),

                            Text("Upvotes: " + item[index]['upvotes'].toString()),
                          ],),
                    );
                  },),
                );
  
                // return ListView.builder(
                //   shrinkWrap: true,
                //   itemCount: posts.length,
                //   itemBuilder: (BuildContext context, int index) {
                //     return Card(
                //       child: Column(
                //       crossAxisAlignment: CrossAxisAlignment.start,
                //       children: <Widget>[
                //         Text("Text: " + posts[index].text),
                //         Text("User: "+ posts[index].uid),
                //         Text("Upvotes: " + posts[index].upvotes.toString()),
                //       ],),
                //     );
                //   });
              }
              else {
                return CircularProgressIndicator();
              }
            },
          ),

          // FutureBuilder<List>(
          //     future: _postService.getByUid(user.uid),
          //     builder: (BuildContext context, AsyncSnapshot snapshot) {
          //       if (snapshot.hasError) {
          //         return Text(snapshot.error.toString());
          //       }
          //
          //       if (snapshot.hasData)
          //       {
          //         // posts.clear();
          //         posts = snapshot.data;
          //
          //         return ListView.builder(
          //             shrinkWrap: true,
          //             itemCount: posts.length,
          //             itemBuilder: (BuildContext context, int index) {
          //               return Card(
          //                 child: Column(
          //                   crossAxisAlignment: CrossAxisAlignment.start,
          //                   children: <Widget>[
          //                     Text("Text: " + posts[index].text),
          //                     Text("User: "+ posts[index].uid),
          //                     Text("Upvotes: " + posts[index].upvotes.toString()),
          //                   ],
          //                 ),
          //               );
          //             });
          //       }
          //       else
          //         return CircularProgressIndicator();
          //     }),


        ],
      ),
    );
  }
}