import 'package:experience_exchange_app/common/domain/dtos/post/postdto.dart';
import 'package:experience_exchange_app/features/pages/profile-page.dart';
import 'package:experience_exchange_app/features/widgets/post-content.dart';
import 'package:experience_exchange_app/features/widgets/post-header.dart';
import 'package:experience_exchange_app/logic/services/post-service.dart';
import 'package:experience_exchange_app/logic/services/user-service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Post extends StatefulWidget {
  PostDto post;

  Post({ this.post });

  @override
  State<StatefulWidget> createState() {
    return PostState();
  }

}

class PostState extends State<Post> {
  PostState();

  @override
  Widget build(BuildContext context) {
    return Card(
      child:
      Padding(
        padding: EdgeInsets.only(left: 30, right: 30, top: 15, bottom: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            PostHeader(uid: widget.post.uid),

            PostContent(post: widget.post),
          ],),
      ),
    );
  }
}