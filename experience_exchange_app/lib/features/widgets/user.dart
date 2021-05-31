import 'package:experience_exchange_app/common/domain/dtos/user/userdto.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UserWidget extends StatefulWidget{
  UserDto user;
  Function goToPage;
  double height, fontSize;


  UserWidget({this.user, this.goToPage, this.height, this.fontSize});

  @override
  State<StatefulWidget> createState() {
    return UserState();
  }

}

class UserState extends State<UserWidget> {
  double height, fontSize;

  @override
  void initState() {
    super.initState();

    height = widget.height != null ? widget.height : 55;
    fontSize = widget.fontSize != null ? widget.fontSize : 15;

  }

  @override
  Widget build(BuildContext context) {
    return Container(height: height,
      child:
      ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(widget.user.photoUrl),),
      title: Text(widget.user.firstName + " " + widget.user.lastName, style: TextStyle(fontSize: fontSize),),
      onTap: widget.goToPage,
    ));
  }

}