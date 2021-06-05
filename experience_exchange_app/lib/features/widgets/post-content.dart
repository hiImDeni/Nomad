import 'package:experience_exchange_app/common/connection-status.dart';
import 'package:experience_exchange_app/common/domain/dtos/comment/commentdto.dart';
import 'package:experience_exchange_app/common/domain/dtos/connection/connectiondto.dart';
import 'package:experience_exchange_app/common/domain/dtos/post/postdto.dart';
import 'package:experience_exchange_app/common/domain/dtos/user/userdto.dart';
import 'package:experience_exchange_app/features/pages/profile-page.dart';
import 'package:experience_exchange_app/features/widgets/user.dart';
import 'package:experience_exchange_app/logic/services/connection-service.dart';
import 'package:experience_exchange_app/logic/services/post-service.dart';
import 'package:experience_exchange_app/logic/services/user-service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'chat-input.dart';

class PostContent extends StatefulWidget {
  PostDto post;

  PostContent({@required this.post});

  @override
  State<StatefulWidget> createState() {
    return PostContentState();
  }
}

class PostContentState extends State<PostContent> {
  UserService _userService;
  PostService _postService;
  ConnectionService _connectionService;

  int upvotes, comments;
  bool isUpvoted = false;
  Color iconColor = Colors.black;

  ChatInput _chatInput;

  @override
  void initState() {
    super.initState();
    upvotes = widget.post.upvotes;
    comments = widget.post.comments;
  }

  @override
  Widget build(BuildContext context) {
    _userService = Provider.of<UserService>(context);
    _postService = Provider.of<PostService>(context);
    _connectionService = Provider.of<ConnectionService>(context);

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(widget.post.text, style: TextStyle(fontSize: 15)),
        Padding(padding: EdgeInsets.only(top: 5)),
        widget.post.mediaUrl != ''
            ? Container(
            // width: MediaQuery.of(context).size.width,
            child: Center (child: Image.network(widget.post.mediaUrl))
        )
            : Container(),
        Container(
        padding: EdgeInsets.only(left: 30, right: 30,),
        child:
          Row(
              children: [
                Column( children: [Row(
                  children: [
                    StreamBuilder(
                        stream: Stream.fromFuture(_postService.isUpvoted(widget.post.postId, _userService.currentUser.uid)),
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
                    Text(upvotes.toString()),
                  ],
                )],),

                Padding(padding: EdgeInsets.only(left: 20),),

                Column(
                  children: [Row(
                    children: [
                      IconButton(icon: Icon(Icons.comment_outlined), onPressed: () async {await _showCommentModal(); },),
                      Text(widget.post.comments.toString()),
                    ],
                  )],
                )
              ],))
      ],
    );
  }

  _handleTap() async {
    if (isUpvoted)
      return await _unvote();
    else
      return await _upvote();
  }

  _upvote() async {
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

  _comment() async {
    setState(() {
      comments = comments + 1;
    });

    var text = _chatInput.text;
    if (text.trim().isEmpty)
      return;

    _chatInput.text = '';

    await _postService.comment(widget.post.postId, _userService.currentUser.uid, text);
  }

  _showCommentModal() async {
    bool areConnected = true;

    if (_userService.currentUser.uid != widget.post.uid) {
      ConnectionDto connection = await _connectionService.getConnection(_userService.currentUser.uid, widget.post.uid);
      if (connection.status != ConnectionStatus.Accepted)
        areConnected = false;
    }

    _chatInput = ChatInput(enabled: areConnected, action: () async { await _comment(); });

    showBottomSheet(context: context, builder: (context){
      return Container(
        height: MediaQuery.of(context).size.height,

        child: Column(children: [
          Expanded(
            child: StreamBuilder(
              stream: _postService.getComments(widget.post.postId),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text(snapshot.error.toString());
                }

                if (snapshot.hasData) {
                  List<CommentDto> commentsDtos = [];

                  snapshot.data.docs.forEach((doc) {
                    commentsDtos.add(CommentDto.fromJson(doc.data()));
                  });

                  return ListView.builder(
                    shrinkWrap: true,
                    physics: BouncingScrollPhysics(),
                    itemCount: commentsDtos.length,
                    itemBuilder: (context, index) {
                      return FutureBuilder(
                          future: _userService.getById(commentsDtos[index].uid),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              UserDto user = snapshot.data;

                              return
                                Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                  UserWidget(
                                    height: 22,
                                    fontSize: 12,
                                    user: user, goToPage: () async {
                                      await Navigator.push(
                                        context, MaterialPageRoute(builder: (context) {
                                          return ProfilePage(uid: commentsDtos[index].uid);
                                        }));
                                },),

                                Container(padding: EdgeInsets.only(top: 20, left: 30),
                                    width: MediaQuery.of(context).size.width,
                                    child:
                                  Text(commentsDtos[index].text, style: TextStyle(fontSize: 15), textAlign: TextAlign.left,)
                                ),
                              ]);
                            }
                            return Center(child: CircularProgressIndicator(),);
                          });
                    },
                  );
                }

                return Center(child: CircularProgressIndicator());
              },
            ),
          ),

          Divider(),
          _chatInput,
        ])
      );
    });
  }
}