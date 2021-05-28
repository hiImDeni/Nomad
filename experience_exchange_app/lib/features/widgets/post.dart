import 'package:experience_exchange_app/common/domain/dtos/post/postdto.dart';
import 'package:experience_exchange_app/logic/services/post-service.dart';
import 'package:experience_exchange_app/logic/services/user-service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Post extends StatefulWidget {
  PostDto post;
  bool isUpvoted;

  Post({ this.post });

  @override
  State<StatefulWidget> createState() {
    return PostState(post: post);
  }

}

class PostState extends State<Post> {
  PostDto post;
  UserService _userService;
  PostService _postService;
  int upvotes = 0;
  bool isUpvoted = false;
  Color iconColor = Colors.black;

  Icon _upvoteIcon;

  PostState({ this.post });

  @override
  Widget build(BuildContext context) {
    _userService = Provider.of<UserService>(context);
    _postService = Provider.of<PostService>(context);

    upvotes = widget.post.upvotes;

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
                    FutureBuilder(
                        future: _postService.isUpvoted(post.postId, _userService.currentUser.uid),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            isUpvoted = snapshot.data;
                            iconColor = isUpvoted ? Colors.redAccent : Colors.black;
                          }
                          return IconButton(icon: Icon(
                            Icons.favorite_outline_rounded,
                            color: iconColor,),
                            onPressed: () async {
                              await _handleTap();
                            },);
                        }),
                    // IconButton(icon: Icon(Icons.favorite_outline_rounded), onPressed: () async { await _upvote(); },),
                    Text(upvotes.toString()),
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

  _handleTap() async {
    if (isUpvoted)
      return await _unvote();
    else
      return await _upvote();
  }

  _upvote() async {
    // post.upvotesDtos.add(UpvoteDto(post.postId, _userService.currentUser.uid));
    // post.upvotes += 1;
    setState(() {
      upvotes = upvotes + 1;
      isUpvoted = true;
      iconColor = Colors.redAccent;
    });
    return await _postService.upvote(widget.post.postId, _userService.currentUser.uid);
  }

  _unvote() async {
    setState(() {
      upvotes = upvotes - 1;
      isUpvoted = false;
      iconColor = Colors.black;
    });
    return await _postService.unvote(widget.post.postId, _userService.currentUser.uid);
  }

  _comment() {}
}