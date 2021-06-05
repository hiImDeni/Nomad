import 'package:experience_exchange_app/features/pages/chats-page.dart';
import 'package:experience_exchange_app/features/pages/connections-page.dart';
import 'package:experience_exchange_app/features/pages/edit-profile-page.dart';
import 'package:experience_exchange_app/features/pages/requests-page.dart';
import 'package:experience_exchange_app/logic/services/authentication-service.dart';
import 'package:experience_exchange_app/logic/services/user-service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DrawerWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return DrawerState();
  }

}

class DrawerState extends State<DrawerWidget>{
  UserService _userService;

  @override
  Widget build(BuildContext context) {
    final _firebaseUser = context.watch<User>();
    _userService =  Provider.of<UserService>(context, listen: false);

    return Drawer(
      child:
      Column(
        // padding: EdgeInsets.zero,
        children: <Widget>[
          SafeArea(child:
          ListTile( title: Text('Menu', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20,),)),
          ),
          Divider(),
          ListTile(
            title: Text('Edit Profile'),
            onTap: () async {
              await _goToEditProfile(_firebaseUser);
            },
          ),
          ListTile(
            title: Text('Chats'),
            onTap: () async { _gotToChats(); },
          ),
          ListTile(
            title: Text('Connections'),
            onTap: () async { _gotToConnections(); },
          ),
          ListTile(
            title: Text('Requests'),
            trailing: FutureBuilder(
              future: _userService.getNumberOfRequests(_firebaseUser.uid),
              builder: (context, snapshot){
                int requests = 0;
                if (snapshot.hasData) {
                  requests = snapshot.data;
                }
                return Padding(
                    padding: EdgeInsets.only(top: 10, bottom: 10),
                    child: CircleAvatar(
                      child: Text(requests.toString(), style: TextStyle(color: Colors.white, fontSize: 10),),
                      backgroundColor: Colors.redAccent,
                    ));
              },
            ),
            onTap: () async{
              await _goToRequests();
            },
          ),
          Divider(),
          ListTile(
            title: Text('Sign out'),
            onTap: () {
              Navigator.pop(context);
              AuthenticationService().signOut();
            },
          ),
        ],
      ),
    );
  }


  _goToEditProfile(User firebaseUser) async {
    Navigator.pop(context);
    var currentUser = await _userService.getById(firebaseUser.uid);
    Navigator.push(context, MaterialPageRoute(builder: (context) { return EditProfilePage(user: currentUser); }));
  }

  _gotToChats() async {
    Navigator.pop(context);
    await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return ChatsPage();
    }));
  }

  _goToRequests() async{
    Navigator.pop(context);
    await Navigator.push(context, MaterialPageRoute(builder: (context) { return RequestsPage(); }));
  }

  _gotToConnections() async {
    Navigator.pop(context);
    await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return ConnectionsPage();
    }));
  }
}