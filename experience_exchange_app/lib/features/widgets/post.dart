import 'package:experience_exchange_app/common/domain/dtos/post/postdto.dart';
import 'package:experience_exchange_app/features/widgets/post-content.dart';
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
  UserService _userService;

  @override
  Widget build(BuildContext context) {
    _userService = Provider.of<UserService>(context);

    return Card(
      child:
      Padding(
        padding: EdgeInsets.only(top: 15, bottom: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _displayPostHeader(),

            PostContent(post: widget.post),
          ],),
      ),
    );
  }

  _displayPostHeader() {
    return FutureBuilder(
        future: _userService.getById(widget.post.uid),
        builder: (context, snapshot) {
          if (snapshot.hasError)
            return Text(snapshot.error.toString());
          if (snapshot.hasData) {
            var user = snapshot.data;

            return Container(
                padding: EdgeInsets.only(left: 30, right: 30, top: 5),
                child: Column(children: [
                  Row(children: [
                    Column(
                        children: [
                          CircleAvatar(
                            backgroundImage: NetworkImage(user.photoUrl,),
                          ),]),
                    Column(
                        children: [
                          Padding(padding: EdgeInsets.only(left: 10), child:
                          Text(user.firstName + " " + user.lastName, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),),
                          ),
                        ]),
                  ],),

                  Padding(padding: EdgeInsets.only(top: 5, bottom: 5),
                    child: Divider(),
                  ),
                ])
            );
          }
          return CircularProgressIndicator();
        });
  }
}