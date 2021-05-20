import 'package:experience_exchange_app/common/domain/dtos/user/userdto.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UserWidget extends StatefulWidget{
  UserDto user;
  Function goToPage;


  UserWidget({this.user, this.goToPage});

  @override
  State<StatefulWidget> createState() {
    return UserState();
  }

}

class UserState extends State<UserWidget> {
  UserState();

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(backgroundImage: NetworkImage(widget.user.photoUrl),),
      title: Text(widget.user.firstName + " " + widget.user.lastName),
      onTap: widget.goToPage,
    );
  }

}