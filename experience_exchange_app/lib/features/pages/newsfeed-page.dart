import 'package:experience_exchange_app/common/domain/dtos/user/userdto.dart';
import 'package:experience_exchange_app/features/pages/profile-page.dart';
import 'package:experience_exchange_app/features/widgets/user.dart';
import 'package:experience_exchange_app/logic/services/user-service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../scheme.dart';

class NewsfeedPage extends StatefulWidget {
  const NewsfeedPage();

  @override
  State<StatefulWidget> createState() {
    return NewsfeedPageState();
  }

}

class NewsfeedPageState extends State<NewsfeedPage> {
  TextEditingController _textEditingController = TextEditingController();
  UserService _userService;
  Future<Map<String, UserDto>> _usersFuture;

  @override
  Widget build(BuildContext context) {
    final User firebaseUser = context.watch<User>();

    _userService = Provider.of<UserService>(context);

    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
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

          _usersFuture != null ?
              _showSearchResults() :
              _showFriendsPost(),
        ]
      )
    );
  }

  searchUsers(String text) {
    setState(() {
      if (text != '') {
        _usersFuture = _userService.searchByName(text);
      }  else {
        _usersFuture = null;
      }
    });
  }

  Widget _showSearchResults() {
    return FutureBuilder(
        future: _usersFuture,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          }
          if (snapshot.hasData) {
            var result = snapshot.data;

            List uids = result.keys.toList();
            List users = result.values.toList();

            return Expanded(
              child:
              ListView.builder(
                itemCount: result.length,
                shrinkWrap: true,
                physics: BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  return UserWidget(user: users[index], goToPage: () async{
                    await Navigator.push(context, MaterialPageRoute(builder: (context) {
                      return ProfilePage(uid: uids[index]);
                    }));
                  },);
                },
              ),
            );
          }
          return CircularProgressIndicator();
        }
    );
  }

  _showFriendsPost() {
    return Container();
  }
}