import 'package:experience_exchange_app/features/pages/chat.dart';
import 'package:experience_exchange_app/features/widgets/user.dart';
import 'package:experience_exchange_app/logic/services/chat-service.dart';
import 'package:experience_exchange_app/logic/services/user-service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../scheme.dart';

class SearchInput extends StatefulWidget {
  TextEditingController textEditingController;
  String get text { return this.textEditingController.text; }

  String label;
  Function validator;
  Function action;

  SearchInput({this.label, this.validator, this.action}) { textEditingController = TextEditingController(); }

  @override
  State<StatefulWidget> createState() {
    return SearchInputState();
  }

}

class SearchInputState extends State<SearchInput> {
  UserService _userService;
  ChatService _chatService;

  SearchInputState();

  @override
  Widget build(BuildContext context) {
    _userService = Provider.of<UserService>(context);
    _chatService = Provider.of<ChatService>(context);

    return
      Container(
        height: 40,
        child:
        TextField(
          //todo
        controller: widget.textEditingController,
          onChanged: (text) => widget.action,
          decoration: InputDecoration(hintText: widget.label,
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
            prefixIcon: IconButton(icon: Icon(Icons.search),
              // onPressed: () async {
              //   await _search(widget.textEditingController.text);
              // },
            ),
          ),
        )
    );
  }

  _search(String text) async {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height,
          child: FutureBuilder(
            future: _userService.searchByName(text),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Text(snapshot.error.toString());
              }
              if (snapshot.hasData) {
                var result = snapshot.data;

                return SingleChildScrollView(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
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
                        ElevatedButton(
                          child: const Text('Close BottomSheet'),
                          onPressed: () => Navigator.pop(context),
                        )
                      ],
                    ),),);
              }
              return CircularProgressIndicator();
            }
          )
        );
      },
    );
  }
}