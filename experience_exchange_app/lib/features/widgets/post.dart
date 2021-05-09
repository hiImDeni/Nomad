import 'package:experience_exchange_app/common/domain/dtos/post/postdto.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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

  PostState({ this.post });

  @override
  Widget build(BuildContext context) {
    return Card();
  }
}