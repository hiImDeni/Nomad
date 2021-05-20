import 'package:experience_exchange_app/common/domain/dtos/message/messagedto.dart';
import 'package:experience_exchange_app/common/domain/dtos/user/userdto.dart';
import 'package:experience_exchange_app/features/widgets/chat-input.dart';
import 'package:experience_exchange_app/logic/services/chat-service.dart';
import 'package:experience_exchange_app/logic/services/user-service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Chat extends StatefulWidget{
  UserDto user;
  String uid2;
  String chatId;
  // UserDto user2;

  Chat({this.chatId, this.uid2, this.user});

  @override
  State<StatefulWidget> createState() {
    return ChatState();
  }

}

class ChatState extends State<Chat>{
  User current;

  UserService _userService;
  ChatService _chatService;

  ChatInput _chatInput;

  @override
  Widget build(BuildContext context) {
    _chatService = Provider.of<ChatService>(context);
    _userService = Provider.of<UserService>(context);
    current = _userService.currentUser;

    _chatInput = ChatInput(action: () async { await _sendMessage(); });


    return Scaffold(
        body: Container(
          margin: EdgeInsets.only(left: 15, right: 15),
          height: MediaQuery
              .of(context).size.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SafeArea(
                child: Padding(
                    padding: EdgeInsets.only(top:10, bottom: 10),
                    child: Row(
                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                        Padding(padding: EdgeInsets.only(left: 10, right: 10), child:
                        CircleAvatar(backgroundImage: NetworkImage(widget.user.photoUrl),),
                        ),
                        Text(widget.user.firstName,
                          style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                        ),
                    ],
                  )
                )
              ),
              SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: StreamBuilder(
                  stream: FirebaseDatabase.instance.reference().child('/chats/${widget.chatId}/messages').onValue,
                  builder: (context, snapshot){
                      if (snapshot.hasError)
                        return Text(snapshot.error.toString());
                      return CircularProgressIndicator();
                  },
                ),
              ),
    // _loadMessages(),
              Spacer(),
              _chatInput,

            ]
          ),
        )
    );
  }

  _loadMessages() {
    return StreamBuilder(
      stream: FirebaseDatabase.instance.reference().child('/chats/').onValue,
      builder: (context, snapshot) {
        return CircularProgressIndicator();
      });
  }

  _sendMessage() async {
    // var text = _chatInput.text;
    // MessageDto message = MessageDto(current.uid, widget.uid2, text, DateTime.now());
    //
    // await _chatService.addMessage(widget.chatId, message);
  }
}