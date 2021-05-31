import 'package:experience_exchange_app/common/domain/dtos/post/postdto.dart';
import 'package:experience_exchange_app/common/domain/dtos/user/userdto.dart';
import 'package:experience_exchange_app/features/pages/profile-page.dart';
import 'package:experience_exchange_app/features/widgets/post.dart';
import 'package:experience_exchange_app/features/widgets/user.dart';
import 'package:experience_exchange_app/logic/services/connection-service.dart';
import 'package:experience_exchange_app/logic/services/post-service.dart';
import 'package:experience_exchange_app/logic/services/user-service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../scheme.dart';

class NewsfeedPage extends StatefulWidget {
  const NewsfeedPage();

  @override
  State<StatefulWidget> createState() {
    return NewsfeedPageState();
  }

}

class NewsfeedPageState extends State<NewsfeedPage> {
  UserService _userService;
  ConnectionService _connectionService;
  PostService _postService;

  TextEditingController _textEditingController = TextEditingController();

  Future<Map<String, UserDto>> _usersFuture;

  @override
  Widget build(BuildContext context) {
    final User firebaseUser = context.watch<User>();

    _userService = Provider.of<UserService>(context);
    _connectionService = Provider.of<ConnectionService>(context);
    _postService = Provider.of<PostService>(context);

    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Padding(padding: EdgeInsets.only(top: 20),),
          StreamBuilder(
              stream: _connectionService.getConnectionsForUid(firebaseUser.uid),
              builder: (context, snapshot){
                if (snapshot.hasError)
                  return Text(snapshot.error.toString());

                if (snapshot.hasData) {
                  List<String> uids = [];

                  snapshot.data.docs.forEach((doc) {
                    if (doc.data()['uid1'] != firebaseUser.uid)
                      uids.add(doc.data()['uid1']);
                    else
                      uids.add(doc.data()['uid2']);
                  });

                  return Expanded(
                    child: StreamBuilder(
                      stream: _postService.getByUids(uids),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return Text(snapshot.error.toString());
                        }

                        if (snapshot.hasData) {
                          List posts = [];

                          snapshot.data.docs.forEach((doc) {
                            posts.add(PostDto.fromJson(doc.data()));
                          });

                          return ListView.builder(
                            shrinkWrap: true,
                            physics: BouncingScrollPhysics(),
                            itemCount: posts.length,
                            itemBuilder: (context, index) {
                              if (index == posts.length - 1) {
                                return Padding(padding: EdgeInsets.only(bottom: 30),
                                    child: Post(post: posts[index])
                                );
                              }

                              return Post(post: posts[index]);
                            },
                          );
                        }

                        return Center(child: CircularProgressIndicator());
                      },
                    ),);
                }
                return Container();
              })
        ]
      )
    );
  }

  _showFriendsPost() {
    return Container();
  }
}