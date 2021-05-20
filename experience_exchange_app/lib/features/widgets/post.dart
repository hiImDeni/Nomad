import 'package:experience_exchange_app/common/domain/dtos/post/postdto.dart';
import 'package:experience_exchange_app/common/domain/dtos/upvote/upvotedto.dart';
import 'package:experience_exchange_app/common/domain/dtos/user/userdto.dart';
import 'package:experience_exchange_app/logic/services/post-service.dart';
import 'package:experience_exchange_app/logic/services/upvote-repository.dart';
import 'package:experience_exchange_app/logic/services/user-service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Post extends StatefulWidget {
  PostDto post;

  Post({ this.post });

  @override
  State<StatefulWidget> createState() {
    return PostState(post: post);
  }

}

class PostState extends State<Post> {
  PostDto post;
  UserService _userService;
  UpvoteService _upvoteService;
  PostService _postService;
  bool isUpvoted;

  Icon _upvoteIcon;

  PostState({ this.post });

  @override
  void initState() {
    // isUpvoted = _upvoteService.getUpvote(postId, uid);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _userService = Provider.of<UserService>(context);
    _upvoteService = Provider.of<UpvoteService>(context);
    _postService = Provider.of<PostService>(context);

    return Card(
      child:
      Padding(
        padding: EdgeInsets.only(left: 30, right: 30, top: 15, bottom: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
          FutureBuilder(
            future: _userService.getById(post.uid),
            builder: (context, snapshot) {
              if (snapshot.hasError)
                return Text(snapshot.error.toString());
              if (snapshot.hasData) {
                var user = snapshot.data;
                return Row(children: [
                Column(
                children: [
                 CircleAvatar(
                   backgroundImage: NetworkImage(user.photoUrl,),
                 ),]),
                  Column(
                    children: [
                     Padding(padding: EdgeInsets.only(left: 10), child:
                          Text(user.firstName + " " + user.lastName, style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),),
                     ),
                      // Padding(padding: EdgeInsets.only(left: 15), child:
                      //   Text(user.location, style: TextStyle(fontSize: 13, fontWeight: FontWeight.normal))
                      // ),
                    ]),
                  ],);
              }
              return CircularProgressIndicator();
          }),
            Padding(padding: EdgeInsets.only(top: 5, bottom: 5),
              child: Divider(),
            ),

            Text(post.text, style: TextStyle(fontSize: 15)),
            Padding(padding: EdgeInsets.only(top: 15)),
            post.mediaUrl != ''
                ? Container(
                height: 170,
                child: Center (child: Image.network(post.mediaUrl))
            )
                : Container(),
            Row(
              children: [
                Column( children: [Row(
                  children: [
                    // FutureBuilder(
                    //     future: _upvoteService.getUpvote(post.postId, uid),
                    //     builder: (context, snapshot) {
                    //       return IconButton(icon: Icon(Icons.favorite_outline_rounded),
                    //         onPressed: _upvote(),);
                    //     }),
                    IconButton(icon: Icon(Icons.favorite_outline_rounded), onPressed: () async { await _upvote(); },),
                    Text(post.upvotes.toString()),
                  ],
                )],

                ),
                Column(
                  children: [Row(
                    children: [
                      IconButton(icon: Icon(Icons.comment_outlined), onPressed: _comment(),),
                      Text(post.upvotes.toString()),
                    ],
                  )],
                )
              ],
            )

          ],),
      ),
    );
  }

  _upvote() async {
    post.upvotesDtos.add(UpvoteDto(post.postId, _userService.currentUser.uid));
    post.upvotes += 1;
    await _postService.update(post);

  }

  _comment() {}
}