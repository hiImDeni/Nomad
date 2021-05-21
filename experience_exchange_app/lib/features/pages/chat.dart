import 'package:experience_exchange_app/common/domain/dtos/message/messagedto.dart';
import 'package:experience_exchange_app/common/domain/dtos/user/userdto.dart';
import 'package:experience_exchange_app/features/scheme.dart';
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
            color: Scheme.backgroundColor,
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
              Padding(padding: EdgeInsets.only(top: 3, bottom: 3),
                child: Divider(),
              ),

              Expanded(child:
              StreamBuilder(
                  stream: _chatService.getMessages(widget.chatId),
                  builder: (context, snapshot){
                      if (snapshot.hasError)
                        return Text(snapshot.error.toString());

                      if (snapshot.hasData) {
                        List messages = [];

                        snapshot.data.docs.forEach((doc) {
                          messages.add(MessageDto(doc.data()['uid1'], doc.data()['uid2'], doc.data()['text'], DateTime.tryParse(doc.data()['date'])));
                        });

                        return
                          // SingleChildScrollView(
                          // physics: BouncingScrollPhysics(),
                          // child:
                          ListView.builder(
                            shrinkWrap: true,
                            physics: BouncingScrollPhysics(),
                            itemCount: messages.length,
                            itemBuilder: (context, index) {

                              return Container(
                                padding: EdgeInsets.only(left: 14,right: 14,top: 3,bottom: 3),
                                child: Align(
                                  alignment: (messages[index].uid1 == current.uid ? Alignment.topRight : Alignment.topLeft),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: (messages[index].uid1 == current.uid ? Scheme.inputColor : Colors.grey.shade300),
                                    ),
                                    padding: EdgeInsets.all(16),
                                    child: Text(messages[index].text, style: TextStyle(fontSize: 15),),
                                  ),
                                ),
                              );


                              // return Post(post: posts[index]);
                            },//),
                        );
                      }

                      return CircularProgressIndicator();
                  },
                )),
    // _loadMessages(),
    //           Spacer(),
              Divider(),
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
    var text = _chatInput.text;
    MessageDto message = MessageDto(current.uid, widget.uid2, text, DateTime.now());
    _chatInput.text = '';
    await _chatService.addMessage(widget.chatId, message);
  }
}