import 'package:experience_exchange_app/features/pages/profile-page.dart';
import 'package:experience_exchange_app/logic/services/user-service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PostHeader extends StatefulWidget {
  String uid;

  PostHeader({@required this.uid});

  @override
  State<StatefulWidget> createState() {
    return PostHeaderState();
  }
}

class PostHeaderState extends State<PostHeader> {
  UserService _userService;

  @override
  Widget build(BuildContext context) {
    _userService = Provider.of<UserService>(context);

    return FutureBuilder(
        future: _userService.getById(widget.uid),
        builder: (context, snapshot) {
          if (snapshot.hasError)
            return Text(snapshot.error.toString());
          if (snapshot.hasData) {
            var user = snapshot.data;

            return GestureDetector(
                onTap: () async {
                  await Navigator.push(context, MaterialPageRoute(builder: (context) { return ProfilePage(uid: widget.uid); }));
                },
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