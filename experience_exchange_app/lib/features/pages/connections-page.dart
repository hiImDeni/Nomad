import 'package:experience_exchange_app/common/connection-status.dart';
import 'package:experience_exchange_app/common/domain/dtos/connection/connectiondto.dart';
import 'package:experience_exchange_app/common/domain/dtos/user/userdto.dart';
import 'package:experience_exchange_app/features/pages/chats-page.dart';
import 'package:experience_exchange_app/features/pages/profile-page.dart';
import 'package:experience_exchange_app/logic/services/chat-service.dart';
import 'package:experience_exchange_app/logic/services/connection-service.dart';
import 'package:experience_exchange_app/logic/services/user-service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../common/scheme.dart';
import 'chat.dart';

class ConnectionsPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ConnectionsPageState();
  }

}

class ConnectionsPageState extends State<ConnectionsPage> {
  UserService _userService;
  ConnectionService _connectionService;
  ChatService _chatService;

  User _firebaseUser;

  @override
  Widget build(BuildContext context) {
    _firebaseUser = context.watch<User>();

    _userService = Provider.of<UserService>(context);
    _chatService = Provider.of<ChatService>(context);
    _connectionService = Provider.of<ConnectionService>(context);

    return Scaffold(
        body: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Container(
                color: Scheme.backgroundColor,
                margin: EdgeInsets.only(left: 15, right: 15),
                height: MediaQuery
                    .of(context).size.height,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SafeArea(
                        child:
                        Padding(padding: EdgeInsets.only(top:10, bottom: 10),
                            child: Row(
                              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Connections', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),),
                              ],
                            )
                        )
                    ),

                    FutureBuilder(
                      future: _connectionService.getConnectionsForUid(_firebaseUser.uid),
                      builder: (context, snapshot) {
                        if (snapshot.hasError)  {
                          return Text(snapshot.error.toString());
                        }

                        if (snapshot.hasData) {
                          var connections = <ConnectionDto>[];

                          snapshot.data.forEach((doc) {
                            connections.add(doc);
                          });
                          return ListView.builder(
                            shrinkWrap: true,
                            physics: BouncingScrollPhysics(),
                            itemCount: connections.length,
                            itemBuilder: (context, index) {
                              String uid2 = _firebaseUser.uid != connections[index].uid1
                                              ? connections[index].uid1
                                              : connections[index].uid2;

                              return FutureBuilder(
                                  future: _userService.getById(uid2),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasError) {
                                      return Text(snapshot.error.toString());
                                    }

                                    if (snapshot.hasData) {
                                      UserDto user = snapshot.data;

                                      return ListTile(
                                          onTap: () async {
                                            await Navigator.push(context,
                                                MaterialPageRoute(builder: (context) {
                                                  return Scaffold(body:ProfilePage(uid: uid2));
                                                }
                                                ));
                                          },
                                          leading: CircleAvatar(backgroundImage: NetworkImage(user.photoUrl),),
                                          title: Text('${user.firstName} ${user.lastName}'),
                                          trailing: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                IconButton(
                                                    onPressed: () async {
                                                      String chatId;
                                                      chatId = await _chatService.getChat(_firebaseUser.uid, uid2).then((
                                                          value) {
                                                        chatId = value;
                                                        return value;
                                                      });
                                                      if (chatId == null)
                                                        chatId = await _chatService.createChat(
                                                            _firebaseUser.uid, uid2);
                                                      Navigator.push(context,
                                                          MaterialPageRoute(builder: (context) {
                                                            return Chat(chatId: chatId, user: user, uid2: uid2);
                                                          }
                                                          ));
                                                    },
                                                    icon: Icon(Icons.message_outlined, color: Colors.green,)),

                                                IconButton(
                                                    onPressed: () async {
                                                      await _connectionService.deleteConnection(
                                                          ConnectionDto(uid2, _firebaseUser.uid, null, ConnectionStatus.Accepted));
                                                    },
                                                    icon: Icon(Icons.clear, color: Colors.redAccent,)),
                                              ]
                                          ));
                                    }

                                    return Center(child: CircularProgressIndicator(),);
                                  });
                            },
                          );
                        }

                        return Center(
                          child: Center(child: CircularProgressIndicator()),
                        );
                      },
                    )
                  ],
                )
            )
        )
    );
  }

}