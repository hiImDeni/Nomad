import 'package:experience_exchange_app/common/domain/dtos/user/userdto.dart';
import 'package:experience_exchange_app/features/widgets/search-input.dart';
import 'package:experience_exchange_app/features/widgets/user.dart';
import 'package:experience_exchange_app/logic/services/chat-service.dart';
import 'package:experience_exchange_app/logic/services/user-service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../scheme.dart';
import 'chat.dart';


class ChatsPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ChatsPageState();
  }

}

class ChatsPageState extends State<ChatsPage> {
  UserService _userService;
  ChatService _chatService;

  SearchInput _searchInput;
  Future<List<UserDto>> _usersFuture;

  TextEditingController _textEditingController;

  @override
  Widget build(BuildContext context) {
    final User firebaseUser = context.watch<User>();

    _userService = Provider.of<UserService>(context);
    _chatService = Provider.of<ChatService>(context);

    _searchInput = SearchInput(label: 'Search user', action: (text) => searchUsers(text),);
    _textEditingController = TextEditingController();

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
                          Padding(padding: EdgeInsets.only(left: 10, right: 10), child:
                            CircleAvatar(backgroundImage: NetworkImage(firebaseUser.photoURL),),
                          ),
                          Text('Chats', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),),
                        ],
                      )
                    )
                ),
                Container(
                    height: 40,
                    child:
                    TextField(
                      controller: _textEditingController,
                      onChanged: (text) { searchUsers(text); },
                      decoration: InputDecoration(hintText: 'Search users',
                        contentPadding: EdgeInsets.only(
                          // bottom: 20,
                            left: 20,
                            right: 20
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide(color: Scheme.inputColor, width: 1.5),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide(color: Scheme.inactiveColor, width: 1.5),
                        ),
                        prefixIcon: IconButton(icon: Icon(Icons.search)),
                      ),
                    )
                ),

                _usersFuture == null ?
                StreamBuilder(
                    stream: _userService.getUsers(),
                    builder: (context, snapshot){
                      if (snapshot.hasError) {
                        return Text(snapshot.error.toString());
                      }

                      if (snapshot.hasData)
                      {
                        List users = [];

                        snapshot.data.docs.forEach((doc) {
                          users.add([doc.id, UserDto(
                              doc.data()['firstName'],
                              doc.data()['lastName'],
                              doc.data()['location'],
                              DateTime.tryParse(doc.data()['dateOfBirth']),
                              doc.data()['photoUrl']
                          )]);
                        });

                        return Expanded(
                          child: ListView.builder(
                            shrinkWrap: true,
                            physics: BouncingScrollPhysics(),
                            itemCount: users.length,
                            itemBuilder: (context, index) {
                              return UserWidget(user: users[index][1], goToPage: () async{
                                var uid = users[index][0]; //?
                                String chatId;
                                chatId = await _chatService.getChat(firebaseUser.uid, uid).then((value) {
                                  chatId = value;
                                  return value;
                                });
                                if (chatId == null)
                                  chatId = await _chatService.createChat(_userService.currentUser.uid, uid);
                                await Navigator.push(context, MaterialPageRoute(builder: (context) {
                                  return Chat(chatId: chatId, user: users[index][1], uid2: uid,);
                                }));
                              },);
                            },),
                        );
                      }

                      return CircularProgressIndicator();
                    }) :
                FutureBuilder(
                    future: _usersFuture,
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Text(snapshot.error.toString());
                      }
                      if (snapshot.hasData) {
                        var result = snapshot.data;

                        return Expanded(
                          child:
                                ListView.builder(
                                  itemCount: result.length,
                                  shrinkWrap: true,
                                  physics: BouncingScrollPhysics(),
                                  itemBuilder: (context, index) {
                                    return UserWidget(user: result[index], goToPage: () async{
                                      var uid = await _userService.getUid(result[index]);
                                      String chatId;
                                      chatId = await _chatService.getChat(_userService.currentUser.uid, uid).then((value) {
                                        chatId = value;
                                        return value;
                                      });
                                      if (chatId == null)
                                        chatId = await _chatService.createChat(_userService.currentUser.uid, uid);
                                      await Navigator.push(context, MaterialPageRoute(builder: (context) {
                                        return Chat(chatId: chatId, user: result[index], uid2: uid,);
                                      }));
                                    },);
                                  },
                                ),
                            );
                      }
                      return CircularProgressIndicator();
                    }
                ),
              ],
            )
        )
      )
    );
  }

  searchUsers(String text) async{
    // var users =  _userService.searchByName(_searchInput.text);
    setState(() {
      if (text != '') {
        _usersFuture = _userService.searchByName(text);
      }  else {
        _usersFuture = null;
      }
    });
  }
}